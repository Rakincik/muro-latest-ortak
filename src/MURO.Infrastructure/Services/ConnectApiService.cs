using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using MURO.Application.DTOs.Connect;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class ConnectApiService : IConnectApiService
{
    private readonly MuroDbContext _context;
    private readonly ICacheService _cache;
    private readonly ISmsSender _smsSender;
    private readonly IConfiguration _config;
    private readonly ILogger<ConnectApiService> _logger;

    public ConnectApiService(
        MuroDbContext context,
        ICacheService cache,
        ISmsSender smsSender,
        IConfiguration config,
        ILogger<ConnectApiService> logger)
    {
        _context = context;
        _cache = cache;
        _smsSender = smsSender;
        _config = config;
        _logger = logger;
    }

    private static string HashKey(string rawKey)
    {
        using var sha256 = SHA256.Create();
        var bytes = Encoding.UTF8.GetBytes(rawKey.Trim());
        var hashBytes = sha256.ComputeHash(bytes);
        return Convert.ToHexString(hashBytes).ToLowerInvariant();
    }

    private static string NormalizePhone(string phone)
    {
        if (string.IsNullOrWhiteSpace(phone)) return string.Empty;
        var digits = Regex.Replace(phone, @"\D", "");
        if (digits.StartsWith("90") && digits.Length == 12) return digits.Substring(2);
        if (digits.StartsWith("0") && digits.Length == 11) return digits.Substring(1);
        return digits;
    }

    private static string GenerateRandomHex(int bytesCount)
    {
        var bytes = new byte[bytesCount];
        RandomNumberGenerator.Fill(bytes);
        return Convert.ToHexString(bytes).ToLowerInvariant();
    }

    private string GetPortalBaseUrl()
    {
        return _config["App:StudentUrl"] ?? _config["App:AdminUrl"] ?? "https://uzem.ataniyorumhocam.com";
    }

    public async Task<string> GenerateMagicLoginUrlAsync(Guid tenantId, Guid userId, CancellationToken ct = default)
    {
        var token = $"magic_{Guid.NewGuid():N}{GenerateRandomHex(16)}";
        var cacheKey = $"muro:magic:{token}";
        await _cache.SetAsync(cacheKey, userId.ToString(), TimeSpan.FromMinutes(15));

        var baseUrl = GetPortalBaseUrl().TrimEnd('/');
        return $"{baseUrl}/login?magicToken={token}";
    }

    public async Task<Guid?> ConsumeMagicLoginTokenAsync(string token, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(token)) return null;

        var cleanToken = token.Trim();
        var cacheKey = $"muro:magic:{cleanToken}";
        var cachedUserId = await _cache.GetAsync<string>(cacheKey);

        if (!string.IsNullOrEmpty(cachedUserId) && Guid.TryParse(cachedUserId, out var uid))
        {
            await _cache.RemoveAsync(cacheKey); // Single-use consumption
            return uid;
        }

        return null;
    }

    public async Task<Guid?> ValidateApiKeyAsync(string apiKeyHeader, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(apiKeyHeader)) return null;

        var cleanKey = apiKeyHeader.Trim();
        var hash = HashKey(cleanKey);

        var cacheKey = $"muro:connect:key:{hash}";
        var cachedTenantId = await _cache.GetAsync<string>(cacheKey);
        if (!string.IsNullOrEmpty(cachedTenantId) && Guid.TryParse(cachedTenantId, out var tid))
        {
            return tid;
        }

        var keyEntity = await _context.TenantApiKeys
            .AsNoTracking()
            .FirstOrDefaultAsync(k => k.KeyHash == hash && k.IsEnabled, ct);

        if (keyEntity == null) return null;

        await _cache.SetAsync(cacheKey, keyEntity.TenantId.ToString(), TimeSpan.FromHours(6));

        return keyEntity.TenantId;
    }

    public async Task<ConnectEnrollResponse> EnrollStudentAsync(Guid tenantId, ConnectEnrollRequest request, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(request.FirstName) || string.IsNullOrWhiteSpace(request.LastName))
        {
            throw new ArgumentException("Öğrenci ad ve soyad alanları zorunludur.");
        }

        var cleanPhone = NormalizePhone(request.Phone);
        var cleanEmail = request.Email?.Trim().ToLowerInvariant() ?? "";

        if (string.IsNullOrWhiteSpace(cleanEmail) && string.IsNullOrWhiteSpace(cleanPhone))
        {
            throw new ArgumentException("En az bir geçerli telefon veya e-posta adresi girilmelidir.");
        }

        // 1. Hedef Paketi veya Grubu Çözümle
        Package? targetPackage = null;
        MURO.Domain.Entities.Group? targetDirectGroup = null;

        if (!string.IsNullOrWhiteSpace(request.PackageCode))
        {
            var cleanCode = request.PackageCode.Trim();
            targetPackage = await _context.Packages
                .Include(p => p.PackageGroups)
                .FirstOrDefaultAsync(p => (p.Code == cleanCode || p.Name == cleanCode) && p.IsActive, ct);

            if (targetPackage == null && Guid.TryParse(cleanCode, out var parsedGuid))
            {
                targetPackage = await _context.Packages
                    .Include(p => p.PackageGroups)
                    .FirstOrDefaultAsync(p => p.Id == parsedGuid && p.IsActive, ct);

                if (targetPackage == null)
                {
                    targetDirectGroup = await _context.Groups.FirstOrDefaultAsync(g => g.Id == parsedGuid && !g.IsDeleted, ct);
                }
            }
        }
        else if (request.PackageId.HasValue)
        {
            targetPackage = await _context.Packages
                .Include(p => p.PackageGroups)
                .FirstOrDefaultAsync(p => p.Id == request.PackageId.Value && p.IsActive, ct);
        }
        else if (request.GroupId.HasValue)
        {
            targetDirectGroup = await _context.Groups.FirstOrDefaultAsync(g => g.Id == request.GroupId.Value && !g.IsDeleted, ct);
        }

        // 2. Mevcut Kullanıcıyı Ara
        User? existingUser = null;
        if (!string.IsNullOrWhiteSpace(cleanEmail))
        {
            existingUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == cleanEmail && !u.IsDeleted, ct);
        }
        if (existingUser == null && !string.IsNullOrWhiteSpace(cleanPhone))
        {
            var phone10 = cleanPhone.Length == 10 ? cleanPhone : (cleanPhone.Length == 11 && cleanPhone.StartsWith("0") ? cleanPhone.Substring(1) : cleanPhone);
            existingUser = await _context.Users.FirstOrDefaultAsync(u => u.Phone != null && u.Phone.Contains(phone10) && !u.IsDeleted, ct);
        }

        bool isNewUser = existingUser == null;
        User user;
        string rawPassword = request.Password ?? "";

        var sysSettings = await _context.SystemSettings.AsNoTracking().FirstOrDefaultAsync(ct);
        var tenantName = sysSettings?.TenantName ?? "MURO";
        var loginUrl = GetPortalBaseUrl();

        if (isNewUser)
        {
            var baseUsername = Regex.Replace(
                (request.FirstName + request.LastName)
                    .ToLowerInvariant()
                    .Replace("ı", "i")
                    .Replace("ğ", "g")
                    .Replace("ü", "u")
                    .Replace("ş", "s")
                    .Replace("ö", "o")
                    .Replace("ç", "c"),
                @"[^a-z0-9]", "");

            if (string.IsNullOrWhiteSpace(baseUsername)) baseUsername = "ogrenci";

            var uniqueUsername = baseUsername;
            int counter = 1;
            while (await _context.Users.AnyAsync(u => u.Username == uniqueUsername, ct))
            {
                uniqueUsername = $"{baseUsername}{counter++}";
            }

            if (string.IsNullOrWhiteSpace(rawPassword))
            {
                var phoneLast2 = cleanPhone.Length >= 2 ? cleanPhone.Substring(cleanPhone.Length - 2) : "12";
                var lastNameFirst = request.LastName.Length > 0 ? request.LastName.Substring(0, 1).ToLowerInvariant() : "x";
                rawPassword = $"{request.FirstName.ToLowerInvariant()}.{phoneLast2}.{lastNameFirst}";
            }

            user = new User
            {
                Id = Guid.NewGuid(),
                FirstName = request.FirstName.Trim(),
                LastName = request.LastName.Trim(),
                Email = cleanEmail,
                Username = uniqueUsername,
                Phone = cleanPhone,
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(rawPassword),
                Role = UserRole.Student,
                StudentType = StudentType.Active,
                IsActive = true,
                CreatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync(ct);
        }
        else
        {
            user = existingUser!;
            if (!string.IsNullOrWhiteSpace(request.FirstName)) user.FirstName = request.FirstName.Trim();
            if (!string.IsNullOrWhiteSpace(request.LastName)) user.LastName = request.LastName.Trim();
            if (!string.IsNullOrWhiteSpace(cleanPhone) && string.IsNullOrWhiteSpace(user.Phone)) user.Phone = cleanPhone;
            _context.Users.Update(user);
            await _context.SaveChangesAsync(ct);
        }

        // 3. Pakete ve Gruplara Kayıt Et
        string? assignedPackageName = null;
        if (targetPackage != null)
        {
            assignedPackageName = targetPackage.Name;
            var hasPackage = await _context.UserPackages.AnyAsync(up => up.UserId == user.Id && up.PackageId == targetPackage.Id, ct);
            if (!hasPackage)
            {
                _context.UserPackages.Add(new UserPackage
                {
                    Id = Guid.NewGuid(),
                    UserId = user.Id,
                    PackageId = targetPackage.Id,
                    Status = "active",
                    CreatedAt = DateTime.UtcNow,
                    ExpiresAt = targetPackage.DurationDays > 0 ? DateTime.UtcNow.AddDays(targetPackage.DurationDays) : null
                });
            }

            foreach (var pg in targetPackage.PackageGroups)
            {
                var isMember = await _context.GroupMembers.AnyAsync(gm => gm.UserId == user.Id && gm.GroupId == pg.GroupId, ct);
                if (!isMember)
                {
                    _context.GroupMembers.Add(new GroupMember
                    {
                        Id = Guid.NewGuid(),
                        UserId = user.Id,
                        GroupId = pg.GroupId,
                        Role = UserRole.Student,
                        Status = "active",
                        AddedAt = DateTime.UtcNow
                    });
                }
            }

            await _context.SaveChangesAsync(ct);
        }
        else if (targetDirectGroup != null || request.GroupId.HasValue)
        {
            var targetGid = targetDirectGroup?.Id ?? request.GroupId!.Value;
            var isMember = await _context.GroupMembers.AnyAsync(gm => gm.UserId == user.Id && gm.GroupId == targetGid, ct);
            if (!isMember)
            {
                _context.GroupMembers.Add(new GroupMember
                {
                    Id = Guid.NewGuid(),
                    UserId = user.Id,
                    GroupId = targetGid,
                    Role = UserRole.Student,
                    Status = "active",
                    AddedAt = DateTime.UtcNow
                });
                await _context.SaveChangesAsync(ct);
            }
            assignedPackageName = targetDirectGroup?.Name ?? "Ders Grubu";
        }

        // 4. Magic Login URL Üret
        var magicUrl = await GenerateMagicLoginUrlAsync(tenantId, user.Id, ct);

        // 5. Hoş Geldin SMS'i Fırlat
        if (request.SendWelcomeSms && !string.IsNullOrWhiteSpace(user.Phone))
        {
            try
            {
                var welcomeMsg = isNewUser
                    ? $"Merhaba {user.FirstName}, {tenantName} kaydınız tamamlandı! Kullanıcı Adı: {user.Username}, Şifre: {rawPassword}, Giriş: {loginUrl}"
                    : $"Merhaba {user.FirstName}, {assignedPackageName ?? "kurs"} eğitim paketiniz hesabınıza tanımlandı. Giriş: {loginUrl}";

                await _smsSender.SendAsync(user.Phone, welcomeMsg);
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "Connect Enroll sırasında SMS gönderilemedi: {Phone}", user.Phone);
            }
        }

        return new ConnectEnrollResponse
        {
            Success = true,
            Action = isNewUser ? "created_and_enrolled" : "enrolled_existing_user",
            UserId = user.Id,
            Username = user.Username,
            Email = user.Email,
            Phone = user.Phone ?? "",
            PackageName = assignedPackageName,
            GeneratedPassword = isNewUser ? rawPassword : null,
            MagicLoginUrl = magicUrl,
            Message = isNewUser 
                ? $"Yeni öğrenci hesabı açıldı ({user.Username}) ve {assignedPackageName ?? "kurs"} paketine kaydedildi."
                : $"Mevcut öğrenci ({user.Username}) bulundu ve {assignedPackageName ?? "kurs"} paketine kaydedildi."
        };
    }

    public async Task<ConnectUnenrollResponse> UnenrollStudentAsync(Guid tenantId, ConnectUnenrollRequest request, CancellationToken ct = default)
    {
        var cleanEmail = request.Email?.Trim().ToLowerInvariant();
        var cleanPhone = NormalizePhone(request.Phone ?? "");

        var user = await _context.Users
            .FirstOrDefaultAsync(u => (!string.IsNullOrEmpty(cleanEmail) && u.Email == cleanEmail) ||
                                      (!string.IsNullOrEmpty(cleanPhone) && u.Phone != null && u.Phone.Contains(cleanPhone)), ct);

        if (user == null)
        {
            throw new ArgumentException("İptal edilecek öğrenci bulunamadı.");
        }

        Package? pkg = null;
        if (!string.IsNullOrWhiteSpace(request.PackageCode))
        {
            pkg = await _context.Packages.Include(p => p.PackageGroups).FirstOrDefaultAsync(p => p.Code == request.PackageCode, ct);
        }
        else if (request.PackageId.HasValue)
        {
            pkg = await _context.Packages.Include(p => p.PackageGroups).FirstOrDefaultAsync(p => p.Id == request.PackageId.Value, ct);
        }

        if (pkg != null)
        {
            var userPkg = await _context.UserPackages.FirstOrDefaultAsync(up => up.UserId == user.Id && up.PackageId == pkg.Id, ct);
            if (userPkg != null)
            {
                userPkg.Status = "cancelled";
                userPkg.ExpiresAt = DateTime.UtcNow;
                _context.UserPackages.Update(userPkg);
            }

            var groupIds = pkg.PackageGroups.Select(pg => pg.GroupId).ToList();
            var members = await _context.GroupMembers.Where(gm => gm.UserId == user.Id && groupIds.Contains(gm.GroupId)).ToListAsync(ct);
            _context.GroupMembers.RemoveRange(members);

            await _context.SaveChangesAsync(ct);
        }

        return new ConnectUnenrollResponse
        {
            Success = true,
            Username = user.Username,
            PackageName = pkg?.Name,
            Message = $"Öğrencinin ({user.Username}) {pkg?.Name ?? "kurs"} paket erişimi başarıyla iptal edildi."
        };
    }

    public async Task<ConnectDemoLeadResponse> RegisterDemoLeadAsync(Guid tenantId, ConnectDemoLeadRequest request, CancellationToken ct = default)
    {
        var enrollReq = new ConnectEnrollRequest
        {
            FirstName = request.FirstName,
            LastName = request.LastName,
            Phone = request.Phone,
            Email = request.Email ?? "",
            PackageCode = request.PackageCode,
            SendWelcomeSms = request.SendWelcomeSms,
            Notes = "Web Sitesi Ücretsiz Demo Talebi"
        };

        var enrollRes = await EnrollStudentAsync(tenantId, enrollReq, ct);

        var user = await _context.Users.FindAsync(new object[] { enrollRes.UserId }, ct);
        if (user != null)
        {
            user.StudentType = StudentType.Demo;
            user.DemoExpiresAt = DateTime.UtcNow.AddDays(request.DemoDays > 0 ? request.DemoDays : 7);
            _context.Users.Update(user);
            await _context.SaveChangesAsync(ct);
        }

        return new ConnectDemoLeadResponse
        {
            Success = true,
            UserId = enrollRes.UserId,
            Username = enrollRes.Username,
            DemoExpiresAt = user?.DemoExpiresAt ?? DateTime.UtcNow.AddDays(7),
            Message = $"{request.DemoDays} Günlük ücretsiz demo erişimi tanımlandı ({enrollRes.Username}).",
            MagicLoginUrl = enrollRes.MagicLoginUrl
        };
    }

    public async Task<ConnectBatchEnrollResponse> BatchEnrollStudentsAsync(Guid tenantId, ConnectBatchEnrollRequest request, CancellationToken ct = default)
    {
        var results = new List<ConnectEnrollResponse>();
        int successCount = 0;
        int failCount = 0;

        foreach (var s in request.Students)
        {
            try
            {
                var res = await EnrollStudentAsync(tenantId, new ConnectEnrollRequest
                {
                    FirstName = s.FirstName,
                    LastName = s.LastName,
                    Email = s.Email,
                    Phone = s.Phone,
                    PackageCode = s.PackageCode,
                    Password = s.Password,
                    Notes = request.CorporateName != null ? $"Kurumsal Kayıt: {request.CorporateName}" : "Toplu Kayıt",
                    SendWelcomeSms = request.SendWelcomeSms
                }, ct);

                results.Add(res);
                successCount++;
            }
            catch (Exception ex)
            {
                failCount++;
                results.Add(new ConnectEnrollResponse
                {
                    Success = false,
                    Username = s.Email,
                    Email = s.Email,
                    Phone = s.Phone,
                    Message = ex.Message
                });
            }
        }

        return new ConnectBatchEnrollResponse
        {
            Success = failCount == 0,
            TotalSubmitted = request.Students.Count,
            SuccessCount = successCount,
            FailureCount = failCount,
            Results = results,
            Message = $"{successCount} öğrenci başarıyla kaydedildi, {failCount} hatalı."
        };
    }

    public async Task<ConnectStudentStatusResponse> GetStudentStatusAsync(Guid tenantId, string? email, string? phone, CancellationToken ct = default)
    {
        var cleanEmail = email?.Trim().ToLowerInvariant();
        var cleanPhone = NormalizePhone(phone ?? "");

        var user = await _context.Users
            .FirstOrDefaultAsync(u => (!string.IsNullOrEmpty(cleanEmail) && u.Email == cleanEmail && !u.IsDeleted) ||
                                      (!string.IsNullOrEmpty(cleanPhone) && u.Phone != null && u.Phone.Contains(cleanPhone) && !u.IsDeleted), ct);

        if (user == null)
        {
            return new ConnectStudentStatusResponse { UserExists = false };
        }

        var packages = await _context.UserPackages
            .Where(up => up.UserId == user.Id && up.Status == "active")
            .Include(up => up.Package)
            .Select(up => new ConnectUserPackageDto
            {
                PackageId = up.PackageId,
                PackageName = up.Package.Name,
                PackageCode = up.Package.Code,
                EnrolledAt = up.CreatedAt,
                ExpiresAt = up.ExpiresAt
            })
            .ToListAsync(ct);

        var magicUrl = await GenerateMagicLoginUrlAsync(tenantId, user.Id, ct);

        return new ConnectStudentStatusResponse
        {
            UserExists = true,
            UserId = user.Id,
            FullName = $"{user.FirstName} {user.LastName}",
            Username = user.Username,
            Email = user.Email,
            Phone = user.Phone,
            StudentType = user.StudentType?.ToString() ?? "Active",
            DemoExpiresAt = user.DemoExpiresAt,
            ActivePackages = packages,
            MagicLoginUrl = magicUrl
        };
    }

    public async Task<ConnectLiveStatusDto> GetLiveStatusAsync(Guid tenantId, CancellationToken ct = default)
    {
        var liveSession = await _context.Sessions
            .Include(s => s.Course)
                .ThenInclude(c => c.Instructor)
            .FirstOrDefaultAsync(s => s.Status == SessionStatus.Live, ct);

        if (liveSession == null)
        {
            return new ConnectLiveStatusDto { IsLiveNow = false };
        }

        var instructor = liveSession.Course?.Instructor;
        return new ConnectLiveStatusDto
        {
            IsLiveNow = true,
            SessionTitle = liveSession.Title,
            CourseTitle = liveSession.Course?.Title,
            InstructorName = instructor != null ? $"{instructor.FirstName} {instructor.LastName}" : null,
            StartedAt = liveSession.ScheduledStart,
            ViewerCount = 0,
            JoinUrl = GetPortalBaseUrl()
        };
    }

    public async Task<List<ConnectPackageItemDto>> GetPackagesCatalogAsync(Guid tenantId, CancellationToken ct = default)
    {
        var packages = await _context.Packages
            .AsNoTracking()
            .Where(p => p.IsActive)
            .Include(p => p.PackageGroups)
            .ToListAsync(ct);

        var groupIds = packages.SelectMany(p => p.PackageGroups.Select(pg => pg.GroupId)).Distinct().ToList();
        var courseGroups = await _context.CourseGroups
            .AsNoTracking()
            .Where(cg => groupIds.Contains(cg.GroupId))
            .Include(cg => cg.Course)
            .ToListAsync(ct);

        var result = new List<ConnectPackageItemDto>();
        foreach (var p in packages)
        {
            var pGroupIds = p.PackageGroups.Select(pg => pg.GroupId).ToHashSet();
            var titles = courseGroups
                .Where(cg => pGroupIds.Contains(cg.GroupId) && cg.Course != null && !cg.Course.IsDeleted)
                .Select(cg => cg.Course.Title)
                .Distinct()
                .ToList();

            result.Add(new ConnectPackageItemDto
            {
                Id = p.Id,
                Name = p.Name,
                Code = p.Code,
                Description = p.Description,
                Price = p.Price,
                DurationDays = p.DurationDays,
                CourseCount = titles.Count,
                CourseTitles = titles
            });
        }

        return result;
    }

    public async Task<List<ConnectGroupDto>> GetGroupsAsync(Guid tenantId, CancellationToken ct = default)
    {
        var groups = await _context.Groups
            .AsNoTracking()
            .Where(g => !g.IsDeleted)
            .Include(g => g.CourseGroups)
                .ThenInclude(cg => cg.Course)
            .Include(g => g.Members)
            .OrderBy(g => g.Name)
            .ToListAsync(ct);

        return groups.Select(g => new ConnectGroupDto
        {
            Id = g.Id,
            Name = g.Name,
            Code = g.Code,
            Description = g.Description,
            EducationType = g.EducationType,
            MemberCount = g.Members.Count(m => m.Status == "active"),
            CourseTitles = g.CourseGroups
                .Where(cg => !cg.Course.IsDeleted)
                .Select(cg => cg.Course.Title)
                .Distinct()
                .ToList()
        }).ToList();
    }

    public async Task<ConnectPackageSyncResponse> SyncPackagesAsync(Guid tenantId, List<ConnectPackageSyncItem> items, CancellationToken ct = default)
    {
        if (items == null || items.Count == 0)
        {
            return new ConnectPackageSyncResponse { Success = true, SyncedCount = 0, Message = "İçe aktarılacak paket bulunamadı." };
        }

        int synced = 0;
        foreach (var item in items)
        {
            if (string.IsNullOrWhiteSpace(item.Name) || string.IsNullOrWhiteSpace(item.Code))
                continue;

            var cleanCode = item.Code.Trim();
            var existing = await _context.Packages
                .Include(p => p.PackageGroups)
                .FirstOrDefaultAsync(p => p.Code == cleanCode, ct);

            if (existing == null)
            {
                var newPkg = new Package
                {
                    Id = Guid.NewGuid(),
                    Name = item.Name.Trim(),
                    Code = cleanCode,
                    Description = item.Description?.Trim(),
                    Price = item.Price,
                    DurationDays = item.DurationDays > 0 ? item.DurationDays : 365,
                    IsActive = item.IsActive,
                    CreatedAt = DateTime.UtcNow
                };

                if (item.GroupIds != null && item.GroupIds.Count > 0)
                {
                    foreach (var gid in item.GroupIds.Distinct())
                    {
                        var groupExists = await _context.Groups.AnyAsync(g => g.Id == gid && !g.IsDeleted, ct);
                        if (groupExists)
                        {
                            newPkg.PackageGroups.Add(new PackageGroup
                            {
                                Id = Guid.NewGuid(),
                                PackageId = newPkg.Id,
                                GroupId = gid
                            });
                        }
                    }
                }

                _context.Packages.Add(newPkg);
            }
            else
            {
                existing.Name = item.Name.Trim();
                existing.Description = item.Description?.Trim();
                existing.Price = item.Price;
                existing.DurationDays = item.DurationDays > 0 ? item.DurationDays : existing.DurationDays;
                existing.IsActive = item.IsActive;

                if (item.GroupIds != null)
                {
                    // Existing groups
                    var currentGroupIds = existing.PackageGroups.Select(pg => pg.GroupId).ToHashSet();
                    var targetGroupIds = item.GroupIds.ToHashSet();

                    // Remove missing
                    var toRemove = existing.PackageGroups.Where(pg => !targetGroupIds.Contains(pg.GroupId)).ToList();
                    foreach (var rm in toRemove)
                    {
                        _context.PackageGroups.Remove(rm);
                    }

                    // Add new
                    foreach (var gid in targetGroupIds)
                    {
                        if (!currentGroupIds.Contains(gid))
                        {
                            var groupExists = await _context.Groups.AnyAsync(g => g.Id == gid && !g.IsDeleted, ct);
                            if (groupExists)
                            {
                                existing.PackageGroups.Add(new PackageGroup
                                {
                                    Id = Guid.NewGuid(),
                                    PackageId = existing.Id,
                                    GroupId = gid
                                });
                            }
                        }
                    }
                }

                _context.Packages.Update(existing);
            }

            synced++;
        }

        await _context.SaveChangesAsync(ct);

        var currentCatalog = await GetPackagesCatalogAsync(tenantId, ct);

        return new ConnectPackageSyncResponse
        {
            Success = true,
            SyncedCount = synced,
            Message = $"{synced} paket başarıyla eşitlendi ve gruplara bağlandı.",
            Packages = currentCatalog
        };
    }


    public async Task<ConnectStatsDto> GetStatsAsync(Guid tenantId, CancellationToken ct = default)
    {
        var totalStudents = await _context.Users.CountAsync(u => u.Role == UserRole.Student && u.IsActive && !u.IsDeleted, ct);
        var totalCourses = await _context.Courses.CountAsync(c => c.IsPublished && !c.IsDeleted, ct);
        var totalRecordings = await _context.MediaAssets.CountAsync(ct);
        var totalLive = await _context.Sessions.CountAsync(ct);
        var sys = await _context.SystemSettings.AsNoTracking().FirstOrDefaultAsync(ct);

        return new ConnectStatsDto
        {
            TotalStudents = totalStudents,
            TotalCourses = totalCourses,
            TotalRecordings = totalRecordings,
            TotalLiveSessions = totalLive,
            TenantName = sys?.TenantName ?? "MURO"
        };
    }

    public async Task<TenantApiKeyDto> GetOrCreateApiKeyAsync(Guid tenantId, CancellationToken ct = default)
    {
        var existing = await _context.TenantApiKeys
            .FirstOrDefaultAsync(k => k.TenantId == tenantId && k.IsEnabled, ct);

        if (existing != null)
        {
            return new TenantApiKeyDto
            {
                Id = existing.Id,
                KeyPrefix = existing.KeyPrefix,
                FullKey = null,
                Name = existing.Name,
                Scopes = existing.Scopes,
                IsEnabled = existing.IsEnabled,
                LastUsedAt = existing.LastUsedAt,
                CreatedAt = existing.CreatedAt
            };
        }

        return await RegenerateApiKeyAsync(tenantId, "Varsayılan Web Sitesi API Anahtarı", ct);
    }

    public async Task<TenantApiKeyDto> RegenerateApiKeyAsync(Guid tenantId, string? name = null, CancellationToken ct = default)
    {
        var oldKeys = await _context.TenantApiKeys.Where(k => k.TenantId == tenantId).ToListAsync(ct);
        foreach (var k in oldKeys)
        {
            k.IsEnabled = false;
        }

        var rawKey = $"muro_live_{GenerateRandomHex(16)}";
        var hash = HashKey(rawKey);
        var prefix = $"{rawKey.Substring(0, 18)}...";

        var newKey = new TenantApiKey
        {
            Id = Guid.NewGuid(),
            TenantId = tenantId,
            KeyPrefix = prefix,
            KeyHash = hash,
            Name = name ?? "Varsayılan Web Sitesi API Anahtarı",
            Scopes = "enroll,catalog,stats",
            IsEnabled = true,
            CreatedAt = DateTime.UtcNow
        };

        _context.TenantApiKeys.Add(newKey);
        await _context.SaveChangesAsync(ct);

        await _cache.RemoveAsync($"muro:connect:key:{hash}");
        await _cache.SetAsync($"muro:connect:key:{hash}", tenantId.ToString(), TimeSpan.FromHours(12));

        return new TenantApiKeyDto
        {
            Id = newKey.Id,
            KeyPrefix = newKey.KeyPrefix,
            FullKey = rawKey,
            Name = newKey.Name,
            Scopes = newKey.Scopes,
            IsEnabled = newKey.IsEnabled,
            LastUsedAt = null,
            CreatedAt = newKey.CreatedAt
        };
    }

    public async Task<List<ConnectApiLogDto>> GetLogsAsync(Guid tenantId, int take = 50, CancellationToken ct = default)
    {
        return await _context.ConnectApiLogs
            .AsNoTracking()
            .Where(l => l.TenantId == tenantId)
            .OrderByDescending(l => l.CreatedAt)
            .Take(take)
            .Select(l => new ConnectApiLogDto
            {
                Id = l.Id,
                Endpoint = l.Endpoint,
                HttpMethod = l.HttpMethod,
                IpAddress = l.IpAddress,
                StatusCode = l.StatusCode,
                RequestBody = l.RequestBody,
                ResponseBody = l.ResponseBody,
                DurationMs = l.DurationMs,
                CreatedAt = l.CreatedAt
            })
            .ToListAsync(ct);
    }

    public async Task LogRequestAsync(Guid tenantId, Guid? apiKeyId, string endpoint, string method, string? ip, int statusCode, string? reqBody, string? resBody, long durationMs)
    {
        try
        {
            var log = new ConnectApiLog
            {
                Id = Guid.NewGuid(),
                TenantId = tenantId,
                ApiKeyId = apiKeyId,
                Endpoint = endpoint,
                HttpMethod = method,
                IpAddress = ip,
                StatusCode = statusCode,
                RequestBody = reqBody != null && reqBody.Length > 2000 ? reqBody.Substring(0, 2000) : reqBody,
                ResponseBody = resBody != null && resBody.Length > 2000 ? resBody.Substring(0, 2000) : resBody,
                DurationMs = durationMs,
                CreatedAt = DateTime.UtcNow
            };

            _context.ConnectApiLogs.Add(log);
            await _context.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "ConnectApiLog kaydedilemedi.");
        }
    }
}

public class ConnectDemoLeadAsyncResponseDto
{
    public bool Success { get; set; }
    public Guid UserId { get; set; }
    public string Username { get; set; } = string.Empty;
    public DateTime DemoExpiresAt { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? MagicLoginUrl { get; set; }
}
