using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;

namespace MURO.Worker.Jobs;

public class AuditLogCleanupJob : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<AuditLogCleanupJob> _logger;

    public AuditLogCleanupJob(IServiceProvider serviceProvider, ILogger<AuditLogCleanupJob> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("AuditLogCleanupJob is starting.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await ProcessCleanupAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while executing AuditLogCleanupJob.");
            }

            // Günde bir kez (24 saatte bir) çalıştırıyoruz
            await Task.Delay(TimeSpan.FromHours(24), stoppingToken);
        }
    }

    private async Task ProcessCleanupAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Checking for old logs to clean up (older than 30 days)...");

        using var scope = _serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<MuroDbContext>();

        var thresholdDate = DateTime.UtcNow.AddDays(-30);

        // Eski AuditLogs kayıtlarını sil (EF Core 7.0+ ExecuteDeleteAsync ile çok hızlı ve memory dostu)
        var deletedAuditLogs = await context.AuditLogs
            .Where(a => a.CreatedAt < thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
            
        // Eski SecurityEvents kayıtlarını sil
        var deletedSecurityEvents = await context.SecurityEvents
            .Where(s => s.CreatedAt < thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);

        if (deletedAuditLogs > 0 || deletedSecurityEvents > 0)
        {
            _logger.LogInformation($"AuditLogCleanupJob deleted {deletedAuditLogs} audit logs and {deletedSecurityEvents} security events older than 30 days.");
        }
        else
        {
            _logger.LogInformation("AuditLogCleanupJob found no old logs to delete.");
        }
    }
}
