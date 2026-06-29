using MURO.Application.DTOs;
using MURO.Application.DTOs.Media;

namespace MURO.Application.Interfaces;

public interface ICourseMediaService
{
    Task<List<CourseMediaDto>> GetCourseMediasAsync(Guid courseId);
    Task<CourseMediaDto> AssignMediaAsync(Guid courseId, AssignMediaToCourseRequest request);
    Task<CourseMediaDto> AssignExamAsync(Guid courseId, AssignExamToCourseRequest request);
    Task BulkAssignFolderAsync(Guid courseId, BulkAssignFolderToCourseRequest request);
    Task RemoveMediaAsync(Guid courseId, Guid mediaAssetId); // Keep for backwards compat
    Task RemoveItemAsync(Guid courseId, Guid courseMediaId);
    Task ReorderMediasAsync(Guid courseId, ReorderCourseMediaRequest request);
    Task UpdateCustomTitleAsync(Guid courseId, Guid courseMediaId, string customTitle);
}
