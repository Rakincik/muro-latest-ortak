using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MURO.Application.DTOs.Integrations;
using MURO.Application.Interfaces;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class VatanSmsService : ISmsService
{
    private readonly HttpClient _httpClient;
    private readonly MuroDbContext _context;
    private readonly ILogger<VatanSmsService> _logger;
    private const string BaseUrl = "https://api.vatansms.net/api/v1";

    public VatanSmsService(
        HttpClient httpClient,
        MuroDbContext context,
        ILogger<VatanSmsService> logger)
    {
        _httpClient = httpClient;
        _context = context;
        _logger = logger;
    }

    private static string NormalizePhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone)) return string.Empty;
        var digits = Regex.Replace(phone, @"\D", "");
        if (digits.StartsWith("90") && digits.Length == 12) digits = digits.Substring(2);
        else if (digits.StartsWith("0") && digits.Length == 11) digits = digits.Substring(1);
        return digits;
    }

    private async Task<VatanSmsConfigDto?> GetActiveConfigAsync(VatanSmsConfigDto? overrideConfig, CancellationToken ct)
    {
        if (overrideConfig != null && !string.IsNullOrWhiteSpace(overrideConfig.ApiId) && !string.IsNullOrWhiteSpace(overrideConfig.ApiKey))
        {
            return overrideConfig;
        }

        var setting = await _context.IntegrationSettings
            .AsNoTracking()
            .FirstOrDefaultAsync(i => i.ProviderKey == "vatansms", ct);

        if (setting == null || !setting.IsEnabled || string.IsNullOrWhiteSpace(setting.ConfigJson))
        {
            return null;
        }

        try
        {
            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            return JsonSerializer.Deserialize<VatanSmsConfigDto>(setting.ConfigJson, options);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Vatan SMS yapılandırması çözümlenemedi.");
            return null;
        }
    }

    public async Task<SmsSendResult> SendSmsAsync(SendSingleSmsRequest request, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(null, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiId) || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new SmsSendResult { Success = false, Message = "Vatan SMS entegrasyonu aktif değil veya eksik yapılandırılmış." };
        }

        var cleanPhone = NormalizePhone(request.Phone);
        if (string.IsNullOrWhiteSpace(cleanPhone) || cleanPhone.Length != 10)
        {
            return new SmsSendResult { Success = false, Message = "Geçersiz telefon numarası. (10 haneli format: 5xxxxxxxxx olmalıdır)" };
        }

        var sender = !string.IsNullOrWhiteSpace(request.Sender) ? request.Sender : config.Sender;
        if (string.IsNullOrWhiteSpace(sender))
        {
            return new SmsSendResult { Success = false, Message = "Gönderici başlığı (Sender) belirlenmemiş." };
        }

        var client = _httpClient;
        var payload = new
        {
            api_id = config.ApiId,
            api_key = config.ApiKey,
            sender = sender,
            message_type = config.MessageType ?? "normal",
            message = request.Message,
            message_content_type = config.MessageContentType ?? "bilgi",
            phones = new[] { cleanPhone }
        };

        try
        {
            var content = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");
            var response = await client.PostAsync($"{BaseUrl}/1toN", content, ct);
            var resBody = await response.Content.ReadAsStringAsync(ct);

            _logger.LogInformation("VatanSMS 1toN Yanıtı ({StatusCode}): {Body}", response.StatusCode, resBody);

            if (!response.IsSuccessStatusCode)
            {
                return new SmsSendResult { Success = false, Message = $"VatanSMS API Hatası ({response.StatusCode}): {resBody}", RawResponse = resBody };
            }

            using var doc = JsonDocument.Parse(resBody);
            var root = doc.RootElement;
            var status = root.TryGetProperty("status", out var s) ? s.GetString() : "unknown";
            var msg = root.TryGetProperty("message", out var m) ? m.GetString() : "";
            var reportId = root.TryGetProperty("id", out var idProp) ? idProp.ToString() : null;

            var isSuccess = string.Equals(status, "success", StringComparison.OrdinalIgnoreCase) || 
                            string.Equals(status, "ok", StringComparison.OrdinalIgnoreCase) ||
                            reportId != null;

            return new SmsSendResult
            {
                Success = isSuccess,
                Status = status,
                Message = isSuccess ? "SMS başarıyla gönderildi." : (msg ?? "SMS gönderilemedi."),
                ReportId = reportId,
                RawResponse = resBody
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Vatan SMS gönderiminde hata oluştu: {Phone}", cleanPhone);
            return new SmsSendResult { Success = false, Message = $"Bağlantı Hatası: {ex.Message}" };
        }
    }

    public async Task<SmsSendResult> SendBulkSmsAsync(SendBulkSmsRequest request, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(null, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiId) || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new SmsSendResult { Success = false, Message = "Vatan SMS entegrasyonu aktif değil veya yapılandırılmamış." };
        }

        var cleanPhones = request.Phones
            .Select(NormalizePhone)
            .Where(p => !string.IsNullOrWhiteSpace(p) && p.Length == 10)
            .Distinct()
            .ToList();

        if (!cleanPhones.Any())
        {
            return new SmsSendResult { Success = false, Message = "Gönderilecek geçerli telefon numarası bulunamadı." };
        }

        var sender = !string.IsNullOrWhiteSpace(request.Sender) ? request.Sender : config.Sender;
        var client = _httpClient;

        var payloadDict = new Dictionary<string, object>
        {
            ["api_id"] = config.ApiId,
            ["api_key"] = config.ApiKey,
            ["sender"] = sender,
            ["message_type"] = config.MessageType ?? "normal",
            ["message"] = request.Message,
            ["message_content_type"] = config.MessageContentType ?? "bilgi",
            ["phones"] = cleanPhones
        };

        if (!string.IsNullOrWhiteSpace(request.SendTime))
        {
            payloadDict["send_time"] = request.SendTime;
        }

        try
        {
            var content = new StringContent(JsonSerializer.Serialize(payloadDict), Encoding.UTF8, "application/json");
            var response = await client.PostAsync($"{BaseUrl}/1toN", content, ct);
            var resBody = await response.Content.ReadAsStringAsync(ct);

            _logger.LogInformation("VatanSMS Toplu SMS Yanıtı ({StatusCode}): {Body}", response.StatusCode, resBody);

            using var doc = JsonDocument.Parse(resBody);
            var root = doc.RootElement;
            var status = root.TryGetProperty("status", out var s) ? s.GetString() : "unknown";
            var msg = root.TryGetProperty("message", out var m) ? m.GetString() : "";
            var reportId = root.TryGetProperty("id", out var idProp) ? idProp.ToString() : null;

            var isSuccess = string.Equals(status, "success", StringComparison.OrdinalIgnoreCase) || reportId != null;

            return new SmsSendResult
            {
                Success = isSuccess,
                Status = status,
                Message = isSuccess ? $"{cleanPhones.Count} kişiye SMS gönderildi." : (msg ?? "SMS gönderilemedi."),
                ReportId = reportId,
                RawResponse = resBody
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Vatan SMS toplu gönderim hatası");
            return new SmsSendResult { Success = false, Message = $"Bağlantı Hatası: {ex.Message}" };
        }
    }

    public async Task<SmsSendResult> SendOtpAsync(string phone, string code, CancellationToken ct = default)
    {
        var message = $"Doğrulama kodunuz: {code}. Bu kodu kimseyle paylaşmayınız.";
        return await SendSmsAsync(new SendSingleSmsRequest { Phone = phone, Message = message, IsOtp = true }, ct);
    }

    public async Task<SmsAccountInfoResult> GetAccountInfoAsync(VatanSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(overrideConfig, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiId) || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new SmsAccountInfoResult { Success = false, Message = "Vatan SMS API ID ve API Key bilgileri girilmemiş." };
        }

        var client = _httpClient;
        var payload = new { api_id = config.ApiId, api_key = config.ApiKey };
        var jsonContent = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        try
        {
            // 1. Kullanıcı bilgisi ve bakiye sorgusu
            var userRes = await client.PostAsync($"{BaseUrl}/user/information", jsonContent, ct);
            var userBody = await userRes.Content.ReadAsStringAsync(ct);

            _logger.LogInformation("VatanSMS User Information: {Body}", userBody);

            string customerName = "";
            string balance = "0";

            if (userRes.IsSuccessStatusCode)
            {
                using var doc = JsonDocument.Parse(userBody);
                var root = doc.RootElement;
                if (root.TryGetProperty("data", out var dataNode))
                {
                    if (dataNode.TryGetProperty("name", out var n)) customerName = n.GetString() ?? "";
                    else if (dataNode.TryGetProperty("user_name", out var un)) customerName = un.GetString() ?? "";

                    if (dataNode.TryGetProperty("balance", out var b)) balance = b.ToString() ?? "0";
                    else if (dataNode.TryGetProperty("sms_balance", out var sb)) balance = sb.ToString() ?? "0";
                }
                else
                {
                    if (root.TryGetProperty("name", out var n)) customerName = n.GetString() ?? "";
                    if (root.TryGetProperty("balance", out var b)) balance = b.ToString() ?? "0";
                }
            }
            else
            {
                return new SmsAccountInfoResult 
                { 
                    Success = false, 
                    Message = $"API Doğrulama Hatası ({userRes.StatusCode}): {userBody}" 
                };
            }

            // 2. Onaylı Gönderici Başlıklarını (Senders) Çek
            var senders = await GetSendersAsync(config, ct);

            return new SmsAccountInfoResult
            {
                Success = true,
                CustomerName = customerName,
                Balance = balance,
                Senders = senders,
                Message = "Bağlantı başarılı. Hesap bilgileri ve başlıklar güncellendi."
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Vatan SMS hesap bilgisi sorgulanırken hata oluştu.");
            return new SmsAccountInfoResult { Success = false, Message = $"Bağlantı Hatası: {ex.Message}" };
        }
    }

    public async Task<List<string>> GetSendersAsync(VatanSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(overrideConfig, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiId) || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new List<string>();
        }

        var client = _httpClient;
        var payload = new { api_id = config.ApiId, api_key = config.ApiKey };
        var jsonContent = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        try
        {
            var res = await client.PostAsync($"{BaseUrl}/senders", jsonContent, ct);
            if (!res.IsSuccessStatusCode) return new List<string>();

            var body = await res.Content.ReadAsStringAsync(ct);
            using var doc = JsonDocument.Parse(body);
            var root = doc.RootElement;

            var sendersList = new List<string>();
            if (root.TryGetProperty("data", out var dataNode) && dataNode.ValueKind == JsonValueKind.Array)
            {
                foreach (var item in dataNode.EnumerateArray())
                {
                    if (item.ValueKind == JsonValueKind.String)
                    {
                        var val = item.GetString();
                        if (!string.IsNullOrWhiteSpace(val)) sendersList.Add(val);
                    }
                    else if (item.ValueKind == JsonValueKind.Object)
                    {
                        if (item.TryGetProperty("sender", out var s1)) sendersList.Add(s1.GetString() ?? "");
                        else if (item.TryGetProperty("name", out var s2)) sendersList.Add(s2.GetString() ?? "");
                        else if (item.TryGetProperty("title", out var s3)) sendersList.Add(s3.GetString() ?? "");
                    }
                }
            }
            else if (root.ValueKind == JsonValueKind.Array)
            {
                foreach (var item in root.EnumerateArray())
                {
                    var val = item.GetString();
                    if (!string.IsNullOrWhiteSpace(val)) sendersList.Add(val);
                }
            }

            return sendersList.Where(s => !string.IsNullOrWhiteSpace(s)).Distinct().ToList();
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Vatan SMS başlıkları çekilemedi.");
            return new List<string>();
        }
    }
}
