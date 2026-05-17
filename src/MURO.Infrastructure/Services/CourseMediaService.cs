using Microsoft.EntityFrameworkCore;
using MURO.Application.DTOs.Media;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class CourseMediaService : ICourseMediaService
{
    private readonly MuroDbContext _context;
    private readonly ICacheService _cache;

    public CourseMediaService(MuroDbContext context, ICacheService cache)
    {
        _context = context;
        _cache = cache;
    }

    public async Task<List<CourseMediaDto>> GetCourseMediasAsync(Guid tenantId, Guid courseId)
    {
        // CourseMedias only fetch actual assigned videos from the media library.
        // Live session recordings (SessionRecordings) remain purely within the Session hierarchy
        // and are NOT auto-synced into CourseMedia.

        // 2. Fetch all CourseMedias (which now includes both educational videos, and exams)
        var courseMedias = await _context.CourseMedias
            .Include(cm => cm.MediaAsset)
            .Include(cm => cm.Exam)
            .Include(cm => cm.Session)
            .Where(cm => cm.CourseId == courseId && cm.Course.TenantId == tenantId)
            .OrderBy(cm => cm.OrderIndex)
            .Select(cm => new CourseMediaDto(
                cm.Id,
                cm.CourseId,
                cm.MediaAssetId,
                cm.OrderIndex,
                cm.MediaAsset != null ? new MediaAssetDto(
                    cm.MediaAsset.Id,
                    cm.MediaAsset.Title,
                    cm.MediaAsset.FilePath,
                    cm.MediaAsset.HlsPath,
                    cm.MediaAsset.ThumbnailPath,
                    cm.MediaAsset.DurationSeconds,
                    cm.MediaAsset.Status.ToString(),
                    cm.CourseId,
                    cm.Course.Title,
                    cm.MediaAsset.FolderId,
                    cm.MediaAsset.CreatedAt
                ) : null,
                cm.ExamId,
                cm.Exam != null ? cm.Exam.Title : null,
                cm.SessionId,
                cm.Session != null ? cm.Session.Title : null,
                cm.SessionId != null ? "Session" : (cm.ExamId != null ? "Exam" : "Media")
            ))
            .ToListAsync();

        return courseMedias;
    }

    public async Task<CourseMediaDto> AssignMediaAsync(Guid tenantId, Guid courseId, AssignMediaToCourseRequest request)
    {
        // Verify media belongs to tenant
        var media = await _context.MediaAssets.FirstOrDefaultAsync(m => m.Id == request.MediaAssetId && m.TenantId == tenantId);
        if (media == null) throw new Exception("Media not found");

        // Verify course belongs to tenant
        var course = await _context.Courses.FirstOrDefaultAsync(c => c.Id == courseId && c.TenantId == tenantId);
        if (course == null) throw new Exception("Course not found");

        // Prevent duplicates
        var exists = await _context.CourseMedias.AnyAsync(cm => cm.CourseId == courseId && cm.MediaAssetId == request.MediaAssetId);
        if (exists) throw new Exception("Media already assigned to this course");

        // Get max order index
        var maxOrder = await _context.CourseMedias
            .Where(cm => cm.CourseId == courseId)
            .MaxAsync(cm => (int?)cm.OrderIndex) ?? -1;

        var courseMedia = new CourseMedia
        {
            CourseId = courseId,
            MediaAssetId = request.MediaAssetId,
            OrderIndex = maxOrder + 1
        };

        _context.CourseMedias.Add(courseMedia);
        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"{tenantId}:courses:");

        return new CourseMediaDto(
            courseMedia.Id,
            courseMedia.CourseId,
            courseMedia.MediaAssetId,
            courseMedia.OrderIndex,
            new MediaAssetDto(
                media.Id, media.Title, media.FilePath, media.HlsPath, media.ThumbnailPath, 
                media.DurationSeconds, media.Status.ToString(), courseId, course.Title, media.FolderId, media.CreatedAt
            ),
            null, null, null, null, "Media"
        );
    }

    public async Task<CourseMediaDto> AssignExamAsync(Guid tenantId, Guid courseId, AssignExamToCourseRequest request)
    {
        var exam = await _context.Exams.FirstOrDefaultAsync(e => e.Id == request.ExamId && e.TenantId == tenantId);
        if (exam == null) throw new Exception("Exam not found");

        var course = await _context.Courses.FirstOrDefaultAsync(c => c.Id == courseId && c.TenantId == tenantId);
        if (course == null) throw new Exception("Course not found");

        var exists = await _context.CourseMedias.AnyAsync(cm => cm.CourseId == courseId && cm.ExamId == request.ExamId);
        if (exists) throw new Exception("Exam already assigned to this course");

        var maxOrder = await _context.CourseMedias
            .Where(cm => cm.CourseId == courseId)
            .MaxAsync(cm => (int?)cm.OrderIndex) ?? -1;

        var courseMedia = new CourseMedia
        {
            CourseId = courseId,
            ExamId = request.ExamId,
            OrderIndex = maxOrder + 1
        };

        _context.CourseMedias.Add(courseMedia);
        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"{tenantId}:courses:");

        return new CourseMediaDto(
            courseMedia.Id,
            courseMedia.CourseId,
            null,
            courseMedia.OrderIndex,
            null,
            exam.Id,
            exam.Title,
            null,
            null,
            "Exam"
        );
    }

    public async Task BulkAssignFolderAsync(Guid tenantId, Guid courseId, BulkAssignFolderToCourseRequest request)
    {
        // Verify folder and course
        var course = await _context.Courses.FirstOrDefaultAsync(c => c.Id == courseId && c.TenantId == tenantId);
        if (course == null) throw new Exception("Course not found");

        var folder = await _context.MediaFolders.FirstOrDefaultAsync(f => f.Id == request.FolderId && f.TenantId == tenantId);
        if (folder == null) throw new Exception("Folder not found");

        var assets = await _context.MediaAssets
            .Where(ma => ma.FolderId == request.FolderId && ma.TenantId == tenantId)
            .OrderBy(ma => ma.Title)
            .ToListAsync();

        var maxOrder = await _context.CourseMedias
            .Where(cm => cm.CourseId == courseId)
            .MaxAsync(cm => (int?)cm.OrderIndex) ?? -1;

        foreach (var asset in assets)
        {
            var exists = await _context.CourseMedias.AnyAsync(cm => cm.CourseId == courseId && cm.MediaAssetId == asset.Id);
            if (!exists)
            {
                maxOrder++;
                _context.CourseMedias.Add(new CourseMedia
                {
                    CourseId = courseId,
                    MediaAssetId = asset.Id,
                    OrderIndex = maxOrder
                });
            }
        }

        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"{tenantId}:courses:");
    }

    public async Task RemoveMediaAsync(Guid tenantId, Guid courseId, Guid mediaAssetId)
    {
        var courseMedia = await _context.CourseMedias
            .FirstOrDefaultAsync(cm => cm.CourseId == courseId && cm.MediaAssetId == mediaAssetId && cm.Course.TenantId == tenantId);

        if (courseMedia != null)
        {
            _context.CourseMedias.Remove(courseMedia);
            await _context.SaveChangesAsync();
            await _cache.RemoveByPrefixAsync($"{tenantId}:courses:");
        }
    }

    public async Task RemoveItemAsync(Guid tenantId, Guid courseId, Guid courseMediaId)
    {
        var courseMedia = await _context.CourseMedias
            .FirstOrDefaultAsync(cm => cm.CourseId == courseId && cm.Id == courseMediaId && cm.Course.TenantId == tenantId);

        if (courseMedia != null)
        {
            _context.CourseMedias.Remove(courseMedia);
            await _context.SaveChangesAsync();
            await _cache.RemoveByPrefixAsync($"{tenantId}:courses:");
        }
    }

    public async Task ReorderMediasAsync(Guid tenantId, Guid courseId, ReorderCourseMediaRequest request)
    {
        var courseMedias = await _context.CourseMedias
            .Where(cm => cm.CourseId == courseId && cm.Course.TenantId == tenantId)
            .ToListAsync();

        for (int i = 0; i < request.CourseMediaIds.Count; i++)
        {
            var media = courseMedias.FirstOrDefault(cm => cm.Id == request.CourseMediaIds[i]);
            if (media != null)
            {
                media.OrderIndex = i;
            }
        }

        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"{tenantId}:courses:");
    }
}
