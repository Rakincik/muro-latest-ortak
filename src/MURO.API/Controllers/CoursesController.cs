using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Courses;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/courses")]
[Authorize]
public class CoursesController : ControllerBase
{
    private readonly ICourseService _courseService;
    private readonly ICourseSessionService _sessionService;
    private readonly ILiveMeetingService _liveMeetingService;
    private readonly ICourseEnrollmentService _enrollmentService;
    private readonly ICourseMaterialService _materialService;
        private readonly IBackgroundJobQueue _jobQueue;
    private readonly IWebHostEnvironment _env;
    private readonly Microsoft.AspNetCore.OutputCaching.IOutputCacheStore _outputCacheStore;

    public CoursesController(
        ICourseService courseService, 
        ICourseSessionService sessionService,
        ILiveMeetingService liveMeetingService,
        ICourseEnrollmentService enrollmentService,
        ICourseMaterialService materialService,
        
        IBackgroundJobQueue jobQueue, 
        IWebHostEnvironment env,
        Microsoft.AspNetCore.OutputCaching.IOutputCacheStore outputCacheStore)
    {
        _courseService = courseService;
        _sessionService = sessionService;
        _liveMeetingService = liveMeetingService;
        _enrollmentService = enrollmentService;
        _materialService = materialService;
                _jobQueue = jobQueue;
        _env = env;
        _outputCacheStore = outputCacheStore;
    }

    

    private Guid? GetActorId() => Guid.TryParse(User.FindFirst(ClaimTypes.NameIdentifier)?.Value, out var id) ? id : null;
    private string? GetIp() => HttpContext.Connection.RemoteIpAddress?.ToString();

    private bool IsStudent() => User.IsInRole("Student") || 
                                User.HasClaim(c => (c.Type == ClaimTypes.Role || c.Type == "role") && c.Value == "Student");

    // --- Courses ---

    [HttpGet]
    public async Task<ActionResult<PagedResult<CourseListDto>>> GetCourses(
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20,
        [FromQuery] string? search = null, [FromQuery] string? courseType = null,
        [FromQuery] bool? isPublished = null, [FromQuery] Guid? instructorId = null)
    {
        
        // Student: sadece grubundaki dersler
        if (IsStudent())
        {
            var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
            return Ok(await _courseService.GetCoursesByUserAsync(userId, page, pageSize, search, courseType));
        }
        // Admin / Instructor: tüm dersler (Eğitmense sadece kendi dersleri)
        // Eğer query parametresinde instructorId gönderilmemişse ve kişi Instructor rolündeyse kendi ID'sini kullan
        if (!instructorId.HasValue && (User.IsInRole("Instructor") || User.HasClaim(c => (c.Type == ClaimTypes.Role || c.Type == "role") && c.Value == "Instructor")))
        {
            instructorId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        }

        return Ok(await _courseService.GetCoursesAsync(page, pageSize, search, courseType, isPublished, instructorId));
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<CourseDetailDto>> GetCourse(Guid id)
    {
        
        Guid? userId = IsStudent()
            ? Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value)
            : null;
        return Ok(await _courseService.GetCourseByIdAsync(id, userId));
    }

    [HttpPost]
    public async Task<ActionResult<CourseListDto>> CreateCourse([FromBody] CreateCourseRequest request)
    {
        var course = await _courseService.CreateCourseAsync(request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetActorId(), null, "Create", "Course", course.Id.ToString(), request.Title, null, GetIp()));
        
        // Önbelleği patlat (Active Invalidation)
        await _outputCacheStore.EvictByTagAsync("TenantCourses", default);
        
        return Created($"/api/v1/courses/{course.Id}", course);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<CourseListDto>> UpdateCourse(Guid id, [FromBody] UpdateCourseRequest request)
    {
        var result = await _courseService.UpdateCourseAsync(id, request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetActorId(), null, "Update", "Course", id.ToString(), request.Title, null, GetIp()));
        
        // Önbelleği patlat
        await _outputCacheStore.EvictByTagAsync("TenantCourses", default);
        
        return Ok(result);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteCourse(Guid id)
    {
        await _courseService.DeleteCourseAsync(id);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetActorId(), null, "Delete", "Course", id.ToString(), null, null, GetIp()));
        
        // Önbelleği patlat
        await _outputCacheStore.EvictByTagAsync("TenantCourses", default);
        
        return NoContent();
    }

    /// <summary>Ders kapak görseli yükle</summary>
    [HttpPost("{id:guid}/cover")]
    [RequestSizeLimit(10 * 1024 * 1024)] // 10MB
    [RequestFormLimits(MultipartBodyLengthLimit = 10 * 1024 * 1024)]
    public async Task<ActionResult<object>> UploadCover(Guid id, [FromForm] IFormFile file)
    {
        if (file == null || file.Length == 0) return BadRequest("Dosya boş.");
        var ext = Path.GetExtension(file.FileName).ToLowerInvariant();
        if (!new[] { ".jpg", ".jpeg", ".png", ".webp", ".gif" }.Contains(ext))
            return BadRequest("Geçersiz dosya formatı. JPG, PNG, WebP veya GIF olmalı.");

        var wwwroot = _env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        var dir = Path.Combine(wwwroot, "uploads", "covers");
        Directory.CreateDirectory(dir);

        var fileName = $"{id}{ext}";
        var filePath = Path.Combine(dir, fileName);

        await using var stream = new FileStream(filePath, FileMode.Create);
        await file.CopyToAsync(stream);

        var host = HttpContext.Request.Headers["X-Forwarded-Host"].FirstOrDefault() ?? HttpContext.Request.Host.Value;
        var scheme = host.Contains("localhost") ? "http" : "https";
        var url = $"{scheme}://{host}/api/v1/uploads/covers/{fileName}";

        // Course'un thumbnailUrl'ini güncelle
        await _courseService.UpdateCourseAsync(id, new UpdateCourseRequest(
            null, null, url, null, null, null, null, null));

        return Ok(new { url });
    }

    // --- Sessions ---

    [HttpPost("{courseId:guid}/sessions")]
    public async Task<ActionResult<SessionDto>> CreateSession(Guid courseId, [FromBody] CreateSessionRequest request)
    {
        var session = await _sessionService.CreateSessionAsync(courseId, request);
        return Created($"/api/v1/courses/{courseId}/sessions/{session.Id}", session);
    }

    [HttpPut("{courseId:guid}/sessions/{sessionId:guid}")]
    public async Task<ActionResult<SessionDto>> UpdateSession(Guid courseId, Guid sessionId, [FromBody] UpdateSessionRequest request)
    {
        return Ok(await _sessionService.UpdateSessionAsync(courseId, sessionId, request));
    }

    [HttpDelete("{courseId:guid}/sessions/{sessionId:guid}")]
    public async Task<IActionResult> DeleteSession(Guid courseId, Guid sessionId)
    {
        await _sessionService.DeleteSessionAsync(courseId, sessionId);
        return NoContent();
    }

    [HttpPost("{courseId:guid}/vod")]
    public async Task<ActionResult<SessionDto>> AddVodSession(Guid courseId, [FromBody] CreateVodRequest request)
    {
        var session = await _sessionService.CreateVodSessionAsync(courseId, request.Title, request.FilePath, request.DurationSeconds);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetActorId(), null, "Create", "VideoSession", session.Id.ToString(), request.Title, null, GetIp()));
        return Created($"/api/v1/courses/{courseId}/sessions/{session.Id}", session);
    }

    /// <summary>
    /// Fix #2: Tüm tenant'ın yayınlanmış kurs oturumlarını tek istekte döner.
    /// Frontend'deki N+1 HTTP döngüsünü ortadan kaldırır.
    /// </summary>
    [HttpGet("/api/v1/sessions/upcoming")]
    public async Task<ActionResult<List<UpcomingSessionDto>>> GetUpcomingSessions()
    {
        
        // Student: sadece canlı ders (Online veya Both) erişimi olan grubun oturumları
        if (IsStudent())
        {
            var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
            return Ok(await _sessionService.GetUpcomingSessionsByUserAsync(userId));
        }
        return Ok(await _sessionService.GetUpcomingSessionsAsync());
    }

    [HttpPut("{courseId:guid}/sessions/reorder")]
    public async Task<IActionResult> ReorderSessions(Guid courseId, [FromBody] List<Guid> sessionIds)
    {
        await _sessionService.ReorderSessionsAsync(courseId, sessionIds);
        return Ok(new { message = "Sıralama güncellendi." });
    }

    // --- BBB Session Lifecycle ---

    /// <summary>
    /// Dersi başlat: BBB'de meeting açar, Session.Status = Live yapar, öğrencilere bildirim gönderir.
    /// Sadece Admin ve Instructor çağırabilir.
    /// </summary>
    [HttpPost("{courseId:guid}/sessions/{sessionId:guid}/start")]
    [Authorize(Roles = "Admin,SuperAdmin,Instructor")]
    public async Task<ActionResult<SessionStartResult>> StartSession(Guid courseId, Guid sessionId)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var result = await _liveMeetingService.StartSessionAsync(courseId, sessionId, userId);
        await _jobQueue.EnqueueAsync(new AuditLogJob(userId, null, "StartLive", "Session", sessionId.ToString(), null, $"CourseId: {courseId}", GetIp()));
        return Ok(result);
    }

    /// <summary>
    /// Derse katıl: Kullanıcıya özel BBB join URL'i döndürür.
    /// Role'e göre moderatör veya katılımcı URL'i üretilir.
    /// </summary>
    [HttpPost("{courseId:guid}/sessions/{sessionId:guid}/join")]
    public async Task<ActionResult<SessionJoinResult>> JoinSession(Guid courseId, Guid sessionId)
    {
        var userId = Guid.Parse(User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)!.Value);
        var firstName = User.FindFirst("firstName")?.Value ?? "";
        var lastName  = User.FindFirst("lastName")?.Value ?? "";
        var fullName  = $"{firstName} {lastName}".Trim();

        // Student: grup erişim kontrolü aktif
        bool checkGroupAccess = IsStudent();

        var result = await _liveMeetingService.JoinSessionAsync(
            courseId, sessionId, userId, fullName, checkGroupAccess);
        return Ok(result);
    }

    /// <summary>
    /// Dersi bitir: BBB'ye end çağrısı gönderir, Session.Status = Ended yapar.
    /// Sadece Admin ve Instructor çağırabilir.
    /// </summary>
    [HttpPost("{courseId:guid}/sessions/{sessionId:guid}/end")]
    [Authorize(Roles = "Admin,SuperAdmin,Instructor")]
    public async Task<IActionResult> EndSession(Guid courseId, Guid sessionId)
    {
        await _liveMeetingService.EndSessionAsync(courseId, sessionId);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetActorId(), null, "EndLive", "Session", sessionId.ToString(), null, $"CourseId: {courseId}", GetIp()));
        return Ok(new { message = "Ders sonlandırıldı." });
    }

    // --- Group Assignment ---

    [HttpPost("{courseId:guid}/groups")]
    public async Task<IActionResult> AssignToGroup(Guid courseId, [FromBody] AssignCourseToGroupRequest request)
    {
        await _enrollmentService.AssignToGroupAsync(courseId, request.GroupId, request.Mode);
        return Ok(new { message = "Ders gruba atandı." });
    }

    [HttpDelete("{courseId:guid}/groups/{groupId:guid}")]
    public async Task<IActionResult> RemoveFromGroup(Guid courseId, Guid groupId)
    {
        await _enrollmentService.RemoveFromGroupAsync(courseId, groupId);
        return NoContent();
    }

    // --- Direct Student Assignment ---

    [HttpPost("{courseId:guid}/students")]
    [Authorize(Roles = "Admin,SuperAdmin,Instructor")]
    public async Task<IActionResult> AssignToStudent(Guid courseId, [FromBody] AssignCourseToStudentRequest request)
    {
        await _enrollmentService.AssignToStudentAsync(courseId, request.UserId);
        return Ok(new { message = "Öğrenci derse doğrudan atandı." });
    }

    [HttpPut("{courseId:guid}/students/{userId:guid}/expires-at")]
    [Authorize(Roles = "Admin,SuperAdmin,Instructor")]
    public async Task<IActionResult> UpdateStudentExpiration(Guid courseId, Guid userId, [FromBody] UpdateStudentExpirationRequest request)
    {
        await _enrollmentService.UpdateStudentExpirationAsync(courseId, userId, request.ExpiresAt);
        return Ok(new { message = "Erişim bitiş tarihi güncellendi." });
    }

    [HttpDelete("{courseId:guid}/students/{userId:guid}")]
    [Authorize(Roles = "Admin,SuperAdmin,Instructor")]
    public async Task<IActionResult> RemoveFromStudent(Guid courseId, Guid userId)
    {
        await _enrollmentService.RemoveFromStudentAsync(courseId, userId);
        return NoContent();
    }

    [HttpGet("{courseId:guid}/students")]
    [Authorize(Roles = "Admin,SuperAdmin,Instructor")]
    public async Task<ActionResult<List<CourseStudentListDto>>> GetEnrolledStudents(Guid courseId)
    {
        var students = await _enrollmentService.GetEnrolledStudentsAsync(courseId);
        return Ok(students);
    }

    // --- Course Materials (Dokümanlar) ---

    [HttpGet("{courseId:guid}/materials")]
    public async Task<ActionResult<List<CourseMaterialDto>>> GetMaterials(Guid courseId)
    {

        var materials = await _materialService.GetMaterialsAsync(courseId);
        return Ok(materials);
    }

    [HttpPost("{courseId:guid}/materials")]
    [RequestSizeLimit(50_000_000)] // 50 MB
    [RequestFormLimits(MultipartBodyLengthLimit = 50_000_000)]
    public async Task<ActionResult<CourseMaterialDto>> UploadMaterial(Guid courseId, [FromForm] IFormFile file, [FromForm] string? title)
    {
        if (file == null || file.Length == 0)
            return BadRequest(new { message = "Dosya seçilmedi." });


        var wwwroot = _env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        var result = await _materialService.UploadMaterialAsync(courseId, file.OpenReadStream(), file.FileName, file.ContentType, file.Length, title, wwwroot);
        return Created($"/api/v1/courses/{courseId}/materials/{result.Id}", result);
    }

    [HttpDelete("{courseId:guid}/materials/{materialId:guid}")]
    public async Task<IActionResult> DeleteMaterial(Guid courseId, Guid materialId)
    {
        var wwwroot = _env.WebRootPath ?? Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        await _materialService.DeleteMaterialAsync(courseId, materialId, wwwroot);
        return NoContent();
    }
}
