using MURO.Application.DTOs;
using MURO.Application.DTOs.Media;

namespace MURO.Application.Interfaces;

public interface IMediaFolderService
{
    Task<List<MediaFolderDto>> GetFoldersAsync(Guid? parentFolderId = null, string? search = null, bool all = false);
    Task<MediaFolderDto> GetFolderByIdAsync(Guid folderId);
    Task<MediaFolderDto> CreateFolderAsync(CreateMediaFolderRequest request);
    Task<MediaFolderDto> UpdateFolderAsync(Guid folderId, UpdateMediaFolderRequest request);
    Task DeleteFolderAsync(Guid folderId, bool force = false);
    Task<List<Guid>> GetAssignedCourseIdsAsync(Guid folderId);
}
