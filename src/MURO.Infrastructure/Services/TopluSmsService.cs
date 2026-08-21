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
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class TopluSmsService
{
    private readonly HttpClient _httpClient;
    private readonly MuroDbContext _context;
    private readonly ILogger<TopluSmsService> _logger;
    private const string BaseUrl = "https://api.toplusms.app/api/v1";

    public TopluSmsService(
        HttpClient httpClient,
        MuroDbContext context,
        ILogger<TopluSmsService> logger)
    {
        _httpClient = httpClient;
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Telefon numarasını Türkiye standardı 905xxxxxxxxx formatına dönüştürür.
    /// </summary>
    public static string NormalizePhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone)) return string.Empty;
        var digits = Regex.Replace(phone, @"\D", "");
        
        if (digits.StartsWith("90") && digits.Length == 12)
            return digits;
        if (digits.StartsWith("0") && digits.Length == 11)
            return "9" + digits;
        if (digits.Length == 10 && digits.StartsWith("5"))
            return "90" + digits;
        if (digits.Length == 12)
            return digits;
        
        return digits;
    }

    public async Task<TopluSmsConfigDto?> GetActiveConfigAsync(TopluSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        if (overrideConfig != null && !string.IsNullOrWhiteSpace(overrideConfig.ApiKey))
        {
            return overrideConfig;
        }

        var setting = await _context.IntegrationSettings
            .AsNoTracking()
            .FirstOrDefaultAsync(i => i.ProviderKey == "toplusms", ct);

        if (setting == null || !setting.IsEnabled || string.IsNullOrWhiteSpace(setting.ConfigJson))
        {
            return null;
        }

        try
        {
            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            return JsonSerializer.Deserialize<TopluSmsConfigDto>(setting.ConfigJson, options);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TopluSMS yapılandırması çözümlenemedi.");
            return null;
        }
    }

    public async Task<SmsSendResult> SendSmsAsync(SendSingleSmsRequest request, TopluSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(overrideConfig, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new SmsSendResult { Success = false, Message = "TopluSMS entegrasyonu aktif değil veya API Key girilmemiş." };
        }

        var cleanPhone = NormalizePhone(request.Phone);
        if (string.IsNullOrWhiteSpace(cleanPhone) || cleanPhone.Length < 10)
        {
            return new SmsSendResult { Success = false, Message = "Geçersiz telefon numarası. (Format: 905xxxxxxxxx olmalıdır)" };
        }

        var sender = !string.IsNullOrWhiteSpace(request.Sender) ? request.Sender : config.Sender;
        if (string.IsNullOrWhiteSpace(sender))
        {
            return new SmsSendResult { Success = false, Message = "Gönderici başlığı (Sender) belirlenmemiş." };
        }

        var endpoint = request.IsOtp ? $"{BaseUrl}/otp" : $"{BaseUrl}/1toN";
        object payload;

        if (request.IsOtp)
        {
            payload = new
            {
                api_key = config.ApiKey,
                sender = sender,
                message_type = config.MessageType ?? "normal",
                message = request.Message,
                phones = new[] { cleanPhone },
                add_cancel_link = config.AddCancelLink
            };
        }
        else
        {
            payload = new
            {
                api_key = config.ApiKey,
                sender = sender,
                message_type = config.MessageType ?? "normal",
                message_content_type = config.MessageContentType ?? "bilgi",
                message = request.Message,
                phones = new[] { cleanPhone },
                add_cancel_link = config.AddCancelLink
            };
        }

        var json = JsonSerializer.Serialize(payload);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        try
        {
            var response = await _httpClient.PostAsync(endpoint, content, ct);
            var resBody = await response.Content.ReadAsStringAsync(ct);

            _logger.LogInformation("TopluSMS Yanıtı ({StatusCode}): {Body}", response.StatusCode, resBody);

            if (!response.IsSuccessStatusCode)
            {
                return new SmsSendResult
                {
                    Success = false,
                    Message = $"TopluSMS API Hatası ({response.StatusCode}): {resBody}",
                    RawResponse = resBody
                };
            }

            string? reportId = null;
            string? status = "sent";
            string? msg = "SMS başarıyla gönderildi.";

            try
            {
                using var doc = JsonDocument.Parse(resBody);
                var root = doc.RootElement;
                if (root.TryGetProperty("data", out var dataEl))
                {
                    if (dataEl.TryGetProperty("report_id", out var rId)) reportId = rId.ToString();
                    else if (dataEl.TryGetProperty("id", out var dId)) reportId = dId.ToString();
                }
                else if (root.TryGetProperty("report_id", out var rIdTop))
                {
                    reportId = rIdTop.ToString();
                }

                if (root.TryGetProperty("status", out var st)) status = st.GetString();
                if (root.TryGetProperty("message", out var m)) msg = m.GetString();
            }
            catch { }

            return new SmsSendResult
            {
                Success = true,
                ReportId = reportId,
                Status = status,
                Message = msg ?? "SMS başarıyla kuyruğa alındı.",
                RawResponse = resBody
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TopluSMS gönderim hatası: {Phone}", cleanPhone);
            return new SmsSendResult { Success = false, Message = $"İletişim Hatası: {ex.Message}" };
        }
    }

    public async Task<SmsSendResult> SendBulkSmsAsync(SendBulkSmsRequest request, TopluSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(overrideConfig, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new SmsSendResult { Success = false, Message = "TopluSMS entegrasyonu aktif değil veya API Key girilmemiş." };
        }

        var cleanPhones = request.Phones
            .Select(NormalizePhone)
            .Where(p => !string.IsNullOrWhiteSpace(p) && p.Length >= 10)
            .Distinct()
            .ToList();

        if (cleanPhones.Count == 0)
        {
            return new SmsSendResult { Success = false, Message = "Geçerli bir telefon numarası listesi bulunamadı." };
        }

        var sender = !string.IsNullOrWhiteSpace(request.Sender) ? request.Sender : config.Sender;
        if (string.IsNullOrWhiteSpace(sender))
        {
            return new SmsSendResult { Success = false, Message = "Gönderici başlığı (Sender) belirlenmemiş." };
        }

        var payload = new
        {
            api_key = config.ApiKey,
            sender = sender,
            message_type = config.MessageType ?? "normal",
            message_content_type = config.MessageContentType ?? "bilgi",
            message = request.Message,
            phones = cleanPhones,
            add_cancel_link = config.AddCancelLink
        };

        var json = JsonSerializer.Serialize(payload);
        var content = new StringContent(json, Encoding.UTF8, "application/json");

        try
        {
            var response = await _httpClient.PostAsync($"{BaseUrl}/1toN", content, ct);
            var resBody = await response.Content.ReadAsStringAsync(ct);

            _logger.LogInformation("TopluSMS Toplu Gönderim Yanıtı ({StatusCode}): {Body}", response.StatusCode, resBody);

            if (!response.IsSuccessStatusCode)
            {
                return new SmsSendResult
                {
                    Success = false,
                    Message = $"TopluSMS Hatası ({response.StatusCode}): {resBody}",
                    RawResponse = resBody
                };
            }

            string? reportId = null;
            string? status = "sent";
            string? msg = $"{cleanPhones.Count} kişiye SMS gönderimi başlatıldı.";

            try
            {
                using var doc = JsonDocument.Parse(resBody);
                var root = doc.RootElement;
                if (root.TryGetProperty("data", out var dataEl))
                {
                    if (dataEl.TryGetProperty("report_id", out var rId)) reportId = rId.ToString();
                    else if (dataEl.TryGetProperty("id", out var dId)) reportId = dId.ToString();
                }
                else if (root.TryGetProperty("report_id", out var rIdTop))
                {
                    reportId = rIdTop.ToString();
                }

                if (root.TryGetProperty("status", out var st)) status = st.GetString();
                if (root.TryGetProperty("message", out var m)) msg = m.GetString();
            }
            catch { }

            return new SmsSendResult
            {
                Success = true,
                ReportId = reportId,
                Status = status,
                Message = msg,
                RawResponse = resBody
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TopluSMS toplu gönderim hatası");
            return new SmsSendResult { Success = false, Message = $"İletişim Hatası: {ex.Message}" };
        }
    }

    public async Task<SmsAccountInfoResult> GetAccountInfoAsync(TopluSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(overrideConfig, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new SmsAccountInfoResult { Success = false, Message = "TopluSMS API Key girilmemiş." };
        }

        var payload = new { api_key = config.ApiKey };
        var jsonContent = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        try
        {
            // 1. Kullanıcı bilgisi ve bakiye sorgusu
            var userRes = await _httpClient.PostAsync($"{BaseUrl}/user/information", jsonContent, ct);
            var userBody = await userRes.Content.ReadAsStringAsync(ct);

            _logger.LogInformation("TopluSMS User Information: {Body}", userBody);

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

                    if (dataNode.TryGetProperty("sms", out var smsVal)) balance = smsVal.ToString() ?? "0";
                    else if (dataNode.TryGetProperty("sms_credit", out var sc)) balance = sc.ToString() ?? "0";
                    else if (dataNode.TryGetProperty("balance", out var b)) balance = b.ToString() ?? "0";
                    else if (dataNode.TryGetProperty("credit", out var cr)) balance = cr.ToString() ?? "0";
                }
                else
                {
                    if (root.TryGetProperty("name", out var n)) customerName = n.GetString() ?? "";
                    if (root.TryGetProperty("sms", out var smsVal)) balance = smsVal.ToString() ?? "0";
                    else if (root.TryGetProperty("balance", out var b)) balance = b.ToString() ?? "0";
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
                Message = "Bağlantı başarılı. Hesap bilgileri ve başlıklar getirildi."
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TopluSMS hesap bilgisi sorgulanırken hata oluştu.");
            return new SmsAccountInfoResult { Success = false, Message = $"Bağlantı Hatası: {ex.Message}" };
        }
    }

    public async Task<List<string>> GetSendersAsync(TopluSmsConfigDto? overrideConfig = null, CancellationToken ct = default)
    {
        var config = await GetActiveConfigAsync(overrideConfig, ct);
        if (config == null || string.IsNullOrWhiteSpace(config.ApiKey))
        {
            return new List<string>();
        }

        var payload = new { api_key = config.ApiKey };
        var jsonContent = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

        try
        {
            var res = await _httpClient.PostAsync($"{BaseUrl}/senders", jsonContent, ct);
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
                        if (item.TryGetProperty("sender", out var sProp))
                        {
                            var val = sProp.GetString();
                            if (!string.IsNullOrWhiteSpace(val)) sendersList.Add(val);
                        }
                        else if (item.TryGetProperty("title", out var tProp))
                        {
                            var val = tProp.GetString();
                            if (!string.IsNullOrWhiteSpace(val)) sendersList.Add(val);
                        }
                    }
                }
            }

            return sendersList.Distinct().ToList();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "TopluSMS başlıkları sorgulanırken hata oluştu.");
            return new List<string>();
        }
    }
}
