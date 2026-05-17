using MURO.Application.DTOs;
using MURO.Application.DTOs.Exams;

namespace MURO.Application.Interfaces;

public interface IExamResultService
{
    // Sonuçlar
    Task<ExamResultSummaryDto> GetExamResultsAsync(Guid tenantId, Guid examId);
    Task<ExamOverallSummaryDto> GetOverallSummaryAsync(Guid tenantId);
    Task<ExamResultDto> SubmitAnswersAsync(Guid tenantId, Guid examId, Guid userId, SubmitExamAnswersRequest request);

    // Öğrenci
    Task SaveDraftAsync(Guid tenantId, Guid examId, Guid userId, Dictionary<int, string> answers);
    Task<Dictionary<int, string>?> GetDraftAsync(Guid tenantId, Guid examId, Guid userId);
    Task<List<MyExamResultDto>> GetMyExamResultsAsync(Guid tenantId, Guid userId);
}
