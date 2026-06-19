using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Assignments;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/assignments")]
[Authorize]
public class AssignmentsController : ControllerBase
{
    private readonly IAssignmentService _assignmentService;
        private readonly IBackgroundJobQueue _jobQueue;

    public AssignmentsController(IAssignmentService assignmentService, IBackgroundJobQueue jobQueue)
    {
        _assignmentService = assignmentService;
                _jobQueue = jobQueue;
    }

    

    private Guid GetUserId() =>
        Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier) ?? throw new UnauthorizedAccessException());

    private string? GetIp() => HttpContext.Connection.RemoteIpAddress?.ToString();

    [HttpGet]
    public async Task<ActionResult<PagedResult<AssignmentListDto>>> GetAssignments(
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20, [FromQuery] Guid? courseId = null)
    {
        return Ok(await _assignmentService.GetAssignmentsAsync(page, pageSize, courseId));
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<AssignmentDetailDto>> GetAssignment(Guid id)
    {
        return Ok(await _assignmentService.GetAssignmentByIdAsync(id));
    }

    [HttpPost]
    public async Task<ActionResult<AssignmentListDto>> CreateAssignment([FromBody] CreateAssignmentRequest request)
    {
        var a = await _assignmentService.CreateAssignmentAsync(request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Create", "Assignment", a.Id.ToString(), request.Title, null, GetIp()));
        return Created($"/api/v1/assignments/{a.Id}", a);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<AssignmentListDto>> UpdateAssignment(Guid id, [FromBody] UpdateAssignmentRequest request)
    {
        var a = await _assignmentService.UpdateAssignmentAsync(id, request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Update", "Assignment", id.ToString(), request.Title, null, GetIp()));
        return Ok(a);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteAssignment(Guid id)
    {
        await _assignmentService.DeleteAssignmentAsync(id);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Delete", "Assignment", id.ToString(), null, null, GetIp()));
        return NoContent();
    }

    // --- Submissions ---

    [HttpPost("{assignmentId:guid}/submit")]
    public async Task<ActionResult<SubmissionDto>> Submit(Guid assignmentId, [FromBody] SubmitAssignmentRequest request)
    {
        var s = await _assignmentService.SubmitAsync(assignmentId, GetUserId(), request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Submit", "Assignment", assignmentId.ToString(), null, $"SubmissionId: {s.Id}", GetIp()));
        return Created($"/api/v1/assignments/{assignmentId}/submissions/{s.Id}", s);
    }

    [HttpPut("{assignmentId:guid}/submissions/{submissionId:guid}/grade")]
    public async Task<ActionResult<SubmissionDto>> GradeSubmission(Guid assignmentId, Guid submissionId, [FromBody] GradeSubmissionRequest request)
    {
        var result = await _assignmentService.GradeSubmissionAsync(assignmentId, submissionId, request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Grade", "Assignment", assignmentId.ToString(), null, $"Puan: {request.Score}", GetIp()));
        return Ok(result);
    }

    // ── Öğrenci endpoint'leri ──────────────────────────────────────────────────

    /// GET /api/v1/assignments/my — Öğrencinin kendi ödevleri + gönderim durumu
    [HttpGet("my")]
    public async Task<ActionResult<List<MyAssignmentDto>>> GetMyAssignments()
        => Ok(await _assignmentService.GetMyAssignmentsAsync(GetUserId()));
}
