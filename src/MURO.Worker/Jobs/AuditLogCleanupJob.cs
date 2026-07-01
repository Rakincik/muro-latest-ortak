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
        _logger.LogInformation("Checking for old logs to backup and clean up (older than 14 days)...");

        using var scope = _serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<MuroDbContext>();

        var thresholdDate = DateTime.UtcNow.AddDays(-14);

        // 1. AuditLogs Yedekleme
        var logsToBackup = await context.AuditLogs
            .AsNoTracking()
            .Where(a => a.CreatedAt < thresholdDate)
            .Select(a => new { a.Id, a.UserId, a.UserName, a.Action, a.EntityType, a.EntityId, a.EntityName, a.Details, a.IpAddress, a.CreatedAt })
            .ToListAsync(stoppingToken);

        if (logsToBackup.Any())
        {
            try
            {
                var backupDirectory = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "backups", "auditlogs");
                System.IO.Directory.CreateDirectory(backupDirectory);
                
                var fileName = $"audit_logs_backup_{DateTime.UtcNow:yyyyMMdd_HHmmss}.json";
                var filePath = System.IO.Path.Combine(backupDirectory, fileName);
                
                var json = System.Text.Json.JsonSerializer.Serialize(logsToBackup);
                await System.IO.File.WriteAllTextAsync(filePath, json, stoppingToken);
                
                _logger.LogInformation($"Saved {logsToBackup.Count} audit logs to backup file: {filePath}");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to write audit logs backup file.");
            }
        }

        // 2. SecurityEvents Yedekleme
        var securityToBackup = await context.SecurityEvents
            .AsNoTracking()
            .Where(s => s.CreatedAt < thresholdDate)
            .Select(s => new { s.Id, s.EventType, s.UserId, s.IpAddress, s.UserAgent, s.Details, s.CreatedAt })
            .ToListAsync(stoppingToken);

        if (securityToBackup.Any())
        {
            try
            {
                var backupDirectory = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "backups", "securityevents");
                System.IO.Directory.CreateDirectory(backupDirectory);
                
                var fileName = $"security_events_backup_{DateTime.UtcNow:yyyyMMdd_HHmmss}.json";
                var filePath = System.IO.Path.Combine(backupDirectory, fileName);
                
                var json = System.Text.Json.JsonSerializer.Serialize(securityToBackup);
                await System.IO.File.WriteAllTextAsync(filePath, json, stoppingToken);
                
                _logger.LogInformation($"Saved {securityToBackup.Count} security events to backup file: {filePath}");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to write security events backup file.");
            }
        }

        // 3. Veritabanından Silme
        var deletedAuditLogs = await context.AuditLogs
            .Where(a => a.CreatedAt < thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);
            
        var deletedSecurityEvents = await context.SecurityEvents
            .Where(s => s.CreatedAt < thresholdDate)
            .ExecuteDeleteAsync(stoppingToken);

        if (deletedAuditLogs > 0 || deletedSecurityEvents > 0)
        {
            _logger.LogInformation($"AuditLogCleanupJob deleted {deletedAuditLogs} audit logs and {deletedSecurityEvents} security events older than 14 days.");
        }
        else
        {
            _logger.LogInformation("AuditLogCleanupJob found no old logs to delete.");
        }
    }
}
