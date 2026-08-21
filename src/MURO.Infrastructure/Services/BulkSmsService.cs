using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MURO.Application.DTOs.Integrations;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class BulkSmsService : IBulkSmsService
{
    private readonly MuroDbContext _context;
    private readonly ISmsService _smsService;
    private readonly IConfiguration _config;
    private readonly ILogger<BulkSmsService> _logger;

    public BulkSmsService(
        MuroDbContext context,
        ISmsService smsService,
        IConfiguration config,
        ILogger<BulkSmsService> logger)
    {
        _context = context;
        _smsService = smsService;
        _config = config;
        _logger = logger;
    }

    private static string NormalizePhone(string? phone)
    {
        if (string.IsNullOrWhiteSpace(phone)) return string.Empty;
        var digits = Regex.Replace(phone, @"\D", "");
        if (digits.StartsWith("90") && digits.Length == 12) digits = digits.Substring(2);
        else if (digits.StartsWith("0") && digits.Length == 11) digits = digits.Substring(1);
        return digits;
    }

    private string GetTenantLoginUrl()
    {
        var url = _config["App:StudentUrl"] ?? _config["AdminUrl"] ?? "https://ogrenci.muro.click";
        return url.TrimEnd('/');
    }

    private async Task<string> GetTenantNameAsync()
    {
        var settings = await _context.SystemSettings.AsNoTracking().FirstOrDefaultAsync();
        return settings?.TenantName ?? "MURO";
    }

    public async Task<SmsTriggerSettingsDto> GetTriggerSettingsAsync(CancellationToken ct = default)
    {
        var setting = await _context.IntegrationSettings
            .AsNoTracking()
            .FirstOrDefaultAsync(i => i.ProviderKey == "vatansms", ct);

        if (setting == null || string.IsNullOrWhiteSpace(setting.TriggerSettingsJson))
        {
            return new SmsTriggerSettingsDto();
        }

        try
        {
            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            return JsonSerializer.Deserialize<SmsTriggerSettingsDto>(setting.TriggerSettingsJson, options) ?? new SmsTriggerSettingsDto();
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "Tetikleyici ayarları çözümlenemedi.");
            return new SmsTriggerSettingsDto();
        }
    }

    public async Task<SmsTriggerSettingsDto> UpdateTriggerSettingsAsync(SmsTriggerSettingsDto settings, CancellationToken ct = default)
    {
        var setting = await _context.IntegrationSettings.FirstOrDefaultAsync(i => i.ProviderKey == "vatansms", ct);
        var json = JsonSerializer.Serialize(settings);

        if (setting != null)
        {
            setting.TriggerSettingsJson = json;
            setting.UpdatedAt = DateTime.UtcNow;
            _context.IntegrationSettings.Update(setting);
        }
        else
        {
            setting = new IntegrationSetting
            {
                Id = Guid.NewGuid(),
                ProviderKey = "vatansms",
                Category = "SMS",
                Title = "Vatan SMS",
                IsEnabled = false,
                TriggerSettingsJson = json,
                UpdatedAt = DateTime.UtcNow
            };
            _context.IntegrationSettings.Add(setting);
        }

        await _context.SaveChangesAsync(ct);
        return settings;
    }

    private string RenderMessage(string template, User user, string targetName, string tenantName, string loginUrl, string? rawPassword = null)
    {
        return template
            .Replace("{ad}", user.FirstName ?? "")
            .Replace("{soyad}", user.LastName ?? "")
            .Replace("{ad_soyad}", $"{user.FirstName} {user.LastName}".Trim())
            .Replace("{kullanici_adi}", user.Username ?? user.Email ?? "")
            .Replace("{telefon}", user.Phone ?? "")
            .Replace("{kurs}", targetName)
            .Replace("{kurum_adi}", tenantName)
            .Replace("{tarih}", DateTime.Now.ToString("dd.MM.yyyy"))
            .Replace("{giris_linki}", loginUrl)
            .Replace("{sifre}", rawPassword ?? "******");
    }

    private async Task<List<(User user, string targetName)>> ResolveRecipientsAsync(BulkSmsCampaignRequest request, CancellationToken ct)
    {
        var list = new List<(User user, string targetName)>();

        if (request.TargetType == "course" && request.TargetIds.Any())
        {
            var courseMap = await _context.Courses
                .AsNoTracking()
                .Where(c => request.TargetIds.Contains(c.Id))
                .ToDictionaryAsync(c => c.Id, c => c.Title, ct);

            var members = await _context.CourseGroups
                .Where(cg => request.TargetIds.Contains(cg.CourseId))
                .Join(
                    _context.GroupMembers.Include(gm => gm.User).Where(gm => gm.Status == "active" && gm.User.IsActive),
                    cg => cg.GroupId,
                    gm => gm.GroupId,
                    (cg, gm) => new { gm.User, cg.CourseId }
                )
                .ToListAsync(ct);

            foreach (var item in members)
            {
                if (item.User != null)
                {
                    var courseTitle = courseMap.TryGetValue(item.CourseId, out var t) ? t : "Kurs";
                    list.Add((item.User, courseTitle));
                }
            }
        }
        else if (request.TargetType == "package" && request.TargetIds.Any())
        {
            var userPackages = await _context.UserPackages
                .Include(up => up.User)
                .Include(up => up.Package)
                .Where(up => request.TargetIds.Contains(up.PackageId) && 
                             up.Status == "active" && 
                             (up.ExpiresAt == null || up.ExpiresAt > DateTime.UtcNow) && 
                             up.User.IsActive)
                .ToListAsync(ct);

            foreach (var up in userPackages)
            {
                if (up.User != null)
                {
                    list.Add((up.User, up.Package?.Name ?? "Paket"));
                }
            }
        }
        else if (request.TargetType == "group" && request.TargetIds.Any())
        {
            var groupMembers = await _context.GroupMembers
                .Include(gm => gm.User)
                .Include(gm => gm.Group)
                .Where(gm => request.TargetIds.Contains(gm.GroupId) && gm.Status == "active" && gm.User.IsActive)
                .ToListAsync(ct);

            foreach (var gm in groupMembers)
            {
                if (gm.User != null)
                {
                    list.Add((gm.User, gm.Group?.Name ?? "Grup"));
                }
            }
        }
        else if (request.TargetType == "all")
        {
            var students = await _context.Users
                .Where(u => u.Role == UserRole.Student && u.IsActive)
                .ToListAsync(ct);

            foreach (var s in students)
            {
                list.Add((s, "Tüm Öğrenciler"));
            }
        }

        // Tekilleştirme (User ID'ye göre)
        return list
            .GroupBy(x => x.user.Id)
            .Select(g => g.First())
            .ToList();
    }

    public async Task<BulkSmsPreviewResult> PreviewRecipientsAsync(BulkSmsCampaignRequest request, CancellationToken ct = default)
    {
        var tenantName = await GetTenantNameAsync();
        var loginUrl = GetTenantLoginUrl();
        var recipientPairs = await ResolveRecipientsAsync(request, ct);

        var previewItems = new List<SmsRecipientPreviewDto>();
        int validCount = 0;
        int invalidCount = 0;

        foreach (var (user, targetName) in recipientPairs)
        {
            var cleanPhone = NormalizePhone(user.Phone);
            var isValid = !string.IsNullOrWhiteSpace(cleanPhone) && cleanPhone.Length == 10 && cleanPhone.StartsWith("5");
            if (isValid) validCount++;
            else invalidCount++;

            var rendered = RenderMessage(request.MessageTemplate, user, targetName, tenantName, loginUrl);

            previewItems.Add(new SmsRecipientPreviewDto
            {
                UserId = user.Id,
                FullName = $"{user.FirstName} {user.LastName}".Trim(),
                Phone = user.Phone ?? "Belirtilmemiş",
                TargetName = targetName,
                RenderedMessage = rendered,
                IsValidPhone = isValid
            });
        }

        var sampleMsg = previewItems.FirstOrDefault()?.RenderedMessage ?? request.MessageTemplate;
        var charCount = sampleMsg.Length;
        var smsUnitsPerPerson = charCount <= 160 ? 1 : (int)Math.Ceiling(charCount / 153.0);
        var totalEstimatedUnits = validCount * smsUnitsPerPerson;

        return new BulkSmsPreviewResult
        {
            TotalRecipients = recipientPairs.Count,
            ValidPhonesCount = validCount,
            InvalidPhonesCount = invalidCount,
            EstimatedSmsUnits = totalEstimatedUnits,
            Recipients = previewItems.Take(100).ToList() // İlk 100 kişiyi önizleme için döndür
        };
    }

    public async Task<BulkSmsExecutionResult> SendBulkCampaignAsync(BulkSmsCampaignRequest request, CancellationToken ct = default)
    {
        var tenantName = await GetTenantNameAsync();
        var loginUrl = GetTenantLoginUrl();
        var recipientPairs = await ResolveRecipientsAsync(request, ct);

        if (!recipientPairs.Any())
        {
            return new BulkSmsExecutionResult { Success = false, Message = "Seçilen hedef kitlede öğrenci bulunamadı." };
        }

        var validRecipients = recipientPairs
            .Select(p => new
            {
                p.user,
                p.targetName,
                CleanPhone = NormalizePhone(p.user.Phone)
            })
            .Where(x => !string.IsNullOrWhiteSpace(x.CleanPhone) && x.CleanPhone.Length == 10 && x.CleanPhone.StartsWith("5"))
            .ToList();

        if (!validRecipients.Any())
        {
            return new BulkSmsExecutionResult { Success = false, Message = "Geçerli cep telefonu numarasına sahip öğrenci bulunamadı." };
        }

        _logger.LogInformation("Toplu SMS kampanyası başlatılıyor. Hedef Kitle: {Type}, Alıcı Sayısı: {Count}", request.TargetType, validRecipients.Count);

        // Kişiselleştirilmiş NtoN veya 1toN gönderimi
        var phoneList = validRecipients.Select(r => r.CleanPhone).Distinct().ToList();

        var hasPersonalizedFields = request.MessageTemplate.Contains("{ad}") || 
                                     request.MessageTemplate.Contains("{soyad}") || 
                                     request.MessageTemplate.Contains("{kullanici_adi}");

        if (!hasPersonalizedFields)
        {
            // Hızlı 1toN gönderim
            var staticMessage = RenderMessage(request.MessageTemplate, validRecipients.First().user, validRecipients.First().targetName, tenantName, loginUrl);
            var bulkRes = await _smsService.SendBulkSmsAsync(new SendBulkSmsRequest
            {
                Phones = phoneList,
                Message = staticMessage,
                Sender = request.Sender,
                SendTime = request.SendTime
            }, ct);

            return new BulkSmsExecutionResult
            {
                Success = bulkRes.Success,
                SentCount = bulkRes.Success ? phoneList.Count : 0,
                FailedCount = bulkRes.Success ? 0 : phoneList.Count,
                ReportId = bulkRes.ReportId,
                Message = bulkRes.Message ?? (bulkRes.Success ? $"{phoneList.Count} öğrenciye SMS iletildi." : "SMS gönderilemedi.")
            };
        }
        else
        {
            // Kişiselleştirilmiş SMS'leri tek tek gönder
            int successCount = 0;
            int failCount = 0;

            foreach (var r in validRecipients)
            {
                var personalMessage = RenderMessage(request.MessageTemplate, r.user, r.targetName, tenantName, loginUrl);
                var sendRes = await _smsService.SendSmsAsync(new SendSingleSmsRequest
                {
                    Phone = r.CleanPhone,
                    Message = personalMessage,
                    Sender = request.Sender
                }, ct);

                if (sendRes.Success) successCount++;
                else failCount++;
            }

            return new BulkSmsExecutionResult
            {
                Success = successCount > 0,
                SentCount = successCount,
                FailedCount = failCount,
                Message = $"{successCount} kişiye kişiselleştirilmiş SMS başarıyla iletildi." + (failCount > 0 ? $" ({failCount} başarısız)" : "")
            };
        }
    }

    public async Task TriggerLiveLessonStartedSmsAsync(Guid courseId, string sessionTitle, CancellationToken ct = default)
    {
        var triggers = await GetTriggerSettingsAsync(ct);
        if (!triggers.LiveLessonStartedEnabled) return;

        var course = await _context.Courses.AsNoTracking().FirstOrDefaultAsync(c => c.Id == courseId, ct);
        if (course == null) return;

        var tenantName = await GetTenantNameAsync();
        var loginUrl = GetTenantLoginUrl();

        var members = await _context.CourseGroups
            .Where(cg => cg.CourseId == courseId)
            .Join(
                _context.GroupMembers.Include(gm => gm.User).Where(gm => gm.Status == "active" && gm.User.IsActive),
                cg => cg.GroupId,
                gm => gm.GroupId,
                (cg, gm) => gm.User
            )
            .Distinct()
            .ToListAsync(ct);

        var validStudents = members
            .Select(u => new { User = u, CleanPhone = NormalizePhone(u.Phone) })
            .Where(x => !string.IsNullOrWhiteSpace(x.CleanPhone) && x.CleanPhone.Length == 10 && x.CleanPhone.StartsWith("5"))
            .ToList();

        if (!validStudents.Any()) return;

        _logger.LogInformation("Canlı ders başlama SMS tetikleyicisi devrede: {Course} ({Count} Öğrenci)", course.Title, validStudents.Count);

        foreach (var item in validStudents)
        {
            var msg = RenderMessage(triggers.LiveLessonStartedTemplate, item.User, $"{course.Title} - {sessionTitle}", tenantName, loginUrl);
            await _smsService.SendSmsAsync(new SendSingleSmsRequest
            {
                Phone = item.CleanPhone,
                Message = msg
            }, ct);
        }
    }

    public async Task TriggerRecordingReadySmsAsync(Guid courseId, string sessionTitle, CancellationToken ct = default)
    {
        var triggers = await GetTriggerSettingsAsync(ct);
        if (!triggers.RecordingReadyEnabled) return;

        var course = await _context.Courses.AsNoTracking().FirstOrDefaultAsync(c => c.Id == courseId, ct);
        if (course == null) return;

        var tenantName = await GetTenantNameAsync();
        var loginUrl = GetTenantLoginUrl();

        var members = await _context.CourseGroups
            .Where(cg => cg.CourseId == courseId)
            .Join(
                _context.GroupMembers.Include(gm => gm.User).Where(gm => gm.Status == "active" && gm.User.IsActive),
                cg => cg.GroupId,
                gm => gm.GroupId,
                (cg, gm) => gm.User
            )
            .Distinct()
            .ToListAsync(ct);

        var validStudents = members
            .Select(u => new { User = u, CleanPhone = NormalizePhone(u.Phone) })
            .Where(x => !string.IsNullOrWhiteSpace(x.CleanPhone) && x.CleanPhone.Length == 10 && x.CleanPhone.StartsWith("5"))
            .ToList();

        if (!validStudents.Any()) return;

        _logger.LogInformation("Ders kaydı hazır SMS tetikleyicisi devrede: {Course} ({Count} Öğrenci)", course.Title, validStudents.Count);

        foreach (var item in validStudents)
        {
            var msg = RenderMessage(triggers.RecordingReadyTemplate, item.User, $"{course.Title} - {sessionTitle}", tenantName, loginUrl);
            await _smsService.SendSmsAsync(new SendSingleSmsRequest
            {
                Phone = item.CleanPhone,
                Message = msg
            }, ct);
        }
    }

    public async Task TriggerWelcomeStudentSmsAsync(Guid userId, string? rawPassword = null, CancellationToken ct = default)
    {
        var triggers = await GetTriggerSettingsAsync(ct);
        if (!triggers.WelcomeStudentEnabled) return;

        var user = await _context.Users.AsNoTracking().FirstOrDefaultAsync(u => u.Id == userId, ct);
        if (user == null) return;

        var cleanPhone = NormalizePhone(user.Phone);
        if (string.IsNullOrWhiteSpace(cleanPhone) || cleanPhone.Length != 10 || !cleanPhone.StartsWith("5")) return;

        var tenantName = await GetTenantNameAsync();
        var loginUrl = GetTenantLoginUrl();

        var msg = RenderMessage(triggers.WelcomeStudentTemplate, user, "MURO Akademi", tenantName, loginUrl, rawPassword);

        _logger.LogInformation("Yeni öğrenci hoş geldin SMS'i gönderiliyor: {Phone}", cleanPhone);
        await _smsService.SendSmsAsync(new SendSingleSmsRequest
        {
            Phone = cleanPhone,
            Message = msg
        }, ct);
    }
}
