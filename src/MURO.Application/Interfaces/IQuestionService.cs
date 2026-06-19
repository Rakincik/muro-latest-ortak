using MURO.Application.DTOs;
using MURO.Application.DTOs.Questions;

namespace MURO.Application.Interfaces;

public interface IQuestionService
{
    Task<PagedResult<QuestionDto>> GetQuestionsAsync(int page, int pageSize, string? status, Guid? instructorId);
    Task<QuestionDto> GetByIdAsync(Guid questionId);
    Task<QuestionDto> AskAsync(Guid userId, CreateQuestionRequest request);
    Task<QuestionDto> AnswerAsync(Guid questionId, AnswerQuestionRequest request);
    Task<QuestionDto> DeleteAnswerAsync(Guid questionId);
    Task<QuestionDto> UpdateNoteAsync(Guid questionId, Guid userId, UpdateNoteRequest request);
    Task DeleteAsync(Guid questionId, Guid? userId = null);
}
