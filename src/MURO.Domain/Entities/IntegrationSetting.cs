using System;

namespace MURO.Domain.Entities;

public class IntegrationSetting
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string ProviderKey { get; set; } = string.Empty; // e.g. "vatansms", "netgsm", "iyzico", "bunnycdn"
    public string Category { get; set; } = string.Empty; // e.g. "SMS", "Payment", "CDN", "Live", "AI"
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public bool IsEnabled { get; set; } = false;
    public string? ConfigJson { get; set; } // JSON serialized provider settings
    public string? TriggerSettingsJson { get; set; } // JSON serialized automated SMS triggers
    public DateTime? LastTestedAt { get; set; }
    public string? TestStatus { get; set; } // "Success", "Failed", "Pending"
    public string? TestMessage { get; set; }
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
    public string? UpdatedBy { get; set; }
}
