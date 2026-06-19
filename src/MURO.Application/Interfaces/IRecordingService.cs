using MURO.Application.DTOs.Videos;

namespace MURO.Application.Interfaces;

public interface IRecordingService
{
    Task<List<SessionRecordingDto>> GetRecordingsAsync(Guid userId, string? role);
    Task DeleteRecordingAsync(Guid id);
}
