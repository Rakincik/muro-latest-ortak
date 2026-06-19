using MURO.Application.DTOs;
using MURO.Application.DTOs.Courses;

namespace MURO.Application.Interfaces;

public interface ICourseMaterialService
{
    Task<List<CourseMaterialDto>> GetMaterialsAsync(Guid courseId);
    Task<CourseMaterialDto> UploadMaterialAsync(Guid courseId, Stream fileStream, string fileName, string contentType, long fileSize, string? title, string webRootPath);
    Task DeleteMaterialAsync(Guid courseId, Guid materialId, string webRootPath);
}
