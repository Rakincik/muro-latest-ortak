using MURO.Application.DTOs;
using MURO.Application.DTOs.Exams;

namespace MURO.Application.Interfaces;

public interface IExamService
{
    // CRUD
    Task<PagedResult<ExamListDto>> GetExamsAsync(int page, int pageSize, string? search, string? examType, string? status);
    Task<ExamDetailDto> GetExamByIdAsync(Guid examId);
    Task<string?> GetExamDigitalQuestionsAsync(Guid examId);
    Task<ExamListDto> CreateExamAsync(CreateExamRequest request);
    Task<ExamListDto> UpdateExamAsync(Guid examId, UpdateExamRequest request);
    Task DeleteExamAsync(Guid examId);

    // Cevap Anahtarı
    Task<ExamDetailDto> UpdateAnswerKeyAsync(Guid examId, UpdateAnswerKeyRequest request);

    // Durum
    Task<ExamListDto> UpdateStatusAsync(Guid examId, UpdateExamStatusRequest request);

    // PDF
    Task<ExamDetailDto> UpdatePdfAsync(Guid examId, UpdateExamPdfRequest request);

}
