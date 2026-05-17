using MURO.Application.DTOs;
using MURO.Application.DTOs.Media;

namespace MURO.Application.Interfaces;

public interface ICourseMediaService
{
    Task<List<CourseMediaDto>> GetCourseMediasAsync(Guid tenantId, Guid courseId);
    Task<CourseMediaDto> AssignMediaAsync(Guid tenantId, Guid courseId, AssignMediaToCourseRequest request);
    Task<CourseMediaDto> AssignExamAsync(Guid tenantId, Guid courseId, AssignExamToCourseRequest request);
    Task BulkAssignFolderAsync(Guid tenantId, Guid courseId, BulkAssignFolderToCourseRequest request);
    Task RemoveMediaAsync(Guid tenantId, Guid courseId, Guid mediaAssetId); // Keep for backwards compat
    Task RemoveItemAsync(Guid tenantId, Guid courseId, Guid courseMediaId);
    Task ReorderMediasAsync(Guid tenantId, Guid courseId, ReorderCourseMediaRequest request);
}
