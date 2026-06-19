using MURO.Application.DTOs;
using MURO.Application.DTOs.Assignments;

namespace MURO.Application.Interfaces;

public interface IAssignmentService
{
    Task<PagedResult<AssignmentListDto>> GetAssignmentsAsync(int page, int pageSize, Guid? courseId);
    Task<AssignmentDetailDto> GetAssignmentByIdAsync(Guid assignmentId);
    Task<AssignmentListDto> CreateAssignmentAsync(CreateAssignmentRequest request);
    Task<AssignmentListDto> UpdateAssignmentAsync(Guid assignmentId, UpdateAssignmentRequest request);
    Task DeleteAssignmentAsync(Guid assignmentId);

    // Submissions
    Task<SubmissionDto> SubmitAsync(Guid assignmentId, Guid userId, SubmitAssignmentRequest request);
    Task<SubmissionDto> GradeSubmissionAsync(Guid assignmentId, Guid submissionId, GradeSubmissionRequest request);

    // Öğrenci
    Task<List<MyAssignmentDto>> GetMyAssignmentsAsync(Guid userId);
}
