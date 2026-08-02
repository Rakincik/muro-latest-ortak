using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace MURO.API.Hubs;

/// <summary>
/// Her kullanıcı bağlandığında kendi userId'si ile isimlendirilmiş gruba katılır.
/// NotificationService, bildirim oluşturulunca bu hub üzerinden push atar.
/// </summary>
[Authorize]
public class NotificationHub : Hub
{
    public override async Task OnConnectedAsync()
    {
        // UserIdentifier = JWT'deki NameIdentifier claim'i (bkz. JwtUserIdProvider)
        var userId = Context.UserIdentifier;
        if (!string.IsNullOrEmpty(userId))
            await Groups.AddToGroupAsync(Context.ConnectionId, userId);

        // Session validation / kick group
        var sessionId = Context.User?.FindFirst("sessionId")?.Value;
        if (!string.IsNullOrEmpty(sessionId))
            await Groups.AddToGroupAsync(Context.ConnectionId, $"session:{sessionId}");

        await base.OnConnectedAsync();
    }

    public override async Task OnDisconnectedAsync(Exception? exception)
    {
        var userId = Context.UserIdentifier;
        if (!string.IsNullOrEmpty(userId))
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, userId);

        var sessionId = Context.User?.FindFirst("sessionId")?.Value;
        if (!string.IsNullOrEmpty(sessionId))
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"session:{sessionId}");

        await base.OnDisconnectedAsync(exception);
    }
}
