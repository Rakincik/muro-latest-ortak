namespace MURO.Application.DTOs.Notifications;

/// <summary>
/// Worker tarafına Redis üzerinden iletilecek bildirim kuyruğu mesaj modeli.
/// </summary>
public class NotificationJobPayload
{
    public Guid TenantId { get; set; }
    public List<Guid> UserIds { get; set; } = new();
    public string Title { get; set; } = string.Empty;
    public string Body { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public string Channel { get; set; } = string.Empty;
}
