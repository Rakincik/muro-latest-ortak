using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MURO.Application.Interfaces;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;
using MURO.Application.DTOs.Admin;

namespace MURO.Infrastructure.Services;

public class AdminSessionService : IAdminSessionService
{
    private readonly MuroDbContext _db;
    private readonly IBbbService _bbb;
    private readonly ILogger<AdminSessionService> _logger;
    private readonly IConfiguration _config;

    public AdminSessionService(MuroDbContext db, IBbbService bbb, ILogger<AdminSessionService> logger, IConfiguration config)
    {
        _db = db;
        _bbb = bbb;
        _logger = logger;
        _config = config;
    }

    private (int, object?) Ok(object? data = null) => (200, data);
    private (int, object?) NotFound(object? data = null) => (404, data);
    private (int, object?) BadRequest(object? data = null) => (400, data);
    private (int, object?) Conflict(object? data = null) => (409, data);

    // B) CANLI OTURUM Ä°ZLEME
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

    /// <summary>TÃ¼m aktif BBB oturumlarÄ±nÄ± listele</summary>
    public async Task<(int, object?)> GetActiveSessions()
    {
        var activeSessions = await _db.Sessions
            .AsNoTracking()
            .Include(s => s.Course)
            .Include(s => s.SessionAttendances)
            .Where(s => s.Status == SessionStatus.Live)
            .Select(s => new
            {
                s.Id,
                s.Title,
                CourseName = s.Course.Title,
                TenantName = "Monopol",
                TenantSlug = "monopol",
                s.BbbMeetingId,
                s.ScheduledStart,
                DurationMinutes = s.DurationMinutes ?? 0,
                ParticipantCount = s.SessionAttendances.Count(a => a.LeftAt == null),
                TotalJoined = s.SessionAttendances.Count(),
                s.RecordingEnabled,
                ElapsedMinutes = s.ScheduledStart.HasValue
                    ? (int)(DateTime.UtcNow - s.ScheduledStart.Value).TotalMinutes
                    : 0,
            })
            .OrderByDescending(s => s.ParticipantCount)
            .ToListAsync();

        // Ã–zet istatistikler
        var summary = new
        {
            totalActiveSessions = activeSessions.Count,
            totalParticipants = activeSessions.Sum(s => s.ParticipantCount),
            totalJoinedEver = activeSessions.Sum(s => s.TotalJoined),
            tenantsWithActiveSessions = activeSessions.Select(s => s.TenantName).Distinct().Count(),
        };

        return (200, new { summary, sessions = activeSessions });
    }

    /// <summary>BugÃ¼nÃ¼n oturum istatistikleri (tamamlanan + planlanan)</summary>
    public async Task<(int, object?)> GetTodaySessions()
    {
        var today = DateTime.UtcNow.Date;
        var tomorrow = today.AddDays(1);

        var sessions = await _db.Sessions
            .AsNoTracking()
            .Include(s => s.Course)
            .Where(s => s.ScheduledStart >= today && s.ScheduledStart < tomorrow)
            .Select(s => new
            {
                s.Id,
                s.Title,
                CourseName = s.Course.Title,
                TenantName = "Monopol",
                s.ScheduledStart,
                s.ScheduledEnd,
                s.DurationMinutes,
                Status = s.Status.ToString(),
                ParticipantCount = s.SessionAttendances.Count(),
            })
            .OrderBy(s => s.ScheduledStart)
            .ToListAsync();

        var stats = new
        {
            total = sessions.Count,
            live = sessions.Count(s => s.Status == "Live"),
            completed = sessions.Count(s => s.Status == "Ended"),
            scheduled = sessions.Count(s => s.Status == "Scheduled"),
            cancelled = sessions.Count(s => s.Status == "Cancelled"),
        };

        return (200, new { stats, sessions });
    }

    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // C) OTURUM DETAY + YÃ–NETÄ°M
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

    /// <summary>Oturum detayÄ± â€” BBB canlÄ± verisi + DB bilgisi</summary>
    public async Task<(int, object?)> GetSessionDetail(Guid id)
    {
        var session = await _db.Sessions
            .AsNoTracking()
            .Include(s => s.Course)
            .Include(s => s.SessionAttendances)
            .FirstOrDefaultAsync(s => s.Id == id);

        if (session == null) return (404, new { error = "Session not found" });

        // BBB'den canlÄ± veri Ã§ek
        BbbMeetingDetail? bbbInfo = null;
        if (!string.IsNullOrEmpty(session.BbbMeetingId) && session.Status == SessionStatus.Live)
        {
            bbbInfo = await _bbb.GetMeetingInfoAsync(session.BbbMeetingId);
        }

        return Ok(new
        {
            // DB verileri
            session.Id,
            session.Title,
            session.Description,
            CourseName = session.Course.Title,
            TenantName = "Monopol",
            TenantSlug = "monopol",
            session.BbbMeetingId,
            session.ScheduledStart,
            session.ScheduledEnd,
            session.DurationMinutes,
            Status = session.Status.ToString(),
            session.RecordingEnabled,
            session.CreatedAt,
            TotalAttendees = session.SessionAttendances.Count(),
            CurrentAttendees = session.SessionAttendances.Count(a => a.LeftAt == null),

            // BBB canlÄ± verileri
            Bbb = bbbInfo == null ? null : new
            {
                bbbInfo.IsRunning,
                bbbInfo.ParticipantCount,
                bbbInfo.ModeratorCount,
                bbbInfo.ListenerCount,
                bbbInfo.VideoCount,
                bbbInfo.VoiceParticipantCount,
                bbbInfo.IsRecording,
                bbbInfo.IsBreakout,
                bbbInfo.StartTime,
                bbbInfo.Duration,
                bbbInfo.MaxUsers,
                Participants = bbbInfo.Participants.Select(p => new
                {
                    p.FullName,
                    p.Role,
                    p.IsPresenter,
                    p.HasJoinedVoice,
                    p.HasVideo,
                    p.ClientType,
                }),
                BreakoutRooms = bbbInfo.BreakoutRooms.Select(br => new
                {
                    br.MeetingId,
                    br.Name,
                    br.ParticipantCount,
                }),
            },
        });
    }

    /// <summary>Oturumu zorla bitir</summary>
    public async Task<(int, object?)> ForceEndSession(Guid id)
    {
        var session = await _db.Sessions.FindAsync(id);
        if (session == null) return (404, new { error = "Session not found" });

        if (string.IsNullOrEmpty(session.BbbMeetingId))
            return (400, new { error = "No BBB meeting ID" });

        var ended = await _bbb.ForceEndMeetingAsync(session.BbbMeetingId);
        if (ended)
        {
            session.Status = SessionStatus.Ended;
            await _db.SaveChangesAsync();
            _logger.LogWarning("Session {SessionId} forcefully ended by admin", id);
        }

        return (200, new { success = ended, sessionId = id });
    }

    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    // F) KAYIT YÃ–NETÄ°MÄ° â€” Platform Geneli
    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

    /// <summary>TÃ¼m kayÄ±tlarÄ± listele (cross-tenant)</summary>
    public async Task<(int, object?)> GetRecordings(
        int page = 1,
        int pageSize = 20,
        string? status = null)
    {
        page = Math.Max(1, page);
        pageSize = Math.Clamp(pageSize, 5, 50);

        var query = _db.SessionRecordings.AsNoTracking()
            .Include(r => r.Session)
                .ThenInclude(s => s.Course)
            .Include(r => r.MediaAsset)
            .AsQueryable();

        if (!string.IsNullOrEmpty(status) && Enum.TryParse<MediaStatus>(status, out var statusEnum))
            query = query.Where(r => r.Status == statusEnum);



        var totalCount = await query.CountAsync();

        var recordings = await query
            .OrderByDescending(r => r.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(r => new
            {
                r.Id,
                r.SessionId,
                SessionTitle = r.Session.Title,
                CourseTitle = r.Session.Course.Title,
                TenantName = "Monopol",
                TenantSlug = "monopol",
                Status = r.Status.ToString(),
                PlaybackUrl = r.MediaAsset != null ? r.MediaAsset.FilePath : null,
                HlsPath = r.MediaAsset != null ? r.MediaAsset.HlsPath : null,
                DurationSeconds = r.MediaAsset != null ? (int?)r.MediaAsset.DurationSeconds : null,
                r.CreatedAt,
                ScheduledStart = r.Session.ScheduledStart,
            })
            .ToListAsync();

        // Ã–zet istatistikler
        var stats = new
        {
            total = totalCount,
            processing = await _db.SessionRecordings.CountAsync(r => r.Status == MediaStatus.Processing),
            ready = await _db.SessionRecordings.CountAsync(r => r.Status == MediaStatus.Ready),
            failed = await _db.SessionRecordings.CountAsync(r => r.Status == MediaStatus.Failed),
        };

        return Ok(new
        {
            items = recordings,
            totalCount,
            page,
            pageSize,
            totalPages = (int)Math.Ceiling((double)totalCount / pageSize),
            stats,
        });
    }

    // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
}
