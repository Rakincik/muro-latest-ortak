using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.API.Controllers.Admin;

[EnableRateLimiting("ApiPolicy")]
[Authorize(Roles = "SuperAdmin")]
[ApiController]
[Route("api/v1/admin/bbb")]
public class AdminBbbController : ControllerBase
{
    private readonly IBbbService _bbbService;
    private readonly MuroDbContext _context;

    public AdminBbbController(IBbbService bbbService, MuroDbContext context)
    {
        _bbbService = bbbService;
        _context = context;
    }

    [HttpGet("recordings")]
    public async Task<IActionResult> GetRecordings()
    {
        try
        {
            var recordings = await _bbbService.GetRecordingsAsync(null);
            return Ok(recordings);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { error = "BBB sunucusundan kayıtlar çekilemedi.", details = ex.Message });
        }
    }

    [HttpPost("recordings/assign")]
    public async Task<IActionResult> AssignRecording([FromBody] AssignRecordingRequest request)
    {
        if (request.SessionId == Guid.Empty || string.IsNullOrWhiteSpace(request.PlaybackUrl))
        {
            return BadRequest(new { error = "SessionId ve PlaybackUrl alanları zorunludur." });
        }

        var session = await _context.Sessions
            .FirstOrDefaultAsync(s => s.Id == request.SessionId);

        if (session == null)
        {
            return NotFound(new { error = "Oturum (Session) bulunamadı." });
        }

        // 1. SessionRecording bul veya yarat
        var recording = await _context.SessionRecordings
            .Include(r => r.MediaAsset)
            .FirstOrDefaultAsync(r => r.SessionId == request.SessionId);

        if (recording == null)
        {
            recording = new SessionRecording
            {
                Id = Guid.NewGuid(),
                SessionId = session.Id,
                Status = MediaStatus.Ready,
                CreatedAt = DateTime.UtcNow
            };
            _context.SessionRecordings.Add(recording);
        }
        else
        {
            recording.Status = MediaStatus.Ready;
        }

        // 2. MediaAsset bul veya yarat
        var asset = recording.MediaAsset;
        if (asset == null)
        {
            asset = new MediaAsset
            {
                Id = Guid.NewGuid(),
                CourseId = session.CourseId,
                CreatedAt = DateTime.UtcNow
            };
            _context.MediaAssets.Add(asset);
            recording.MediaAssetId = asset.Id;
        }

        asset.Title = $"{session.Title} — Kayıt";
        asset.FilePath = request.PlaybackUrl;
        asset.HlsPath = null;
        asset.DurationSeconds = request.DurationSeconds;
        asset.Status = MediaStatus.Ready;

        // 3. CourseMedia linki var mı kontrol et ve yoksa ekle
        var existsInMedia = await _context.CourseMedias.AnyAsync(cm => cm.SessionId == session.Id);
        if (!existsInMedia)
        {
            var hasManualSort = await _context.CourseMedias
                .AnyAsync(cm => cm.CourseId == session.CourseId && cm.OrderIndex >= 0);

            int orderIndex = -1;
            if (hasManualSort)
            {
                var courseMediaMaxOrder = await _context.CourseMedias
                    .Where(cm => cm.CourseId == session.CourseId)
                    .MaxAsync(cm => (int?)cm.OrderIndex) ?? -1;
                orderIndex = courseMediaMaxOrder + 1;
            }

            _context.CourseMedias.Add(new CourseMedia
            {
                CourseId = session.CourseId,
                SessionId = session.Id,
                OrderIndex = orderIndex
            });
        }

        // BbbMeetingId'yi güncelle
        if (!string.IsNullOrEmpty(request.RecordingId))
        {
            session.BbbMeetingId = request.RecordingId;
        }

        await _context.SaveChangesAsync();

        return Ok(new { success = true, recordingId = recording.Id });
    }
}

public record AssignRecordingRequest(
    Guid SessionId,
    string? RecordingId,
    string PlaybackUrl,
    int DurationSeconds
);
