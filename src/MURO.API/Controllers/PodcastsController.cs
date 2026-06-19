using Microsoft.AspNetCore.RateLimiting;
using MURO.API.Middleware;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Podcasts;
using MURO.Application.Interfaces;
using MURO.API.Filters;

namespace MURO.API.Controllers;

[EnableRateLimiting(RateLimitingConfig.ApiPolicy)]
[ApiController]
[Route("api/v1/podcasts")]
[Authorize]
[RequireFeature("podcast")]
public class PodcastsController : ControllerBase
{
    private readonly IPodcastService _podcastService;
        private readonly IWebHostEnvironment _env;
    private readonly IBackgroundJobQueue _jobQueue;

    public PodcastsController(
        IPodcastService podcastService,
        
        IWebHostEnvironment env,
        IBackgroundJobQueue jobQueue)
    {
        _podcastService = podcastService;
        _env            = env;
        _jobQueue       = jobQueue;
    }

    
    private Guid GetUserId() => Guid.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
    private string? GetIp() => HttpContext.Connection.RemoteIpAddress?.ToString();

    // ─── CRUD ─────────────────────────────────────────────────────────────────

    [HttpGet]
    public async Task<ActionResult<PagedResult<PodcastDto>>> GetPodcasts(
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20, [FromQuery] Guid? courseId = null)
        => Ok(await _podcastService.GetPodcastsAsync(page, pageSize, courseId));

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<PodcastDto>> GetPodcast(Guid id)
        => Ok(await _podcastService.GetByIdAsync(id));

    [HttpPost]
    public async Task<ActionResult<PodcastDto>> Create([FromBody] CreatePodcastRequest request)
    {
        var p = await _podcastService.CreateAsync(request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Create", "Podcast", p.Id.ToString(), request.Title, null, GetIp()));
        return Created($"/api/v1/podcasts/{p.Id}", p);
    }

    [HttpPut("{id:guid}/status")]
    public async Task<ActionResult<PodcastDto>> UpdateStatus(Guid id, [FromBody] string status)
        => Ok(await _podcastService.UpdateStatusAsync(id, status));

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        await _podcastService.DeleteAsync(id);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Delete", "Podcast", id.ToString(), null, null, GetIp()));
        return NoContent();
    }

    // ─── AI Generate ──────────────────────────────────────────────────────────

    /// <summary>
    /// Ham metinden AI podcast üretir (Gemini scripting + edge-tts).
    /// </summary>
    [HttpPost("generate")]
    public async Task<ActionResult<PodcastDto>> Generate([FromBody] GeneratePodcastRequest request)
    {
        var p = await _podcastService.GenerateAsync(request);
        await _jobQueue.EnqueueAsync(new AuditLogJob(GetUserId(), null, "Generate", "Podcast", p.Id.ToString(), request.Title, "AI Generated", GetIp()));
        return Created($"/api/v1/podcasts/{p.Id}", p);
    }

    // ─── Audio Streaming ──────────────────────────────────────────────────────

    /// <summary>
    /// Podcast ses dosyasını stream eder.
    /// </summary>
    [HttpGet("{id:guid}/audio")]
    [AllowAnonymous] // Öğrenciler token olmadan da dinleyebilsin
    public async Task<IActionResult> GetAudio(Guid id)
    {
        // Tenant kontrolü: tüm tenantlarda bak (anonymous için)
        var podcast = await _podcastService.GetByIdForStreamAsync(id);
        if (podcast?.AudioFilePath is null)
            return NotFound("Ses dosyası bulunamadı.");

        var fullPath = Path.Combine(
            _env.WebRootPath ?? Directory.GetCurrentDirectory(),
            podcast.AudioFilePath.TrimStart('/').Replace('/', Path.DirectorySeparatorChar));

        if (!System.IO.File.Exists(fullPath))
            return NotFound("Ses dosyası fiziksel olarak bulunamadı.");

        new FileExtensionContentTypeProvider().TryGetContentType(fullPath, out var contentType);
        return PhysicalFile(fullPath, contentType ?? "audio/mpeg", enableRangeProcessing: true);
    }
}
