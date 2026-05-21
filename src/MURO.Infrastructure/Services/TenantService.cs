using MURO.Application.DTOs.Tenants;
using MURO.Application.Interfaces;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

/// <summary>
/// Scoped service that holds the current tenant context for the duration of a request.
/// </summary>
public class TenantService : ITenantService
{
    public Guid? CurrentTenantId { get; private set; }
    public TenantInfo? CurrentTenant { get; private set; }

    private readonly MuroDbContext _db;
    private readonly ICacheService _cache;

    public TenantService(MuroDbContext db, ICacheService cache)
    {
        _db = db;
        _cache = cache;
    }

    public void SetCurrentTenant(Guid tenantId)
    {
        CurrentTenantId = tenantId;
    }

    public void SetCurrentTenant(TenantInfo tenant)
    {
        CurrentTenant = tenant;
        CurrentTenantId = tenant.Id;
    }

    public string? GetConnectionString() => CurrentTenant?.ConnectionString;

    public bool HasFeature(string featureName)
    {
        if (CurrentTenant?.Features == null) return false;
        return CurrentTenant.Features.TryGetValue(featureName, out var enabled) && enabled;
    }

    public async Task<TenantAdminDto?> GetSettingsAsync()
    {
        if (CurrentTenantId == null) return null;
        var t = await _db.Tenants.AsNoTracking().FirstOrDefaultAsync(x => x.Id == CurrentTenantId);
        if (t == null) return null;
        return MapToAdminDto(t);
    }

    public async Task<TenantBrandingDto?> GetBrandingAsync(Guid tenantId)
    {
        var cacheKey = $"tenant:branding:{tenantId}";
        return await _cache.GetOrSetAsync(cacheKey, async () =>
        {
            var t = await _db.Tenants.AsNoTracking().FirstOrDefaultAsync(x => x.Id == tenantId);
            if (t == null) return null;
            return new TenantBrandingDto(
                t.Name, t.LogoUrl, t.FaviconUrl, 
                t.PrimaryColor, t.AccentColor, t.FooterText
            );
        }, TimeSpan.FromHours(1)); // Cache for 1 hour, invalidate on update
    }

    public async Task<TenantAdminDto?> UpdateSettingsAsync(string? name, string? logoUrl, string? faviconUrl, string? primaryColor, string? accentColor, string? footerText)
    {
        if (CurrentTenantId == null) return null;
        var t = await _db.Tenants.FirstOrDefaultAsync(x => x.Id == CurrentTenantId);
        if (t == null) return null;

        if (name != null) t.Name = name;
        if (logoUrl != null) t.LogoUrl = logoUrl;
        if (faviconUrl != null) t.FaviconUrl = faviconUrl;
        if (primaryColor != null) t.PrimaryColor = primaryColor;
        if (accentColor != null) t.AccentColor = accentColor;
        if (footerText != null) t.FooterText = footerText;

        await _db.SaveChangesAsync();
        await _cache.RemoveAsync($"tenant:branding:{CurrentTenantId}");
        
        return MapToAdminDto(t);
    }

    private static TenantAdminDto MapToAdminDto(MURO.Domain.Entities.Tenant t)
    {
        var features = new Dictionary<string, bool>();
        if (!string.IsNullOrWhiteSpace(t.Features))
        {
            try { features = JsonSerializer.Deserialize<Dictionary<string, bool>>(t.Features) ?? new(); }
            catch { /* ignore */ }
        }

        return new TenantAdminDto(
            t.Id, t.Name, t.Code, t.Subdomain,
            t.LogoUrl, t.PrimaryColor, t.AccentColor,
            t.BbbServerUrl, t.ServerGroup,
            t.IsActive, t.CreatedAt, features
        );
    }
}
