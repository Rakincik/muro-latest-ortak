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
        if (string.IsNullOrWhiteSpace(request.PlaybackUrl))
        {
            return BadRequest(new { error = "PlaybackUrl alanı zorunludur." });
        }

        if ((request.SessionId == null || request.SessionId == Guid.Empty) && (request.CourseId == null || request.CourseId == Guid.Empty))
        {
            return BadRequest(new { error = "SessionId veya CourseId alanlarından en az biri zorunludur." });
        }

        Guid? courseId = request.CourseId;
        Guid? sessionId = request.SessionId;

        // Oturum seçilmişse (SessionId varsa) eski mantıkla bağla
        if (sessionId != null && sessionId != Guid.Empty)
        {
            var session = await _context.Sessions
                .FirstOrDefaultAsync(s => s.Id == sessionId);

            if (session == null)
            {
                return NotFound(new { error = "Oturum (Session) bulunamadı." });
            }

            courseId = session.CourseId;

            // 1. SessionRecording bul veya yarat
            var recording = await _context.SessionRecordings
                .Include(r => r.MediaAsset)
                .FirstOrDefaultAsync(r => r.SessionId == sessionId);

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
                    CourseId = courseId,
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
                    .AnyAsync(cm => cm.CourseId == courseId && cm.OrderIndex >= 0);

                int orderIndex = -1;
                if (hasManualSort)
                {
                    var courseMediaMaxOrder = await _context.CourseMedias
                        .Where(cm => cm.CourseId == courseId)
                        .MaxAsync(cm => (int?)cm.OrderIndex) ?? -1;
                    orderIndex = courseMediaMaxOrder + 1;
                }

                _context.CourseMedias.Add(new CourseMedia
                {
                    CourseId = courseId.Value,
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
        else
        {
            // Ders seçilmişse (CourseId varsa) bağımsız video (MediaAsset) olarak ekle
            var course = await _context.Courses.FirstOrDefaultAsync(c => c.Id == courseId);
            if (course == null)
            {
                return NotFound(new { error = "Ders (Course) bulunamadı." });
            }

            string videoTitle = "Canlı Ders Kaydı";
            if (!string.IsNullOrEmpty(request.RecordingId))
            {
                try
                {
                    var recordings = await _bbbService.GetRecordingsAsync(null);
                    var matchingRec = recordings.FirstOrDefault(r => r.RecordingId == request.RecordingId);
                    if (matchingRec != null && !string.IsNullOrEmpty(matchingRec.Name))
                    {
                        videoTitle = matchingRec.Name;
                    }
                    else
                    {
                        videoTitle = $"Kayıt — {request.RecordingId.Substring(0, 8)}";
                    }
                }
                catch {
                    videoTitle = $"Kayıt — {request.RecordingId.Substring(0, 8)}";
                }
            }

            var asset = new MediaAsset
            {
                Id = Guid.NewGuid(),
                CourseId = courseId,
                Title = videoTitle,
                FilePath = request.PlaybackUrl,
                HlsPath = null,
                DurationSeconds = request.DurationSeconds,
                Status = MediaStatus.Ready,
                CreatedAt = DateTime.UtcNow
            };
            _context.MediaAssets.Add(asset);

            // CourseMedia'ya ekle
            var hasManualSort = await _context.CourseMedias
                .AnyAsync(cm => cm.CourseId == courseId && cm.OrderIndex >= 0);

            int orderIndex = -1;
            if (hasManualSort)
            {
                var courseMediaMaxOrder = await _context.CourseMedias
                    .Where(cm => cm.CourseId == courseId)
                    .MaxAsync(cm => (int?)cm.OrderIndex) ?? -1;
                orderIndex = courseMediaMaxOrder + 1;
            }

            _context.CourseMedias.Add(new CourseMedia
            {
                Id = Guid.NewGuid(),
                CourseId = courseId.Value,
                MediaAssetId = asset.Id,
                SessionId = null, // bağımsız video
                OrderIndex = orderIndex,
                CustomTitle = videoTitle
            });

            await _context.SaveChangesAsync();

            return Ok(new { success = true, mediaAssetId = asset.Id });
        }
    }
}

public record AssignRecordingRequest(
    Guid? SessionId,
    Guid? CourseId,
    string? RecordingId,
    string PlaybackUrl,
    int DurationSeconds
);
