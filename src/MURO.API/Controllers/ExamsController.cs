using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Exams;
using MURO.Application.Interfaces;
using MURO.API.Filters;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/exams")]
[Authorize]
[RequireFeature("exams")]
public class ExamsController : ControllerBase
{
    private readonly IExamService _examService;
    private readonly IExamAssignmentService _assignmentService;
    private readonly IExamResultService _resultService;
        private readonly IBackgroundJobQueue _jobQueue;

    public ExamsController(
        IExamService examService, 
        IExamAssignmentService assignmentService,
        IExamResultService resultService,
        
        IBackgroundJobQueue jobQueue)
    {
        _examService = examService;
        _assignmentService = assignmentService;
        _resultService = resultService;
                _jobQueue = jobQueue;
    }

    

    private Guid GetUserId() =>
        Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

    private string? GetIp() => HttpContext.Connection.RemoteIpAddress?.ToString();

    // ── CRUD ──

    [HttpGet]
    public async Task<ActionResult<PagedResult<ExamListDto>>> GetExams(
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20,
        [FromQuery] string? search = null, [FromQuery] string? examType = null,
        [FromQuery] string? status = null)
    {
        return Ok(await _examService.GetExamsAsync(page, pageSize, search, examType, status));
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ExamDetailDto>> GetExam(Guid id)
    {
        return Ok(await _examService.GetExamByIdAsync(id));
    }

    [HttpGet("{id:guid}/digital-questions")]
    public async Task<ActionResult<string>> GetDigitalQuestions(Guid id)
    {
        var questions = await _examService.GetExamDigitalQuestionsAsync(id);
        return Ok(questions ?? "[]");
    }

    [HttpPost]
    public async Task<ActionResult<ExamListDto>> CreateExam([FromBody] CreateExamRequest request)
    {
        var exam = await _examService.CreateExamAsync(request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Create", "Exam", exam.Id.ToString(), request.Title, $"Tip: {request.ExamType}", GetIp()));
        return Created($"/api/v1/exams/{exam.Id}", exam);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<ExamListDto>> UpdateExam(Guid id, [FromBody] UpdateExamRequest request)
    {
        var result = await _examService.UpdateExamAsync(id, request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Update", "Exam", id.ToString(), request.Title, null, GetIp()));
        return Ok(result);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteExam(Guid id)
    {
        await _examService.DeleteExamAsync(id);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Delete", "Exam", id.ToString(), null, null, GetIp()));
        return NoContent();
    }

    // ── Cevap Anahtarı ──

    [HttpPut("{id:guid}/answer-key")]
    public async Task<ActionResult<ExamDetailDto>> UpdateAnswerKey(Guid id, [FromBody] UpdateAnswerKeyRequest request)
    {
        return Ok(await _examService.UpdateAnswerKeyAsync(id, request));
    }

    // ── Durum ──

    [HttpPut("{id:guid}/status")]
    public async Task<ActionResult<ExamListDto>> UpdateStatus(Guid id, [FromBody] UpdateExamStatusRequest request)
    {
        var result = await _examService.UpdateStatusAsync(id, request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "StatusChange", "Exam", id.ToString(), null, $"Yeni durum: {request.Status}", GetIp()));
        return Ok(result);
    }

    // ── PDF ──

    [HttpPut("{id:guid}/pdf")]
    public async Task<ActionResult<ExamDetailDto>> UpdatePdf(Guid id, [FromBody] UpdateExamPdfRequest request)
    {
        return Ok(await _examService.UpdatePdfAsync(id, request));
    }

    // ── Atamalar ──

    [HttpPost("{examId:guid}/assign")]
    public async Task<ActionResult<ExamAssignmentDto>> AssignExam(Guid examId, [FromBody] CreateExamAssignmentRequest request)
    {
        return Ok(await _assignmentService.AssignExamAsync(examId, request));
    }

    [HttpDelete("{examId:guid}/assign/{assignmentId:guid}")]
    public async Task<IActionResult> RemoveAssignment(Guid examId, Guid assignmentId)
    {
        await _assignmentService.RemoveAssignmentAsync(examId, assignmentId);
        return NoContent();
    }

    // ── Sonuçlar ──

    [HttpGet("{examId:guid}/results")]
    public async Task<ActionResult<ExamResultSummaryDto>> GetResults(Guid examId)
    {
        return Ok(await _resultService.GetExamResultsAsync(examId));
    }

    /// GET /api/v1/exams/results/summary — Tüm sınavların genel özeti
    [HttpGet("results/summary")]
    public async Task<ActionResult<ExamOverallSummaryDto>> GetOverallSummary()
    {
        return Ok(await _resultService.GetOverallSummaryAsync());
    }

    // ── Öğrenci Optik Form Gönderimi ──

    [HttpPost("{examId:guid}/submit")]
    public async Task<ActionResult<ExamResultDto>> SubmitAnswers(Guid examId, [FromBody] SubmitExamAnswersRequest request)
    {
        return Ok(await _resultService.SubmitAnswersAsync(examId, GetUserId(), request));
    }

    // ── Öğrenci endpoint'leri ──────────────────────────────────────────────────

    [HttpPost("{examId:guid}/draft")]
    public async Task<IActionResult> SaveDraft(Guid examId, [FromBody] Dictionary<int, string> answers)
    {
        await _resultService.SaveDraftAsync(examId, GetUserId(), answers);
        return Ok();
    }

    [HttpGet("{examId:guid}/draft")]
    public async Task<ActionResult<Dictionary<int, string>>> GetDraft(Guid examId)
    {
        var draft = await _resultService.GetDraftAsync(examId, GetUserId());
        return Ok(draft ?? new Dictionary<int, string>());
    }

    /// GET /api/v1/exams/my-results — Öğrencinin kendi sınav sonuçları
    [HttpGet("my-results")]
    public async Task<ActionResult<List<MyExamResultDto>>> GetMyResults()
        => Ok(await _resultService.GetMyExamResultsAsync(GetUserId()));
}
