using MURO.Application.DTOs.Courses;

namespace MURO.Application.Interfaces;

public interface ICourseEnrollmentService
{
    Task AssignToGroupAsync(Guid tenantId, Guid courseId, Guid groupId, string mode);
    Task RemoveFromGroupAsync(Guid tenantId, Guid courseId, Guid groupId);
    
    Task AssignToStudentAsync(Guid tenantId, Guid courseId, Guid userId);
    Task RemoveFromStudentAsync(Guid tenantId, Guid courseId, Guid userId);
    Task UpdateStudentExpirationAsync(Guid tenantId, Guid courseId, Guid userId, DateTime? expiresAt);
    Task<List<CourseStudentListDto>> GetEnrolledStudentsAsync(Guid tenantId, Guid courseId);
    Task<List<CourseListDto>> GetDirectCoursesByUserAsync(Guid tenantId, Guid userId);
}
