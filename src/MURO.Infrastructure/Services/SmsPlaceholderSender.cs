using System;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MURO.Application.DTOs.Integrations;
using MURO.Application.Interfaces;

namespace MURO.Infrastructure.Services;

/// <summary>
/// Sistem genelindeki ISmsSender çağrılarını aktif Vatan SMS / Entegrasyon servisine yönlendirir.
/// </summary>
public class SmsPlaceholderSender : ISmsSender
{
    private readonly ISmsService _smsService;
    private readonly TopluSmsService _topluSmsService;
    private readonly IConfiguration _config;
    private readonly ILogger<SmsPlaceholderSender> _logger;

    public SmsPlaceholderSender(
        ISmsService smsService,
        TopluSmsService topluSmsService,
        IConfiguration config, 
        ILogger<SmsPlaceholderSender> logger)
    {
        _smsService = smsService;
        _topluSmsService = topluSmsService;
        _config = config;
        _logger = logger;
    }

    public async Task SendAsync(string phoneNumber, string message)
    {
        try
        {
            var req = new SendSingleSmsRequest
            {
                Phone = phoneNumber,
                Message = message
            };

            var toplusms = await _topluSmsService.GetActiveConfigAsync();
            SmsSendResult res;
            if (toplusms != null)
            {
                res = await _topluSmsService.SendSmsAsync(req, toplusms);
            }
            else
            {
                res = await _smsService.SendSmsAsync(req);
            }

            if (res.Success)
            {
                _logger.LogInformation("SMS başarıyla iletildi: {Phone} (Rapor: {Id})", phoneNumber, res.ReportId);
            }
            else
            {
                _logger.LogWarning("SMS gönderilemedi: {Phone} - {Msg}", phoneNumber, res.Message);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "SMS servisi çağrılırken hata: {Phone}", phoneNumber);
        }
    }
}
