using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using MURO.Application.DTOs.Integrations;
using MURO.Application.Interfaces;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.API.Controllers.Admin;

[EnableRateLimiting("ApiPolicy")]
[Authorize(Roles = "SuperAdmin,Admin")]
[ApiController]
[Route("api/v1/admin/sms")]
public class AdminSmsCenterController : ControllerBase
{
    private readonly IBulkSmsService _bulkSmsService;
    private readonly ISmsService _smsService;
    private readonly MuroDbContext _context;

    public AdminSmsCenterController(
        IBulkSmsService bulkSmsService,
        ISmsService smsService,
        MuroDbContext context)
    {
        _bulkSmsService = bulkSmsService;
        _smsService = smsService;
        _context = context;
    }

    [HttpGet("targets")]
    public async Task<IActionResult> GetSmsTargets()
    {
        var courses = await _context.Courses
            .AsNoTracking()
            .OrderBy(c => c.Title)
            .Select(c => new { c.Id, Title = c.Title, Type = "course" })
            .ToListAsync(HttpContext.RequestAborted);

        var groups = await _context.Groups
            .AsNoTracking()
            .OrderBy(g => g.Name)
            .Select(g => new { g.Id, Title = g.Name, Type = "group" })
            .ToListAsync(HttpContext.RequestAborted);

        var packages = await _context.Packages
            .AsNoTracking()
            .OrderBy(p => p.Name)
            .Select(p => new { p.Id, Title = p.Name, Type = "package" })
            .ToListAsync(HttpContext.RequestAborted);

        return Ok(new
        {
            courses,
            groups,
            packages
        });
    }

    [HttpGet("search-students")]
    public async Task<IActionResult> SearchStudents([FromQuery] string? q)
    {
        var query = _context.Users
            .AsNoTracking()
            .Where(u => u.Role == UserRole.Student && !u.IsDeleted);

        if (!string.IsNullOrWhiteSpace(q))
        {
            var clean = q.Trim().ToLowerInvariant();
            query = query.Where(u => 
                u.FirstName.ToLower().Contains(clean) ||
                u.LastName.ToLower().Contains(clean) ||
                (u.Phone != null && u.Phone.Contains(clean)) ||
                (u.Email != null && u.Email.ToLower().Contains(clean)) ||
                (u.Username != null && u.Username.ToLower().Contains(clean)));
        }

        var students = await query
            .OrderByDescending(u => u.CreatedAt)
            .Take(25)
            .Select(u => new
            {
                u.Id,
                FullName = $"{u.FirstName} {u.LastName}".Trim(),
                u.Phone,
                u.Email,
                u.Username
            })
            .ToListAsync(HttpContext.RequestAborted);

        return Ok(students);
    }

    [HttpPost("preview")]
    public async Task<IActionResult> PreviewRecipients([FromBody] BulkSmsCampaignRequest request)
    {
        var result = await _bulkSmsService.PreviewRecipientsAsync(request, HttpContext.RequestAborted);
        return Ok(result);
    }

    [HttpPost("send-bulk")]
    public async Task<IActionResult> SendBulkCampaign([FromBody] BulkSmsCampaignRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.MessageTemplate))
        {
            return BadRequest(new { error = "Mesaj metni boş olamaz." });
        }

        var result = await _bulkSmsService.SendBulkCampaignAsync(request, HttpContext.RequestAborted);
        return Ok(result);
    }

    [HttpGet("triggers")]
    public async Task<IActionResult> GetTriggers()
    {
        var settings = await _bulkSmsService.GetTriggerSettingsAsync(HttpContext.RequestAborted);
        return Ok(settings);
    }

    [HttpPut("triggers")]
    public async Task<IActionResult> UpdateTriggers([FromBody] SmsTriggerSettingsDto settings)
    {
        var updated = await _bulkSmsService.UpdateTriggerSettingsAsync(settings, HttpContext.RequestAborted);
        return Ok(updated);
    }
}
