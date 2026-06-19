using MURO.Application.DTOs;
using MURO.Application.DTOs.Courses;

namespace MURO.Application.Interfaces;

public interface ICourseSessionService
{
    Task<SessionDto> CreateSessionAsync(Guid courseId, CreateSessionRequest request);
    Task<SessionDto> UpdateSessionAsync(Guid courseId, Guid sessionId, UpdateSessionRequest request);
    Task DeleteSessionAsync(Guid courseId, Guid sessionId);
    Task ReorderSessionsAsync(Guid courseId, List<Guid> sessionIds);
    Task<List<UpcomingSessionDto>> GetUpcomingSessionsAsync();
    Task<List<UpcomingSessionDto>> GetUpcomingSessionsByUserAsync(Guid userId);
    Task<SessionDto> CreateVodSessionAsync(Guid courseId, string title, string filePath, int? durationSeconds = null);

}
