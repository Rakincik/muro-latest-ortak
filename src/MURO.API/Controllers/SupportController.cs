using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Support;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/support")]
[Authorize]
public class SupportController : ControllerBase
{
    private readonly ISupportService _supportService;
        private readonly IBackgroundJobQueue _jobQueue;

    public SupportController(ISupportService supportService, IBackgroundJobQueue jobQueue)
    {
        _supportService = supportService;
                _jobQueue = jobQueue;
    }

    
    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    private string? GetIp() => HttpContext.Connection.RemoteIpAddress?.ToString();

    // --- Tickets ---
    [HttpGet("tickets")]
    public async Task<ActionResult<PagedResult<TicketListDto>>> GetTickets(
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20, [FromQuery] string? status = null)
    {
        var isAdmin = User.IsInRole("Admin") || User.IsInRole("SuperAdmin");
        var userId = isAdmin ? (Guid?)null : GetUserId();
        return Ok(await _supportService.GetTicketsAsync(page, pageSize, status, userId));
    }

    [HttpGet("tickets/{id:guid}")]
    public async Task<ActionResult<TicketDetailDto>> GetTicket(Guid id)
        => Ok(await _supportService.GetTicketByIdAsync(id));

    [HttpPost("tickets")]
    public async Task<ActionResult<TicketListDto>> CreateTicket([FromBody] CreateTicketRequest request)
    {
        var t = await _supportService.CreateTicketAsync(GetUserId(), request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Create", "Ticket", t.Id.ToString(), request.Subject, null, GetIp()));
        return Created($"/api/v1/support/tickets/{t.Id}", t);
    }

    [HttpPost("tickets/{ticketId:guid}/reply")]
    public async Task<ActionResult<TicketMessageDto>> Reply(Guid ticketId, [FromBody] ReplyTicketRequest request)
        => Ok(await _supportService.ReplyAsync(ticketId, GetUserId(), request));

    public class UpdateTicketStatusRequest { public string Status { get; set; } = null!; }

    [HttpPut("tickets/{ticketId:guid}/status")]
    public async Task<IActionResult> UpdateTicketStatus(Guid ticketId, [FromBody] UpdateTicketStatusRequest request)
    {
        await _supportService.UpdateTicketStatusAsync(ticketId, request.Status);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "UpdateStatus", "Ticket", ticketId.ToString(), request.Status, null, GetIp()));
        return NoContent();
    }

    [HttpDelete("tickets/{ticketId:guid}")]
    [Authorize(Roles = "Admin,SuperAdmin")] // Yalnızca admin silebilir
    public async Task<IActionResult> DeleteTicket(Guid ticketId)
    {
        await _supportService.DeleteTicketAsync(ticketId);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Delete", "Ticket", ticketId.ToString(), null, null, GetIp()));
        return NoContent();
    }

    // --- FAQ ---
    [HttpGet("faq")]
    public async Task<ActionResult<List<FaqDto>>> GetFaqs()
        => Ok(await _supportService.GetFaqsAsync());

    [HttpPost("faq")]
    public async Task<ActionResult<FaqDto>> CreateFaq([FromBody] CreateFaqRequest request)
    {
        var f = await _supportService.CreateFaqAsync(request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Create", "FAQ", f.Id.ToString(), request.QuestionText, null, GetIp()));
        return Created($"/api/v1/support/faq/{f.Id}", f);
    }

    [HttpPut("faq/{id:guid}")]
    public async Task<ActionResult<FaqDto>> UpdateFaq(Guid id, [FromBody] UpdateFaqRequest request)
        => Ok(await _supportService.UpdateFaqAsync(id, request));

    [HttpDelete("faq/{id:guid}")]
    public async Task<IActionResult> DeleteFaq(Guid id)
    {
        await _supportService.DeleteFaqAsync(id);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Delete", "FAQ", id.ToString(), null, null, GetIp()));
        return NoContent();
    }
}
