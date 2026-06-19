using MURO.Application.DTOs.Exams;

namespace MURO.Application.Interfaces;

public interface IExamAssignmentService
{
    // Atamalar
    Task<ExamAssignmentDto> AssignExamAsync(Guid examId, CreateExamAssignmentRequest request);
    Task RemoveAssignmentAsync(Guid examId, Guid assignmentId);
}
