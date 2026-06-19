using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs.Calendar;
using MURO.Application.Interfaces;
using System.Security.Claims;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/student")]
[Authorize]
public class StudentController : ControllerBase
{
    private readonly IStudentService _studentService;
        private readonly IAnalyticsService _analyticsService;
    private readonly ICourseService _courseService;
    private readonly ICourseSessionService _sessionService;
    private readonly INotificationService _notificationService;

    public StudentController(
        IStudentService studentService, 
        
        IAnalyticsService analyticsService,
        ICourseService courseService,
        ICourseSessionService sessionService,
        INotificationService notificationService)
    {
        _studentService = studentService;
                _analyticsService = analyticsService;
        _courseService = courseService;
        _sessionService = sessionService;
        _notificationService = notificationService;
    }

    

    private Guid GetUserId() =>
        Guid.Parse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? throw new UnauthorizedAccessException("Kullanıcı kimliği bulunamadı."));

    [HttpGet("calendar")]
    public async Task<ActionResult<List<CalendarEventDto>>> GetCalendar(
        [FromQuery] DateTime? from = null,
        [FromQuery] DateTime? to = null,
        [FromQuery] int? year = null,
        [FromQuery] int? month = null)
    {
        DateTime start, end;
        if (year.HasValue && month.HasValue)
        {
            start = new DateTime(year.Value, month.Value, 1, 0, 0, 0, DateTimeKind.Utc);
            end = start.AddMonths(1).AddSeconds(-1);
        }
        else
        {
            start = from ?? DateTime.UtcNow.AddMonths(-1);
            end = to ?? DateTime.UtcNow.AddMonths(1);
        }

        var events = await _studentService.GetCalendarEventsAsync(GetUserId(), start, end);
        return Ok(events);
    }

    /// <summary>
    /// BFF (Backend For Frontend): Öğrenci dashboard'u için gerekli tüm verileri tek seferde döner.
    /// 10k kullanıcı optimizasyonunun en kritik endpointidir (N+1 problemi çözer).
    /// </summary>
    [HttpGet("dashboard-summary")]
    public async Task<ActionResult<MURO.Application.DTOs.Analytics.StudentDashboardSummaryDto>> GetDashboardSummary()
    {
        
        var userId = GetUserId();

        // Güvenli kapsayıcılar (Partial Failure engellemek için)
        async Task<MURO.Application.DTOs.Analytics.StudentDashboardDto> SafeGetStats() {
            try { return await _analyticsService.GetStudentDashboardAsync(userId); }
            catch { return new MURO.Application.DTOs.Analytics.StudentDashboardDto(0, 0, 0, 0, 0, 0, 0, new(), new()); }
        }

        async Task<List<MURO.Application.DTOs.Courses.CourseListDto>> SafeGetCourses() {
            try { return (await _courseService.GetCoursesByUserAsync(userId, 1, 4, null, null)).Items; }
            catch { return new List<MURO.Application.DTOs.Courses.CourseListDto>(); }
        }

        async Task<List<MURO.Application.DTOs.Courses.UpcomingSessionDto>> SafeGetSessions() {
            try { return await _sessionService.GetUpcomingSessionsByUserAsync(userId); }
            catch { return new List<MURO.Application.DTOs.Courses.UpcomingSessionDto>(); }
        }

        async Task<int> SafeGetUnreadCount() {
            try { return await _notificationService.GetUnreadCountAsync(userId); }
            catch { return 0; }
        }

        // Sıralı çağrılar — DbContext thread-safe değildir, paralel kullanılamaz!
        var stats = await SafeGetStats();
        var courses = await SafeGetCourses();
        var sessions = await SafeGetSessions();
        var unreadCount = await SafeGetUnreadCount();

        var dto = new MURO.Application.DTOs.Analytics.StudentDashboardSummaryDto(
            stats,
            courses,
            sessions,
            unreadCount
        );

        return Ok(dto);
    }
}
