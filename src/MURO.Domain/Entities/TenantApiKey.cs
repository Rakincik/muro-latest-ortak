using System;

namespace MURO.Domain.Entities;

public class TenantApiKey
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid TenantId { get; set; }
    public string KeyPrefix { get; set; } = string.Empty; // e.g. "muro_live_trk_89f..." for display
    public string KeyHash { get; set; } = string.Empty;   // SHA256 of full key
    public string Name { get; set; } = "Varsayılan Web Sitesi API Anahtarı";
    public string Scopes { get; set; } = "enroll,catalog,stats";
    public bool IsEnabled { get; set; } = true;
    public DateTime? LastUsedAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public string? CreatedBy { get; set; }
}
