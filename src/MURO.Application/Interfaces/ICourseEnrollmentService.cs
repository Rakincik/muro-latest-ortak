using MURO.Application.DTOs.Courses;

namespace MURO.Application.Interfaces;

public interface ICourseEnrollmentService
{
    Task AssignToGroupAsync(Guid courseId, Guid groupId, string mode);
    Task RemoveFromGroupAsync(Guid courseId, Guid groupId);
    
    Task AssignToStudentAsync(Guid courseId, Guid userId);
    Task RemoveFromStudentAsync(Guid courseId, Guid userId);
    Task UpdateStudentExpirationAsync(Guid courseId, Guid userId, DateTime? expiresAt);
    Task<List<CourseStudentListDto>> GetEnrolledStudentsAsync(Guid courseId);
    Task<List<CourseListDto>> GetDirectCoursesByUserAsync(Guid userId);
}
