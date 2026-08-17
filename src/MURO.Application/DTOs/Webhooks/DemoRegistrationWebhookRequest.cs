namespace MURO.Application.DTOs.Webhooks;

public class DemoRegistrationWebhookRequest
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public string? Phone { get; set; }
    public List<string> GroupIds { get; set; } = new List<string>();
}
