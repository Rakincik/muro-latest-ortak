using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using MURO.Application.DTOs;
using MURO.Application.DTOs.Exams;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class ExamResultService : IExamResultService
{
    private readonly MuroDbContext _context;
    private readonly ICacheService _cache;

    public ExamResultService(MuroDbContext context, ICacheService cache)
    {
        _context = context;
        _cache = cache;
    }

    public async Task<ExamResultSummaryDto> GetExamResultsAsync(Guid examId)
    {
        var cacheKey = $"exams:{examId}:results";
        return await _cache.GetOrSetAsync(cacheKey, async () =>
        {
            var exam = await _context.Exams
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == examId )
                ?? throw new KeyNotFoundException("Sınav bulunamadı.");

            var query = _context.ExamResults.AsNoTracking().Where(r => r.ExamId == examId);

            var totalCount = await query.CountAsync();
            if (totalCount == 0)
            {
                return new ExamResultSummaryDto(0, 0, 0, 0, 0, new List<ExamResultDto>(), new List<ScoreRangeDto>());
            }

            var avgScore = Math.Round(await query.AverageAsync(r => r.Score), 1);
            var maxScore = Math.Round(await query.MaxAsync(r => r.Score), 1);
            var minScore = Math.Round(await query.MinAsync(r => r.Score), 1);
            
            // Net is calculated dynamically in SQL
            var penalty = exam.WrongPenaltyWeight;
            var avgNet = Math.Round(await query.AverageAsync(r => r.CorrectCount - (r.WrongCount * penalty)), 2);

            var rawResults = await query
                .Include(r => r.User)
                .OrderByDescending(r => r.Score)
                .ToListAsync();

            var results = rawResults.Select(r => new ExamResultDto(
                r.Id, r.UserId,
                r.User?.FirstName + " " + r.User?.LastName,
                r.CorrectCount, r.WrongCount, r.EmptyCount,
                Math.Round(r.CorrectCount - (r.WrongCount * penalty), 2),
                r.Score,
                r.SubmittedAt,
                r.StartedAt,
                r.StartedAt.HasValue ? (int)(r.SubmittedAt - r.StartedAt.Value).TotalSeconds : null,
                CalculateSectionResults(r.Answers, exam.AnswerKeyJson, exam.SectionsJson, penalty, exam.QuestionWeightsJson),
                false,
                !string.IsNullOrEmpty(r.Answers) ? JsonSerializer.Deserialize<Dictionary<int, string>>(r.Answers) : null
            )).ToList();

            var ranges = new[] { "0-20", "20-40", "40-60", "60-80", "80-100" };
            var scoreDistribution = ranges.Select((range, i) =>
            {
                var lo = i * 20;
                var hi = (i + 1) * 20;
                var count = rawResults.Count(s => s.Score >= lo && (i == 4 ? s.Score <= hi : s.Score < hi));
                return new ScoreRangeDto(range, count);
            }).ToList();

            var answerKey = !string.IsNullOrEmpty(exam.AnswerKeyJson)
                ? JsonSerializer.Deserialize<Dictionary<int, string>>(exam.AnswerKeyJson)
                : null;

            return new ExamResultSummaryDto(
                totalCount,
                avgScore,
                avgNet,
                maxScore,
                minScore,
                results,
                scoreDistribution,
                answerKey
            );
        }, TimeSpan.FromMinutes(10));
    }

    public async Task<ExamOverallSummaryDto> GetOverallSummaryAsync()
    {
        var cacheKey = $"exams:overallsummary";
        return await _cache.GetOrSetAsync(cacheKey, async () =>
        {
            var examsWithResults = await _context.Exams.AsNoTracking()
                .Where(e => e.Results.Any())
                .Select(e => new
                {
                    e.ExamType,
                    ResultCount = e.Results.Count,
                    AvgScore = e.Results.Average(r => r.Score)
                })
                .ToListAsync();

            var totalParticipants = examsWithResults.Sum(e => e.ResultCount);
            var overallAvg = examsWithResults.Any()
                ? Math.Round(examsWithResults.Average(e => e.AvgScore), 1) : 0;
            var examTypes = examsWithResults.Select(e => e.ExamType).Distinct().Count();

            return new ExamOverallSummaryDto(
                examsWithResults.Count, totalParticipants, overallAvg, examTypes);
        }, TimeSpan.FromMinutes(3));
    }

    public async Task<ExamResultDto> SubmitAnswersAsync(Guid examId, Guid userId, SubmitExamAnswersRequest request)
    {
        var exam = await _context.Exams
            .FirstOrDefaultAsync(e => e.Id == examId )
            ?? throw new KeyNotFoundException("Sınav bulunamadı.");

        if (exam.Status != "Published")
            throw new InvalidOperationException("Bu sınav aktif değil.");

        if (await _context.ExamResults.AnyAsync(r => r.ExamId == examId && r.UserId == userId))
            throw new InvalidOperationException("Bu sınava daha önce katıldınız.");

        // --- QUEUE BASED SUBMISSION ---
        var queueItem = new ExamSubmissionQueue
        {
            Id = Guid.NewGuid(),
            ExamId = examId,
            UserId = userId,
            AnswersJson = JsonSerializer.Serialize(request.Answers),
            Status = "Pending",
            SubmittedAt = DateTime.UtcNow
        };
        _context.ExamSubmissionQueues.Add(queueItem);

        // Taslak varsa sil (Gönderildiği için taslağa gerek kalmadı)
        var draft = await _context.StudentExamDrafts.FirstOrDefaultAsync(d => d.ExamId == examId && d.UserId == userId);
        if (draft != null)
        {
            _context.StudentExamDrafts.Remove(draft);
        }

        await _context.SaveChangesAsync();
        await _cache.RemoveByPrefixAsync($"exams:");
        await _cache.RemoveAsync($"analytics:academichistory:{userId}");
        await _cache.RemoveAsync($"analytics:scorecard:{userId}");
        await _cache.RemoveAsync("analytics:scorecards_list");

        var user = await _context.Users.FindAsync(userId);
        var fullName = user != null ? $"{user.FirstName} {user.LastName}" : "—";

        // Geriye 'Hesaplanıyor' durumunda bir DTO dönüyoruz
        return new ExamResultDto(Guid.Empty, userId, fullName,
            0, 0, 0, 0, 0, queueItem.SubmittedAt, request.StartedAt, null, null, true);
    }

    public async Task SaveDraftAsync(Guid examId, Guid userId, Dictionary<int, string> answers)
    {
        var draft = await _context.StudentExamDrafts
            .FirstOrDefaultAsync(d => d.ExamId == examId && d.UserId == userId);

        if (draft == null)
        {
            draft = new StudentExamDraft
            {
                Id = Guid.NewGuid(),
                ExamId = examId,
                UserId = userId,
                AnswersJson = JsonSerializer.Serialize(answers),
                LastUpdatedAt = DateTime.UtcNow
            };
            _context.StudentExamDrafts.Add(draft);
        }
        else
        {
            draft.AnswersJson = JsonSerializer.Serialize(answers);
            draft.LastUpdatedAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();
    }

    public async Task<Dictionary<int, string>?> GetDraftAsync(Guid examId, Guid userId)
    {
        var draft = await _context.StudentExamDrafts
            .AsNoTracking()
            .FirstOrDefaultAsync(d => d.ExamId == examId && d.UserId == userId);

        if (draft == null || string.IsNullOrEmpty(draft.AnswersJson))
            return null;

        try
        {
            return JsonSerializer.Deserialize<Dictionary<int, string>>(draft.AnswersJson);
        }
        catch
        {
            return null;
        }
    }

    public async Task<List<MyExamResultDto>> GetMyExamResultsAsync(Guid userId)
    {
        var myResults = await _context.ExamResults.AsNoTracking()
            .Where(r => r.UserId == userId )
            .Include(r => r.Exam)
            .OrderByDescending(r => r.SubmittedAt)
            .ToListAsync();

        var list = new List<MyExamResultDto>();
        foreach (var r in myResults)
        {
            // Sınıf ortalaması ve sıralama (showResults flag'i aktifse)
            double? avgScore = null;
            int? rank = null;
            if (r.Exam.ShowResults)
            {
                var allScores = await _context.ExamResults.AsNoTracking()
                    .Where(x => x.ExamId == r.ExamId)
                    .Select(x => x.Score)
                    .ToListAsync();
                if (allScores.Any())
                {
                    avgScore = Math.Round(allScores.Average(), 1);
                    var sorted = allScores.OrderByDescending(s => s).ToList();
                    rank = sorted.IndexOf(r.Score) + 1;
                }
            }

            // Net: entity'de saklanmıyor, anlık hesaplanıyor
            var net = Math.Round(r.CorrectCount - (r.WrongCount * r.Exam.WrongPenaltyWeight), 2);

            var sectionResults = CalculateSectionResults(r.Answers, r.Exam.AnswerKeyJson, r.Exam.SectionsJson, r.Exam.WrongPenaltyWeight, r.Exam.QuestionWeightsJson);

            list.Add(new MyExamResultDto(
                r.ExamId, r.Exam.Title, r.Exam.ExamType.ToString(),
                r.Exam.QuestionCount, r.CorrectCount, r.WrongCount, r.EmptyCount,
                net, r.Score, avgScore, rank, r.SubmittedAt, r.Exam.ShowResults, sectionResults));
        }
        return list;
    }

    private class ExamSectionModel
    {
        public string name { get; set; } = string.Empty;
        public int start { get; set; }
        public int end { get; set; }
    }

    private Dictionary<string, SectionResultDto>? CalculateSectionResults(string? answersJson, string? answerKeyJson, string? sectionsJson, double penalty, string? weightsJson)
    {
        if (string.IsNullOrEmpty(answersJson) || string.IsNullOrEmpty(answerKeyJson) || string.IsNullOrEmpty(sectionsJson))
            return null;

        try
        {
            var answers = JsonSerializer.Deserialize<Dictionary<int, string>>(answersJson);
            var key = JsonSerializer.Deserialize<Dictionary<int, string>>(answerKeyJson);
            var sections = JsonSerializer.Deserialize<List<ExamSectionModel>>(sectionsJson, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            
            if (answers == null || key == null || sections == null || !sections.Any()) return null;

            var result = new Dictionary<string, SectionResultDto>();

            foreach (var sec in sections)
            {
                int correct = 0, wrong = 0, empty = 0;
                for (int i = sec.start; i <= sec.end; i++)
                {
                    if (!answers.TryGetValue(i, out var studentAns) || string.IsNullOrEmpty(studentAns))
                    {
                        empty++;
                    }
                    else if (key.TryGetValue(i, out var correctAns) && studentAns.Trim().Equals(correctAns.Trim(), StringComparison.OrdinalIgnoreCase))
                    {
                        correct++;
                    }
                    else
                    {
                        wrong++;
                    }
                }

                double net = Math.Round(correct - (wrong * penalty), 2);
                result[sec.name] = new SectionResultDto(sec.name, correct, wrong, empty, net);
            }

            return result;
        }
        catch
        {
            return null;
        }
    }
}
