using Microsoft.EntityFrameworkCore;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Assignments;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class AssignmentService : IAssignmentService
{
    private readonly MuroDbContext _context;
    private readonly IGroupAccessService _groupAccess;
    private readonly ICacheService _cache;

    public AssignmentService(MuroDbContext context, IGroupAccessService groupAccess, ICacheService cache)
    {
        _context = context;
        _groupAccess = groupAccess;
        _cache = cache;
    }

    public async Task<PagedResult<AssignmentListDto>> GetAssignmentsAsync(int page, int pageSize, Guid? courseId)
    {
        var cacheKey = $"assignments:list:{page}:{pageSize}:{courseId}";
        return await _cache.GetOrSetAsync(cacheKey, async () =>
        {
            var query = _context.Assignments
                .AsNoTracking()
                .Where(a => true);

            if (courseId.HasValue)
                query = query.Where(a => a.CourseId == courseId);

            var totalCount = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

            var items = await query
                .OrderByDescending(a => a.DueDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Include(a => a.Course)
                .Select(a => new AssignmentListDto(
                    a.Id, a.Title, a.Description,
                    a.CourseId, a.Course.Title,
                    a.DueDate, a.Submissions.Count, a.CreatedAt,
                    a.MaxScore, a.FileUrl,
                    a.Submissions.Count(s => s.Score != null),
                    a.Submissions.Count(s => s.Score != null) > 0 ? a.Submissions.Where(s => s.Score != null).Average(s => s.Score) : null))
                .ToListAsync();

            return new PagedResult<AssignmentListDto>(items, totalCount, page, pageSize, totalPages);
        }, TimeSpan.FromMinutes(3));
    }

    public async Task<AssignmentDetailDto> GetAssignmentByIdAsync(Guid assignmentId)
    {
        var assignment = await _context.Assignments
            .AsNoTracking()
            .Where(a => a.Id == assignmentId )
            .Include(a => a.Course)
            .Include(a => a.Submissions).ThenInclude(s => s.User)
            .FirstOrDefaultAsync()
            ?? throw new KeyNotFoundException("Ödev bulunamadı.");

        return new AssignmentDetailDto(
            assignment.Id, assignment.Title, assignment.Description,
            assignment.CourseId, assignment.Course.Title,
            assignment.DueDate, assignment.FileUrl, assignment.MaxScore,
            assignment.CreatedAt,
            assignment.Submissions.Select(s => new SubmissionDto(
                s.Id, s.UserId, $"{s.User.FirstName} {s.User.LastName}",
                s.FileUrl, s.Comment, s.Score, s.Feedback, s.SubmittedAt)).ToList());
    }

    public async Task<AssignmentListDto> CreateAssignmentAsync(CreateAssignmentRequest request)
    {
        var courseExists = await _context.Courses.AnyAsync(c => c.Id == request.CourseId );
        if (!courseExists) throw new KeyNotFoundException("Ders bulunamadı.");

        var assignment = new Assignment
        {
            Id = Guid.NewGuid(),
            CourseId = request.CourseId,
            Title = request.Title,
            Description = request.Description,
            DueDate = request.DueDate,
            FileUrl = request.FileUrl,
            MaxScore = request.MaxScore
        };

        _context.Assignments.Add(assignment);
        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"assignments:");

        var courseName = await _context.Courses.Where(c => c.Id == request.CourseId).Select(c => c.Title).FirstAsync();
        return new AssignmentListDto(assignment.Id, assignment.Title, assignment.Description,
            assignment.CourseId, courseName, assignment.DueDate, 0, assignment.CreatedAt,
            assignment.MaxScore, assignment.FileUrl, 0, null);
    }

    public async Task<AssignmentListDto> UpdateAssignmentAsync(Guid assignmentId, UpdateAssignmentRequest request)
    {
        var assignment = await _context.Assignments
            .Include(a => a.Course)
            .Include(a => a.Submissions)
            .FirstOrDefaultAsync(a => a.Id == assignmentId )
            ?? throw new KeyNotFoundException("Ödev bulunamadı.");

        if (request.Title != null) assignment.Title = request.Title;
        if (request.Description != null) assignment.Description = request.Description;
        if (request.DueDate.HasValue) assignment.DueDate = request.DueDate.Value;
        if (request.FileUrl != null) assignment.FileUrl = request.FileUrl;
        if (request.MaxScore.HasValue) assignment.MaxScore = request.MaxScore.Value;

        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"assignments:");

        return new AssignmentListDto(assignment.Id, assignment.Title, assignment.Description,
            assignment.CourseId, assignment.Course.Title, assignment.DueDate,
            assignment.Submissions.Count, assignment.CreatedAt,
            assignment.MaxScore, assignment.FileUrl,
            assignment.Submissions.Count(s => s.Score != null),
            assignment.Submissions.Count(s => s.Score != null) > 0 ? assignment.Submissions.Where(s => s.Score != null).Average(s => s.Score) : null);
    }

    public async Task DeleteAssignmentAsync(Guid assignmentId)
    {
        var assignment = await _context.Assignments
            .FirstOrDefaultAsync(a => a.Id == assignmentId )
            ?? throw new KeyNotFoundException("Ödev bulunamadı.");

        _context.Assignments.Remove(assignment);
        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"assignments:");
    }

    // --- Submissions ---

    public async Task<SubmissionDto> SubmitAsync(Guid assignmentId, Guid userId, SubmitAssignmentRequest request)
    {
        var assignment = await _context.Assignments.FirstOrDefaultAsync(a => a.Id == assignmentId )
            ?? throw new KeyNotFoundException("Ödev bulunamadı.");

        if (assignment.DueDate < DateTime.UtcNow)
            throw new InvalidOperationException("Bu ödevin teslim süresi dolmuş.");

        var alreadySubmitted = await _context.AssignmentSubmissions
            .AnyAsync(s => s.AssignmentId == assignmentId && s.UserId == userId);
        if (alreadySubmitted) throw new InvalidOperationException("Bu ödev için zaten bir teslim yapılmış.");

        var submission = new AssignmentSubmission
        {
            Id = Guid.NewGuid(),
            AssignmentId = assignmentId,
            UserId = userId,
            FileUrl = request.FileUrl,
            Comment = request.Comment
        };

        _context.AssignmentSubmissions.Add(submission);
        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"assignments:");
        await _cache.RemoveAsync($"analytics:academichistory:{userId}");
        await _cache.RemoveAsync($"analytics:scorecard:{userId}");
        await _cache.RemoveAsync("analytics:scorecards_list");

        var user = await _context.Users.FindAsync(userId);
        return new SubmissionDto(submission.Id, userId, $"{user?.FirstName} {user?.LastName}",
            submission.FileUrl, submission.Comment, null, null, submission.SubmittedAt);
    }

    public async Task<SubmissionDto> GradeSubmissionAsync(Guid assignmentId, Guid submissionId, GradeSubmissionRequest request)
    {
        var submission = await _context.AssignmentSubmissions
            .Include(s => s.User)
            .FirstOrDefaultAsync(s => s.Id == submissionId && s.AssignmentId == assignmentId)
            ?? throw new KeyNotFoundException("Teslim bulunamadı.");

        submission.Score = request.Score;
        submission.Feedback = request.Feedback;
        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"assignments:");
        await _cache.RemoveAsync($"analytics:academichistory:{submission.UserId}");
        await _cache.RemoveAsync($"analytics:scorecard:{submission.UserId}");
        await _cache.RemoveAsync("analytics:scorecards_list");

        return new SubmissionDto(submission.Id, submission.UserId,
            $"{submission.User.FirstName} {submission.User.LastName}",
            submission.FileUrl, submission.Comment, submission.Score,
            submission.Feedback, submission.SubmittedAt);
    }

    // ── Öğrenci: Kendi ödevleri (sadece grubunun derslerine ait) ─────────────
    public async Task<List<MyAssignmentDto>> GetMyAssignmentsAsync(Guid userId)
    {
        // Grup filtreleme: kullanıcının erişebildiği kurs ID'leri
        var accessibleCourseIds = await _groupAccess.GetAccessibleCourseIdsAsync(userId);

        var assignments = await _context.Assignments.AsNoTracking()
            .Where(a => accessibleCourseIds.Contains(a.CourseId))
            .Include(a => a.Course)
            .Include(a => a.Submissions.Where(s => s.UserId == userId))
            .OrderByDescending(a => a.DueDate)
            .ToListAsync();

        var now = DateTime.UtcNow;
        return assignments.Select(a =>
        {
            var submission = a.Submissions.FirstOrDefault();
            string status;
            if (submission == null)
                status = a.DueDate < now ? "overdue" : "pending";
            else if (submission.Score.HasValue)
                status = "graded";
            else
                status = "submitted";

            return new MyAssignmentDto(
                a.Id, a.Title, a.Description,
                a.Course.Title, a.DueDate, a.MaxScore, a.FileUrl,
                submission?.Id,
                submission?.FileUrl, submission?.Comment,
                submission?.Score, submission?.Feedback, submission?.SubmittedAt,
                status);
        }).ToList();
    }
}
