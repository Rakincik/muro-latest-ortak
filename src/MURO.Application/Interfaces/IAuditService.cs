using MURO.Application.DTOs;

namespace MURO.Application.Interfaces;

public interface IAuditService
{
    Task LogAsync(Guid? tenantId, Guid? userId, string? userName, string action,
                  string entityType, string? entityId, string? entityName,
                  string? details = null, string? ipAddress = null);

    Task<PagedResult<AuditLogDto>> GetLogsAsync(Guid tenantId, int page, int pageSize,
                                                 string? action = null, string? entityType = null,
                                                 string? search = null, DateTime? from = null, DateTime? to = null);

    Task<AuditSummaryDto> GetSummaryAsync(Guid tenantId, DateTime from, DateTime to);
    
    Task<PagedResult<UserAuditSummaryDto>> GetUserAuditSummariesAsync(Guid tenantId, int page, int pageSize, string? search = null);
    
    Task<List<SuspiciousUserDto>> GetSuspiciousUsersAsync(Guid tenantId);
}

public record AuditLogDto(
    Guid Id, Guid? UserId, string? UserName,
    string Action, string EntityType, string? EntityId, string? EntityName,
    string? Details, string? IpAddress, DateTime CreatedAt
);

public record AuditSummaryDto(
    int TotalCount,
    int CreateCount,
    int UpdateCount,
    int DeleteCount,
    int NightActivityCount,
    Dictionary<string, int> TopEntities
);

public record UserAuditSummaryDto(
    Guid? UserId,
    string? UserName,
    int ActionCount,
    DateTime LastActionAt
);

public record SuspiciousUserDto(
    Guid? UserId,
    string? UserName,
    string AlertType,
    int EventCount,
    DateTime LastEventAt
);
