using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;

namespace MURO.Worker.Jobs;

public class SoftDeleteCleanupJob : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<SoftDeleteCleanupJob> _logger;

    public SoftDeleteCleanupJob(IServiceProvider serviceProvider, ILogger<SoftDeleteCleanupJob> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("SoftDeleteCleanupJob is starting.");

        // Run immediately on startup, then every 24 hours
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await CleanupOldSoftDeletedRecordsAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while executing SoftDeleteCleanupJob.");
            }

            // Wait 24 hours before next run
            await Task.Delay(TimeSpan.FromHours(24), stoppingToken);
        }
    }

    private async Task CleanupOldSoftDeletedRecordsAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Starting cleanup of 3-month-old soft-deleted records...");

        using var scope = _serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<MuroDbContext>();

        var thresholdDate = DateTime.UtcNow.AddMonths(-3);
        int totalDeleted = 0;

        // --- Bulk Deletes for each SoftDeletable Entity ---
        // EF Core 7+ ExecuteDeleteAsync is super fast and does not load entities into memory.

        int examsDeleted = await context.Exams
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += examsDeleted;

        int coursesDeleted = await context.Courses
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += coursesDeleted;

        int usersDeleted = await context.Users
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += usersDeleted;

        int tenantsDeleted = await context.Tenants
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += tenantsDeleted;

        int groupsDeleted = await context.Groups
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += groupsDeleted;

        int sessionsDeleted = await context.Sessions
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += sessionsDeleted;

        int assignmentsDeleted = await context.Assignments
            .IgnoreQueryFilters()
            .Where(x => x.IsDeleted && x.DeletedAt <= thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
        totalDeleted += assignmentsDeleted;

        _logger.LogInformation($"Cleanup finished. Hard deleted a total of {totalDeleted} old records.");
    }
}
