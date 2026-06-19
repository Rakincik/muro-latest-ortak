using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs.Attendance;
using MURO.Application.Interfaces;
using System.Security.Claims;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/attendance")]
[Authorize]
public class SessionAttendanceController : ControllerBase
{
    private readonly ISessionAttendanceService _attendanceService;
    
    public SessionAttendanceController(ISessionAttendanceService attendanceService)
    {
        _attendanceService = attendanceService;
            }

    // Eğitmen / Admin: Bir sınıf yoklamasının tüm özeti
    [HttpGet("sessions/{sessionId}")]
    public async Task<ActionResult<AttendanceSummaryDto>> GetSessionAttendance(Guid sessionId)
    {

        var result = await _attendanceService.GetAttendanceBySessionAsync(sessionId);
        return Ok(result);
    }

    // Öğrenci: Kendi ders katılım geçmişim
    [HttpGet("my")]
    public async Task<ActionResult<List<MyAttendanceDto>>> GetMyAttendance()
    {

        var userId = Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        var result = await _attendanceService.GetMyAttendanceHistoryAsync(userId);
        return Ok(result);
    }
}
