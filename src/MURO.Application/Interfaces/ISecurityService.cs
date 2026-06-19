using MURO.Application.DTOs.Security;

namespace MURO.Application.Interfaces;

public interface ISecurityService
{
    Task<SecurityEventPageDto> GetEventsAsync(DateTime? from, DateTime? to, Guid? userId, string? eventType, int page, int pageSize);
    Task<List<SecuritySummaryDto>> GetSummaryAsync();
    Task<List<SecurityEventDto>> GetSuspiciousActivityAsync();
}
