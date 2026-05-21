using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs.Notifications;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

/// <summary>
/// Worker uygulaması tarafından SignalR mesajlarını tetiklemek için kullanılan dahili (Internal) API.
/// Gerçek dünyada bu endpoint IP bazlı veya bir Secret Key ile korunmalıdır.
/// </summary>
[ApiController]
[Route("api/internal/signalr")]
public class InternalSignalRController : ControllerBase
{
    private readonly INotificationPush _push;
    private readonly IConfiguration _config;
    private readonly ILogger<InternalSignalRController> _logger;

    public InternalSignalRController(INotificationPush push, IConfiguration config, ILogger<InternalSignalRController> logger)
    {
        _push = push;
        _config = config;
        _logger = logger;
    }

    [HttpPost("push")]
    public async Task<IActionResult> PushToUsers([FromBody] PushRequest payload, [FromQuery] string secret)
    {
        var expectedSecret = _config["WorkerSharedSecret"] ?? "dev-secret-key-muro";
        if (secret != expectedSecret)
        {
            _logger.LogWarning("Geçersiz WorkerSharedSecret denemesi. IP: {Ip}", HttpContext.Connection.RemoteIpAddress);
            return Unauthorized();
        }

        if (payload.UserIds == null || payload.UserIds.Count == 0)
            return BadRequest();

        await _push.PushToUsersAsync(payload.UserIds, payload.Notification);
        return Ok(new { success = true });
    }
}

public class PushRequest
{
    public List<string> UserIds { get; set; } = new();
    public NotificationDto Notification { get; set; } = null!;
}
