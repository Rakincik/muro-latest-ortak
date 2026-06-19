using MURO.Application.DTOs;
using MURO.Application.DTOs.Notifications;

namespace MURO.Application.Interfaces;

public interface INotificationService
{
    Task<PagedResult<NotificationDto>> GetUserNotificationsAsync(Guid userId, int page, int pageSize, bool? unreadOnly);
    Task<NotificationDto> CreateAsync(CreateNotificationRequest request);
    Task<int> BulkSendAsync(BulkNotificationRequest request);
    Task MarkAsReadAsync(Guid notificationId);
    Task MarkAllReadAsync(Guid userId);
    Task<int> GetUnreadCountAsync(Guid userId);
    Task<List<NotificationAdminDto>> GetTenantSentAsync();
}
