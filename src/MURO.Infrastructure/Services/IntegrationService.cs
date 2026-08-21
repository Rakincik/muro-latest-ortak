using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using MURO.Application.DTOs.Integrations;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class IntegrationService : IIntegrationService
{
    private readonly MuroDbContext _context;
    private readonly ISmsService _smsService;
    private readonly TopluSmsService _topluSmsService;
    private readonly ILogger<IntegrationService> _logger;

    public IntegrationService(
        MuroDbContext context,
        ISmsService smsService,
        TopluSmsService topluSmsService,
        ILogger<IntegrationService> logger)
    {
        _context = context;
        _smsService = smsService;
        _topluSmsService = topluSmsService;
        _logger = logger;
    }

    private static readonly List<IntegrationItemDto> CatalogTemplates = new()
    {
        new IntegrationItemDto
        {
            ProviderKey = "muro_connect",
            Category = "Geliştirici & API",
            Title = "MURO Connect (Web Sitesi & Webhook API)",
            Description = "Harici web siteleri, Shopier, WordPress ve ödeme sistemlerinden tek tıkla otomatik öğrenci kaydı ve paket tanımlama API'si.",
            IsEnabled = true
        },
        new IntegrationItemDto
        {
            ProviderKey = "toplusms",
            Category = "SMS",
            Title = "Toplu SMS (api.toplusms.app)",
            Description = "VatanSMS yeni nesil REST API altyapısı (api.toplusms.app) ile OTP ve toplu SMS gönderim servisi.",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "vatansms",
            Category = "SMS",
            Title = "Vatan SMS (Eski API)",
            Description = "Türkiye geneli güvenli OTP, bilgilendirme ve toplu SMS gönderim servisi (api.vatansms.net).",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "netgsm",
            Category = "SMS",
            Title = "NetGSM",
            Description = "NetGSM SMS, OTP ve sesli mesaj entegrasyonu.",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "iyzico",
            Category = "Ödeme",
            Title = "İyzico",
            Description = "Kredi kartı ve taksitli online ödeme geçidi.",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "paytr",
            Category = "Ödeme",
            Title = "PayTR",
            Description = "PayTR Sanal POS ve cüzdan ödeme entegrasyonu.",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "bunnycdn",
            Category = "CDN & Video",
            Title = "BunnyCDN",
            Description = "Ultra hızlı global video streaming ve depolama ağı.",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "whatsapp",
            Category = "İletişim",
            Title = "WhatsApp Cloud API",
            Description = "Otomatik ders hatırlatmaları ve kayıt bildirimleri için resmi Meta API.",
            IsEnabled = false
        },
        new IntegrationItemDto
        {
            ProviderKey = "ai_tutor",
            Category = "Yapay Zeka",
            Title = "AI Öğrenci Asistanı",
            Description = "Öğrencilere 7/24 ders ve soru çözümü desteği sunan yapay zeka asistanı.",
            IsEnabled = false
        }
    };


    public async Task<List<IntegrationItemDto>> GetAllIntegrationsAsync(CancellationToken ct = default)
    {
        var dbSettings = await _context.IntegrationSettings
            .AsNoTracking()
            .ToListAsync(ct);

        var result = new List<IntegrationItemDto>();

        foreach (var tpl in CatalogTemplates)
        {
            var dbItem = dbSettings.FirstOrDefault(d => d.ProviderKey == tpl.ProviderKey);
            if (dbItem != null)
            {
                result.Add(new IntegrationItemDto
                {
                    Id = dbItem.Id,
                    ProviderKey = dbItem.ProviderKey,
                    Category = dbItem.Category,
                    Title = dbItem.Title,
                    Description = dbItem.Description,
                    IsEnabled = dbItem.IsEnabled,
                    ConfigJson = dbItem.ConfigJson,
                    LastTestedAt = dbItem.LastTestedAt,
                    TestStatus = dbItem.TestStatus,
                    TestMessage = dbItem.TestMessage,
                    UpdatedAt = dbItem.UpdatedAt,
                    UpdatedBy = dbItem.UpdatedBy,
                    IsConfigured = !string.IsNullOrWhiteSpace(dbItem.ConfigJson) && dbItem.ConfigJson != "{}"
                });
            }
            else
            {
                result.Add(new IntegrationItemDto
                {
                    Id = Guid.Empty,
                    ProviderKey = tpl.ProviderKey,
                    Category = tpl.Category,
                    Title = tpl.Title,
                    Description = tpl.Description,
                    IsEnabled = false,
                    ConfigJson = null,
                    IsConfigured = false,
                    UpdatedAt = DateTime.UtcNow
                });
            }
        }

        return result;
    }

    public async Task<IntegrationItemDto?> GetIntegrationAsync(string providerKey, CancellationToken ct = default)
    {
        var dbItem = await _context.IntegrationSettings
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.ProviderKey == providerKey, ct);

        if (dbItem == null)
        {
            var tpl = CatalogTemplates.FirstOrDefault(t => t.ProviderKey == providerKey);
            if (tpl == null) return null;
            return tpl;
        }

        return new IntegrationItemDto
        {
            Id = dbItem.Id,
            ProviderKey = dbItem.ProviderKey,
            Category = dbItem.Category,
            Title = dbItem.Title,
            Description = dbItem.Description,
            IsEnabled = dbItem.IsEnabled,
            ConfigJson = dbItem.ConfigJson,
            LastTestedAt = dbItem.LastTestedAt,
            TestStatus = dbItem.TestStatus,
            TestMessage = dbItem.TestMessage,
            UpdatedAt = dbItem.UpdatedAt,
            UpdatedBy = dbItem.UpdatedBy,
            IsConfigured = !string.IsNullOrWhiteSpace(dbItem.ConfigJson) && dbItem.ConfigJson != "{}"
        };
    }

    public async Task<IntegrationItemDto> UpdateIntegrationAsync(string providerKey, UpdateIntegrationRequest request, string? updatedBy, CancellationToken ct = default)
    {
        var setting = await _context.IntegrationSettings.FirstOrDefaultAsync(i => i.ProviderKey == providerKey, ct);
        var tpl = CatalogTemplates.FirstOrDefault(t => t.ProviderKey == providerKey);

        if (setting == null)
        {
            setting = new IntegrationSetting
            {
                Id = Guid.NewGuid(),
                ProviderKey = providerKey,
                Category = tpl?.Category ?? "General",
                Title = tpl?.Title ?? providerKey,
                Description = tpl?.Description,
                IsEnabled = request.IsEnabled,
                ConfigJson = request.ConfigJson,
                UpdatedAt = DateTime.UtcNow,
                UpdatedBy = updatedBy
            };
            _context.IntegrationSettings.Add(setting);
        }
        else
        {
            setting.IsEnabled = request.IsEnabled;
            if (request.ConfigJson != null)
            {
                setting.ConfigJson = request.ConfigJson;
            }
            setting.UpdatedAt = DateTime.UtcNow;
            setting.UpdatedBy = updatedBy;
            _context.IntegrationSettings.Update(setting);
        }

        await _context.SaveChangesAsync(ct);

        return new IntegrationItemDto
        {
            Id = setting.Id,
            ProviderKey = setting.ProviderKey,
            Category = setting.Category,
            Title = setting.Title,
            Description = setting.Description,
            IsEnabled = setting.IsEnabled,
            ConfigJson = setting.ConfigJson,
            LastTestedAt = setting.LastTestedAt,
            TestStatus = setting.TestStatus,
            TestMessage = setting.TestMessage,
            UpdatedAt = setting.UpdatedAt,
            UpdatedBy = setting.UpdatedBy,
            IsConfigured = !string.IsNullOrWhiteSpace(setting.ConfigJson)
        };
    }

    public async Task<SmsAccountInfoResult> TestVatanSmsAsync(TestIntegrationRequest request, CancellationToken ct = default)
    {
        VatanSmsConfigDto? cfg = null;
        if (!string.IsNullOrWhiteSpace(request.ConfigJson))
        {
            try
            {
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                cfg = JsonSerializer.Deserialize<VatanSmsConfigDto>(request.ConfigJson, options);
            }
            catch { }
        }

        var result = await _smsService.GetAccountInfoAsync(cfg, ct);

        // Canlı test SMS'i istenmişse gönder
        if (result.Success && !string.IsNullOrWhiteSpace(request.TestPhone))
        {
            var smsRes = await _smsService.SendSmsAsync(new SendSingleSmsRequest
            {
                Phone = request.TestPhone,
                Message = $"[MURO] Vatan SMS entegrasyon test mesajıdır. Tarih: {DateTime.Now:dd.MM.yyyy HH:mm}",
                Sender = cfg?.Sender
            }, ct);

            if (!smsRes.Success)
            {
                result.Success = false;
                result.Message = $"Hesap doğrulandı fakat test SMS gönderilemedi: {smsRes.Message}";
            }
            else
            {
                result.Message = $"Bağlantı başarılı ve test SMS {request.TestPhone} numarasına iletildi.";
            }
        }

        // Veritabanındaki test logunu güncelle
        var setting = await _context.IntegrationSettings.FirstOrDefaultAsync(i => i.ProviderKey == "vatansms", ct);
        if (setting != null)
        {
            setting.LastTestedAt = DateTime.UtcNow;
            setting.TestStatus = result.Success ? "Success" : "Failed";
            setting.TestMessage = result.Message;
            _context.IntegrationSettings.Update(setting);
            await _context.SaveChangesAsync(ct);
        }

        return result;
    }

    public async Task<SmsAccountInfoResult> TestTopluSmsAsync(TestIntegrationRequest request, CancellationToken ct = default)
    {
        TopluSmsConfigDto? cfg = null;
        if (!string.IsNullOrWhiteSpace(request.ConfigJson))
        {
            try
            {
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                cfg = JsonSerializer.Deserialize<TopluSmsConfigDto>(request.ConfigJson, options);
            }
            catch { }
        }

        var result = await _topluSmsService.GetAccountInfoAsync(cfg, ct);

        // Canlı test SMS'i istenmişse gönder
        if (result.Success && !string.IsNullOrWhiteSpace(request.TestPhone))
        {
            var smsRes = await _topluSmsService.SendSmsAsync(new SendSingleSmsRequest
            {
                Phone = request.TestPhone,
                Message = $"[MURO] TopluSMS entegrasyon test mesajıdır. Tarih: {DateTime.Now:dd.MM.yyyy HH:mm}",
                Sender = cfg?.Sender
            }, cfg, ct);

            if (!smsRes.Success)
            {
                result.Success = false;
                result.Message = $"Hesap doğrulandı fakat test SMS gönderilemedi: {smsRes.Message}";
            }
            else
            {
                result.Message = $"Bağlantı başarılı ve test SMS {request.TestPhone} numarasına iletildi.";
            }
        }

        // Veritabanındaki test logunu güncelle
        var setting = await _context.IntegrationSettings.FirstOrDefaultAsync(i => i.ProviderKey == "toplusms", ct);
        if (setting != null)
        {
            setting.LastTestedAt = DateTime.UtcNow;
            setting.TestStatus = result.Success ? "Success" : "Failed";
            setting.TestMessage = result.Message;
            _context.IntegrationSettings.Update(setting);
            await _context.SaveChangesAsync(ct);
        }

        return result;
    }
}
