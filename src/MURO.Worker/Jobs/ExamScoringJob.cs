using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;
using MURO.Domain.Entities;
using MURO.Application.Interfaces;

namespace MURO.Worker.Jobs;

public class ExamScoringJob : BackgroundService
{
    private readonly IServiceProvider _services;
    private readonly ILogger<ExamScoringJob> _logger;

    public ExamScoringJob(IServiceProvider services, ILogger<ExamScoringJob> logger)
    {
        _services = services;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("ExamScoringJob started.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await ProcessQueueAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred executing ExamScoringJob.");
            }

            await Task.Delay(TimeSpan.FromSeconds(5), stoppingToken);
        }
    }

    private async Task ProcessQueueAsync(CancellationToken cancellationToken)
    {
        using var scope = _services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<MuroDbContext>();
        var cache = scope.ServiceProvider.GetRequiredService<ICacheService>();

        // Latch onto pending items
        var pendingItems = await db.ExamSubmissionQueues
            .Include(q => q.Exam)
            .Where(q => q.Status == "Pending")
            .OrderBy(q => q.SubmittedAt)
            .Take(500)
            .ToListAsync(cancellationToken);

        if (!pendingItems.Any())
            return;

        _logger.LogInformation($"Processing {pendingItems.Count} pending exam submissions.");

        var resultsToAdd = new System.Collections.Concurrent.ConcurrentBag<ExamResult>();
        var queuesToRemove = new System.Collections.Concurrent.ConcurrentBag<ExamSubmissionQueue>();
        var cacheKeysToRemove = new System.Collections.Concurrent.ConcurrentDictionary<string, byte>();

        Parallel.ForEach(pendingItems, new ParallelOptions { MaxDegreeOfParallelism = Environment.ProcessorCount }, item =>
        {
            try
            {
                var exam = item.Exam;
                if (exam == null)
                {
                    item.Status = "Failed";
                    item.ErrorMessage = "Exam not found";
                    return;
                }

                var answers = JsonSerializer.Deserialize<Dictionary<int, string>>(item.AnswersJson) ?? new();
                var answerKey = string.IsNullOrEmpty(exam.AnswerKeyJson)
                    ? new Dictionary<int, string>()
                    : JsonSerializer.Deserialize<Dictionary<int, string>>(exam.AnswerKeyJson) ?? new();

                var weights = string.IsNullOrEmpty(exam.QuestionWeightsJson)
                    ? null
                    : JsonSerializer.Deserialize<Dictionary<int, double>>(exam.QuestionWeightsJson);

                int correct = 0, wrong = 0, empty = 0;
                double weightedCorrect = 0, weightedWrong = 0, totalWeight = 0;

                for (int i = 1; i <= exam.QuestionCount; i++)
                {
                    var w = weights != null && weights.TryGetValue(i, out var qw) ? qw : 1.0;
                    totalWeight += w;

                    if (!answers.TryGetValue(i, out var studentAnswer) || string.IsNullOrEmpty(studentAnswer))
                    {
                        empty++;
                    }
                    else if (answerKey.TryGetValue(i, out var correctAnswer) && studentAnswer.Trim().Equals(correctAnswer.Trim(), StringComparison.OrdinalIgnoreCase))
                    {
                        correct++;
                        weightedCorrect += w;
                    }
                    else
                    {
                        wrong++;
                        weightedWrong += w;
                    }
                }

                var net = Math.Round(weightedCorrect - (weightedWrong * exam.WrongPenaltyWeight), 2);
                var maxRawPoints = exam.MaxScore - exam.BaseScore;
                var rawScore = totalWeight > 0 ? (net / totalWeight) * maxRawPoints : 0;
                var score = Math.Round(rawScore + exam.BaseScore, 3);
                if (score < exam.BaseScore && net <= 0) score = exam.BaseScore;

                var result = new ExamResult
                {
                    Id = Guid.NewGuid(),
                    ExamId = item.ExamId,
                    UserId = item.UserId,
                    Answers = item.AnswersJson,
                    CorrectCount = correct,
                    WrongCount = wrong,
                    EmptyCount = empty,
                    Score = score,
                    StartedAt = null,
                    SubmittedAt = item.SubmittedAt
                };

                resultsToAdd.Add(result);
                item.Status = "Processed";
                queuesToRemove.Add(item);
                cacheKeysToRemove.TryAdd($"exams:", 1);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Failed to process submission {item.Id}");
                item.Status = "Failed";
                item.ErrorMessage = ex.Message;
            }
        });

        // ── Bulk Insert & Delete ──
        if (resultsToAdd.Any())
        {
            db.ExamResults.AddRange(resultsToAdd);
            db.ExamSubmissionQueues.RemoveRange(queuesToRemove);
            
            foreach (var key in cacheKeysToRemove.Keys)
            {
                await cache.RemoveByPrefixAsync(key);
            }
        }

        await db.SaveChangesAsync(cancellationToken);
    }
}
