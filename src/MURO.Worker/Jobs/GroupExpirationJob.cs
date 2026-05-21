using Microsoft.EntityFrameworkCore;
using MURO.Infrastructure.Persistence;
using MURO.Domain.Enums;

namespace MURO.Worker.Jobs;

public class GroupExpirationJob : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<GroupExpirationJob> _logger;

    public GroupExpirationJob(IServiceProvider serviceProvider, ILogger<GroupExpirationJob> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("GroupExpirationJob is starting.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await ProcessExpiredGroupsAsync(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while executing GroupExpirationJob.");
            }

            // Saat başı çalıştırıyoruz
            await Task.Delay(TimeSpan.FromHours(1), stoppingToken);
        }
    }

    private async Task ProcessExpiredGroupsAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Checking for expired groups...");

        using var scope = _serviceProvider.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<MuroDbContext>();

        var now = DateTime.UtcNow;

        // Süresi dolmuş gruplardaki aktif (hala "Passive" yapılmamış) öğrencileri bul
        var expiredGroups = await context.Groups
            .Include(g => g.Members)
            .Where(g => g.ExpirationDate != null && g.ExpirationDate <= now)
            .ToListAsync(stoppingToken);

        if (!expiredGroups.Any())
        {
            return;
        }

        // Bu gruplardaki tüm öğrencilerin ID'lerini topla
        var expiredUserIds = expiredGroups
            .SelectMany(g => g.Members.Where(m => m.Status == "active").Select(m => m.UserId))
            .Distinct()
            .ToList();

        if (!expiredUserIds.Any())
        {
            return;
        }

        // Bu öğrencilerin GÜNCEL OLARAK üye olduğu ve süresi DOLMAMIŞ başka bir aktif grubu var mı?
        var usersInActiveGroups = await context.GroupMembers
            .Include(gm => gm.Group)
            .Where(gm => expiredUserIds.Contains(gm.UserId) && gm.Status == "active")
            .Where(gm => gm.Group.ExpirationDate == null || gm.Group.ExpirationDate > now)
            .Select(gm => gm.UserId)
            .Distinct()
            .ToListAsync(stoppingToken);

        // Aktif grubu olmayanları bul
        var usersToPassivate = expiredUserIds.Except(usersInActiveGroups).ToList();

        if (usersToPassivate.Any())
        {
            _logger.LogInformation($"Found {usersToPassivate.Count} users to passivate.");

            var users = await context.Users
                .Where(u => usersToPassivate.Contains(u.Id))
                .ToListAsync(stoppingToken);

            foreach (var user in users)
            {
                user.StudentType = StudentType.Passive;
                user.IsActive = false;
                _logger.LogInformation($"User {user.Id} passivated.");
            }

            await context.SaveChangesAsync(stoppingToken);
            _logger.LogInformation("Passivation complete.");
        }
    }
}
