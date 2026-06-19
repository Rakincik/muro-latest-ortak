using MURO.Application.DTOs;
using MURO.Application.DTOs.Podcasts;

namespace MURO.Application.Interfaces;

public interface IPodcastService
{
    Task<PagedResult<PodcastDto>> GetPodcastsAsync(int page, int pageSize, Guid? courseId);
    Task<PodcastDto> GetByIdAsync(Guid podcastId);
    Task<PodcastDto> CreateAsync(CreatePodcastRequest request);
    Task<PodcastDto> UpdateStatusAsync(Guid podcastId, string status);
    Task DeleteAsync(Guid podcastId);

    /// <summary>
    /// Ham metinden AI podcast üretir: Gemini → TTS → MP3 kayıt.
    /// </summary>
    Task<PodcastDto> GenerateAsync(GeneratePodcastRequest request);

    /// <summary>
    /// Anonim ses streaming için tenant sız podcast getirir.
    /// </summary>
    Task<PodcastDto?> GetByIdForStreamAsync(Guid podcastId);
}
