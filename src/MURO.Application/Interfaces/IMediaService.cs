using MURO.Application.DTOs;
using MURO.Application.DTOs.Media;

namespace MURO.Application.Interfaces;

public interface IMediaService
{
    // Media Assets
    Task<PagedResult<MediaAssetDto>> GetAssetsAsync(
        int page, int pageSize, Guid? courseId, string? search = null, Guid? userId = null, Guid? folderId = null, bool excludeRecordings = false);
    Task<MediaAssetDto> GetAssetByIdAsync(Guid assetId, Guid? userId = null);
    Task<MediaAssetDto> CreateAssetAsync(CreateMediaAssetRequest request);
    Task<MediaAssetDto> UpdateAssetAsync(Guid assetId, UpdateMediaAssetRequest request);
    Task DeleteAssetAsync(Guid assetId);
    Task<List<Guid>> GetAssignedCourseIdsAsync(Guid mediaAssetId);
    
    // Video Progress
    Task<VideoProgressDto> GetProgressAsync(Guid userId, Guid mediaAssetId);
    Task<VideoProgressDto> UpdateProgressAsync(Guid userId, Guid mediaAssetId, UpdateVideoProgressRequest request);
    
    // Podcasts
    Task<PagedResult<PodcastDto>> GetPodcastsAsync(int page, int pageSize);
    Task<PodcastDto> CreatePodcastAsync(CreatePodcastRequest request);
}
