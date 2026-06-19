using MURO.Application.DTOs;
using MURO.Application.DTOs.Courses;

namespace MURO.Application.Interfaces;

public interface ICourseService
{
    // Courses
    Task<PagedResult<CourseListDto>> GetCoursesAsync(int page, int pageSize, string? search, string? courseType, bool? isPublished, Guid? instructorId = null);
    /// <summary>Student spesifik: sadece kullanıcının grubundaki dersler</summary>
    Task<PagedResult<CourseListDto>> GetCoursesByUserAsync(Guid userId, int page, int pageSize, string? search, string? courseType);
    Task<CourseDetailDto> GetCourseByIdAsync(Guid courseId, Guid? userId = null);
    Task<CourseListDto> CreateCourseAsync(CreateCourseRequest request);
    Task<CourseListDto> UpdateCourseAsync(Guid courseId, UpdateCourseRequest request);
    Task DeleteCourseAsync(Guid courseId);
}
