using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using MURO.Application.DTOs.Notifications;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Worker.Jobs;

public class NotificationProcessingJob : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<NotificationProcessingJob> _logger;
    private readonly IConfiguration _config;

    public NotificationProcessingJob(IServiceScopeFactory scopeFactory, ILogger<NotificationProcessingJob> logger, IConfiguration config)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
        _config = config;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("NotificationProcessingJob is running.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                using var scope = _scopeFactory.CreateScope();
                var jobQueue = scope.ServiceProvider.GetRequiredService<IJobQueue>();
                var db = scope.ServiceProvider.GetRequiredService<MuroDbContext>();
                var emailSender = scope.ServiceProvider.GetRequiredService<IEmailSender>();
                var smsSender = scope.ServiceProvider.GetRequiredService<ISmsSender>();
                var httpClientFactory = scope.ServiceProvider.GetRequiredService<IHttpClientFactory>();

                // Kuyruktan 5 saniyelik BRPOP ile bekle
                var payloadJson = await jobQueue.DequeueAsync("notifications", TimeSpan.FromSeconds(5));

                if (string.IsNullOrEmpty(payloadJson))
                {
                    await Task.Delay(1000, stoppingToken);
                    continue;
                }

                var payload = JsonSerializer.Deserialize<NotificationJobPayload>(payloadJson);
                if (payload == null || !payload.UserIds.Any()) continue;

                _logger.LogInformation("Processing {Count} notifications for Tenant {TenantId}", payload.UserIds.Count, payload.TenantId);

                // 1. Veritabanına Batch Insert (Bellek dostu)
                var notifications = new List<Notification>();
                foreach (var uid in payload.UserIds)
                {
                    notifications.Add(new Notification
                    {
                        Id = Guid.NewGuid(),
                        
                        UserId = uid,
                        Title = payload.Title,
                        Body = payload.Body,
                        Type = payload.Type,
                        Channel = Enum.TryParse<NotificationChannel>(payload.Channel, true, out var ch) ? ch : NotificationChannel.System
                    });
                }

                // Batching: 1000'erli kaydet
                var batchSize = 1000;
                for (int i = 0; i < notifications.Count; i += batchSize)
                {
                    var batch = notifications.Skip(i).Take(batchSize).ToList();
                    db.Notifications.AddRange(batch);
                    await db.SaveChangesAsync(stoppingToken);
                }

                // 2. Internal API üzerinden SignalR Push
                await TriggerSignalRAsync(httpClientFactory, payload, stoppingToken);

                // 3. Email ve SMS Gönderimi (Asenkron - paralel ama limitli)
                var users = await db.Users.AsNoTracking()
                    .Where(u => payload.UserIds.Contains(u.Id))
                    .Select(u => new { u.Email, u.Phone, u.FirstName, u.LastName })
                    .ToListAsync(stoppingToken);

                var htmlBody = $@"
                    <div style='font-family:sans-serif;max-width:600px;margin:auto'>
                      <h2 style='color:#4F46E5'>{payload.Title}</h2>
                      <p>{payload.Body}</p>
                      <hr style='border:none;border-top:1px solid #eee;margin-top:24px'/>
                      <p style='font-size:12px;color:#999'>MURO — Otomatik bildirim</p>
                    </div>";

                await Parallel.ForEachAsync(users, new ParallelOptions { MaxDegreeOfParallelism = 10, CancellationToken = stoppingToken }, async (user, ct) =>
                {
                    try
                    {
                        await emailSender.SendAsync(user.Email, $"{user.FirstName} {user.LastName}", payload.Title, htmlBody);
                        if (!string.IsNullOrWhiteSpace(user.Phone))
                            await smsSender.SendAsync(user.Phone, $"{payload.Title}: {payload.Body}");
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Kullanıcıya mail/sms gönderilemedi: {Email}", user.Email);
                    }
                });

                _logger.LogInformation("Successfully processed {Count} notifications.", payload.UserIds.Count);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Notification processing failed.");
                await Task.Delay(5000, stoppingToken);
            }
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
                _logger.LogWarning("SignalR push failed: {Status}", response.StatusCode);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "SignalR trigger error.");
        }
    }
}
