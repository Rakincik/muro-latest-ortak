using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using MURO.Application.DTOs.Notifications;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Worker.Jobs;

public class ScheduledNotificationJob : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<ScheduledNotificationJob> _logger;
    private readonly IConfiguration _config;

    public ScheduledNotificationJob(
        IServiceScopeFactory scopeFactory,
        ILogger<ScheduledNotificationJob> logger,
        IConfiguration config)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
        _config = config;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("ScheduledNotificationJob is running.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await ProcessScheduledNotificationsAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while executing ScheduledNotificationJob.");
            }

            // Run every 60 seconds (1 minute check)
            await Task.Delay(TimeSpan.FromSeconds(60), stoppingToken);
        }
    }

    private async Task ProcessScheduledNotificationsAsync(CancellationToken stoppingToken)
    {
        using var scope = _scopeFactory.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<MuroDbContext>();
        var emailSender = scope.ServiceProvider.GetRequiredService<IEmailSender>();
        var smsSender = scope.ServiceProvider.GetRequiredService<ISmsSender>();
        var httpClientFactory = scope.ServiceProvider.GetRequiredService<IHttpClientFactory>();

        var now = DateTime.UtcNow;

        // Fetch unsent notifications that are due
        var pendingNotifications = await db.Notifications
            .Where(n => !n.IsSent && n.ScheduledAt != null && n.ScheduledAt <= now)
            .ToListAsync(stoppingToken);

        if (!pendingNotifications.Any()) return;

        _logger.LogInformation("Found {Count} pending scheduled notifications to send.", pendingNotifications.Count);

        // Group by title, body, type, channel to process them as bulks
        var groups = pendingNotifications
            .GroupBy(n => new { n.Title, n.Body, n.Type, n.Channel })
            .ToList();

        foreach (var group in groups)
        {
            var userIds = group.Select(n => n.UserId).ToList();
            var title = group.Key.Title;
            var body = group.Key.Body;
            var type = group.Key.Type;
            var channel = group.Key.Channel;

            _logger.LogInformation("Processing scheduled bulk notification: '{Title}' for {Count} users", title, userIds.Count);

            // 1. Mark as sent and update CreatedAt to current time so they appear fresh on student feeds
            foreach (var n in group)
            {
                n.IsSent = true;
                n.CreatedAt = now;
            }
            await db.SaveChangesAsync(stoppingToken);

            // 2. Trigger SignalR push
            var payload = new NotificationJobPayload
            {
                UserIds = userIds,
                Title = title,
                Body = body,
                Type = type,
                Channel = channel.ToString()
            };
            await TriggerSignalRAsync(httpClientFactory, payload, stoppingToken);

            // 3. Email and SMS Send (Async/Parallel)
            var users = await db.Users.AsNoTracking()
                .Where(u => userIds.Contains(u.Id))
                .Select(u => new { u.Email, u.Phone, u.FirstName, u.LastName })
                .ToListAsync(stoppingToken);

            var htmlBody = $@"
                <div style='font-family:sans-serif;max-width:600px;margin:auto'>
                  <h2 style='color:#4F46E5'>{title}</h2>
                  <p>{body}</p>
                  <hr style='border:none;border-top:1px solid #eee;margin-top:24px'/>
                  <p style='font-size:12px;color:#999'>MURO — Otomatik bildirim</p>
                </div>";

            await Parallel.ForEachAsync(users, new ParallelOptions { MaxDegreeOfParallelism = 10, CancellationToken = stoppingToken }, async (user, ct) =>
            {
                try
                {
                    await emailSender.SendAsync(user.Email, $"{user.FirstName} {user.LastName}", title, htmlBody);
                    if (!string.IsNullOrWhiteSpace(user.Phone))
                        await smsSender.SendAsync(user.Phone, $"{title}: {body}");
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to send mail/sms for scheduled notification: {Email}", user.Email);
                }
            });
        }
    }

    private async Task TriggerSignalRAsync(IHttpClientFactory factory, NotificationJobPayload payload, CancellationToken ct)
    {
        try
        {
            var internalApiUrl = _config["ApiBaseUrl"]?.TrimEnd('/');
            if (string.IsNullOrEmpty(internalApiUrl)) return;

            var secret = _config["WorkerSharedSecret"] ?? "dev-secret-key-muro";
            var url = $"{internalApiUrl}/api/internal/signalr/push?secret={secret}";

            var pushRequest = new
            {
                UserIds = payload.UserIds.Select(u => u.ToString()).ToList(),
                Notification = new NotificationDto(Guid.NewGuid(), payload.Title, payload.Body, payload.Type, false, payload.Channel, DateTime.UtcNow)
            };

            var client = factory.CreateClient();
            var content = new StringContent(JsonSerializer.Serialize(pushRequest), Encoding.UTF8, "application/json");
            
            var response = await client.PostAsync(url, content, ct);
            if (!response.IsSuccessStatusCode)
            {
                _logger.LogWarning("SignalR push failed for scheduled notification: {Status}", response.StatusCode);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "SignalR trigger error for scheduled notification.");
        }
    }
}
