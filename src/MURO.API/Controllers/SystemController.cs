using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.Interfaces;
using MURO.Infrastructure.Persistence;
using MURO.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace MURO.API.Controllers;

/// <summary>
/// Sistem sağlık, metrik ve VEP entegrasyon endpoint'leri.
/// </summary>
[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/system")]
public class SystemController : ControllerBase
{
    private readonly ISystemHealthService _health;
    private readonly IVepWebhookService _webhook;
    private readonly MuroDbContext _db;
    private readonly ISecurityService _security;

    public SystemController(ISystemHealthService health, IVepWebhookService webhook, MuroDbContext db, ISecurityService security)
    {
        _health = health;
        _webhook = webhook;
        _db = db;
        _security = security;
    }

    // ═══════════════════════════════════════════════════════════════════
    // 1. DETAYLI SAĞLIK KONTROLÜ
    // ═══════════════════════════════════════════════════════════════════

    [HttpGet("health")]
    [AllowAnonymous]
    public async Task<IActionResult> GetDetailedHealth()
    {
        var report = await _health.GetHealthReportAsync();
        var statusCode = report.OverallStatus switch
        {
            "healthy" => 200,
            "degraded" => 200,
            _ => 503
        };
        return StatusCode(statusCode, report);
    }

    [HttpGet("/api/v1/tenant/branding")]
    [AllowAnonymous]
    public async Task<IActionResult> GetTenantBranding()
    {
        var settings = await _db.SystemSettings.FirstOrDefaultAsync();
        if (settings == null)
        {
            return Ok(new
            {
                ThemeColor = "#1B3B6F",
                LogoUrl = "/monopol_logo.png",
                FaviconUrl = "/favicon.png",
                CustomCss = "",
                Title = "Monopoluzem",
                Name = "Monopoluzem"
            });
        }
        return Ok(new
        {
            ThemeColor = settings.PrimaryColor,
            LogoUrl = settings.LogoUrl ?? "/monopol_logo.png",
            FaviconUrl = settings.FaviconUrl ?? "/favicon.png",
            CustomCss = "",
            Title = settings.TenantName,
            Name = settings.TenantName,
            PrimaryColor = settings.PrimaryColor,
            AccentColor = settings.AccentColor,
            FooterText = settings.FooterText
        });
    }

    public record UpdateBrandingRequest(
        string Name,
        string? LogoUrl,
        string? FaviconUrl,
        string PrimaryColor,
        string? AccentColor,
        string? FooterText
    );

    [HttpGet("/api/v1/admin/tenant/branding")]
    [Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> GetAdminBranding()
    {
        var settings = await _db.SystemSettings.FirstOrDefaultAsync();
        if (settings == null)
        {
            settings = new SystemSetting
            {
                TenantName = "Monopoluzem",
                PrimaryColor = "#1B3B6F"
            };
        }
        return Ok(settings);
    }

    [HttpPost("/api/v1/admin/tenant/branding")]
    [Authorize(Roles = "SuperAdmin")]
    public async Task<IActionResult> UpdateAdminBranding([FromBody] UpdateBrandingRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
            return BadRequest(new { error = "Kurum adı boş olamaz." });
        if (string.IsNullOrWhiteSpace(request.PrimaryColor))
            return BadRequest(new { error = "Tema rengi boş olamaz." });

        var settings = await _db.SystemSettings.FirstOrDefaultAsync();
        if (settings == null)
        {
            settings = new SystemSetting();
            _db.SystemSettings.Add(settings);
        }

        settings.TenantName = request.Name;
        settings.LogoUrl = request.LogoUrl;
        settings.FaviconUrl = request.FaviconUrl;
        settings.PrimaryColor = request.PrimaryColor;
        settings.AccentColor = request.AccentColor;
        settings.FooterText = request.FooterText;
        settings.UpdatedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync();
        return Ok(settings);
    }

    // ═══════════════════════════════════════════════════════════════════
    // 2. VEP WEBHOOK DURUMU
    // ═══════════════════════════════════════════════════════════════════

    [HttpGet("vep/status")]
    [Authorize(Roles = "Admin,SuperAdmin")]
    public async Task<IActionResult> GetVepStatus()
    {
        var configured = await _webhook.IsConfiguredAsync();
        return Ok(new
        {
            configured,
            message = configured ? "VEP webhook aktif." : "VEP webhook yapılandırılmamış."
        });
    }

    [HttpPost("vep/test")]
    [Authorize(Roles = "Admin,SuperAdmin")]
    public async Task<IActionResult> TestVepWebhook()
    {
        var configured = await _webhook.IsConfiguredAsync();
        if (!configured)
            return BadRequest(new { error = "VEP webhook URL yapılandırılmamış." });

        await _webhook.NotifyAsync(new VepWebhookEvent
        {
            EventType = "system.test",
            TenantCode = "system",
            Data = new Dictionary<string, object>
            {
                ["message"] = "Test başarılı!",
                ["sentAt"] = DateTime.UtcNow.ToString("o"),
            }
        });
        return Ok(new { success = true, message = "Test webhook gönderildi." });
    }
}
