using System;

namespace MURO.Domain.Entities;

public class SystemSetting
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string TenantName { get; set; } = "MURO";
    public string? LogoUrl { get; set; }
    public string? FaviconUrl { get; set; }
    public string PrimaryColor { get; set; } = "#1B3B6F";
    public string? AccentColor { get; set; }
    public string? FooterText { get; set; }
    public string UsernameRule { get; set; } = "default";
    public string PasswordRule { get; set; } = "{first_name}.{phone_last2}.{last_name_first_char}";
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
