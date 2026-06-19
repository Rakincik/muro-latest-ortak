using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.Interfaces;
using MURO.Application.DTOs.Security;

namespace MURO.API.Controllers;

/// <summary>
/// Güvenlik audit loglarını admin paneline sunar.
/// </summary>
[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/security")]
[Authorize(Roles = "Admin,SuperAdmin")]
public class SecurityController : ControllerBase
{
    private readonly ISecurityService _securityService;
    
    public SecurityController(ISecurityService securityService)
    {
        _securityService = securityService;
            }

    

    [HttpGet("events")]
    public async Task<ActionResult<SecurityEventPageDto>> GetEvents(
        [FromQuery] DateTime? from,
        [FromQuery] DateTime? to,
        [FromQuery] Guid? userId,
        [FromQuery] string? eventType,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50)
    {
        
        var events = await _securityService.GetEventsAsync(from, to, userId, eventType, page, pageSize);
        return Ok(events);
    }

    [HttpGet("summary")]
    public async Task<ActionResult> GetSummary()
    {
        
        var summary = await _securityService.GetSummaryAsync();
        return Ok(summary);
    }

    [HttpGet("suspicious")]
    public async Task<ActionResult> GetSuspiciousActivity()
    {
        
        var suspicious = await _securityService.GetSuspiciousActivityAsync();
        return Ok(suspicious);
    }
}
