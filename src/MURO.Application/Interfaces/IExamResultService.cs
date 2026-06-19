using MURO.Application.DTOs;
using MURO.Application.DTOs.Exams;

namespace MURO.Application.Interfaces;

public interface IExamResultService
{
    // Sonuçlar
    Task<ExamResultSummaryDto> GetExamResultsAsync(Guid examId);
    Task<ExamOverallSummaryDto> GetOverallSummaryAsync();
    Task<ExamResultDto> SubmitAnswersAsync(Guid examId, Guid userId, SubmitExamAnswersRequest request);

    // Öğrenci
    Task SaveDraftAsync(Guid examId, Guid userId, Dictionary<int, string> answers);
    Task<Dictionary<int, string>?> GetDraftAsync(Guid examId, Guid userId);
    Task<List<MyExamResultDto>> GetMyExamResultsAsync(Guid userId);
}
