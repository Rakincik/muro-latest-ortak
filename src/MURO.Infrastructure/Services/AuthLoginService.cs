using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MURO.Application.DTOs.Auth;
using MURO.Application.Interfaces;
using MURO.Application.Exceptions;
using MURO.Domain.Entities;
using MURO.Domain.Enums;
using MURO.Infrastructure.Persistence;
using StackExchange.Redis;

namespace MURO.Infrastructure.Services;

public class AuthLoginService : AuthServiceBase, IAuthLoginService
{
    private readonly INotificationPush _push;

    public AuthLoginService(
        MuroDbContext context, 
        IConfiguration config, 
        INotificationPush push,
        IConnectionMultiplexer? redis = null)
        : base(context, config, redis)
    {
        _push = push;
    }

    public async Task<AuthResponse> LoginAsync(LoginRequest request, string? ipAddress = null, string? userAgent = null, string? deviceId = null)
    {
        var lookupEmail = request.Email?.Trim();
        var phoneWithoutZero = lookupEmail;
        if (!string.IsNullOrEmpty(lookupEmail) && lookupEmail.StartsWith("0") && lookupEmail.Length > 1)
        {
            phoneWithoutZero = lookupEmail.Substring(1);
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Email == lookupEmail 
                                   || u.Username == lookupEmail 
                                   || u.Username == phoneWithoutZero
                                   || (u.Phone != null && u.Phone == lookupEmail)
                                   || (u.Phone != null && u.Phone == phoneWithoutZero));

        // Lockout bypass (Lockout policy disabled)

        bool isPasswordValid = false;
        if (user != null)
        {
            if (user.PasswordHash.StartsWith("$2"))
            {
                isPasswordValid = BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash);
            }
            else
            {
                isPasswordValid = (request.Password == user.PasswordHash);
            }
        }

        if (user == null || !isPasswordValid)
        {
            if (user != null)
            {
                user.FailedLoginCount++;
                await _context.SaveChangesAsync();
                await LogSecurityEventAsync(user.Id, "LOGIN_FAILED", ipAddress, userAgent,
                    JsonSerializer.Serialize(new { attempt = user.FailedLoginCount }));
            }
            else
            {
                await LogSecurityEventAsync(null, "LOGIN_FAILED", ipAddress, userAgent,
                    JsonSerializer.Serialize(new { email = request.Email }));
            }

            throw new UnauthorizedAccessException("Geçersiz e-posta veya şifre.");
        }

        if (!user.IsActive)
            throw new UnauthorizedAccessException("Hesabınız devre dışı bırakılmış.");

        if (user.StudentType == StudentType.Demo && user.DemoExpiresAt.HasValue && user.DemoExpiresAt < DateTime.UtcNow)
            throw new UnauthorizedAccessException("Demo süreniz dolmuş.");

        user.FailedLoginCount = 0;
        user.LockoutUntil = null;
        user.LastLoginAt = DateTime.UtcNow;

        var existingSessions = await _context.DeviceSessions
            .Where(s => s.UserId == user.Id && s.IsActive)
            .ToListAsync();

        var newDeviceInfo = ParseDeviceInfo(userAgent);
        if (!string.IsNullOrEmpty(deviceId))
        {
            newDeviceInfo = $"{newDeviceInfo}|{deviceId}";
        }

        foreach (var old in existingSessions)
        {
            old.IsActive = false;
            old.LogoutAt = DateTime.UtcNow;
            
            // 🚀 Real-time kick: Remove from Redis cache instantly to bypass 5-min TTL loophole
            if (_redis != null)
            {
                try
                {
                    var redisDb = _redis.GetDatabase();
                    await redisDb.KeyDeleteAsync($"session:active:{old.Id}");
                }
                catch (Exception ex)
                {
                    // Redis connection issues shouldn't block the login flow, fail silently
                }
            }

            // ⚡ Real-time kick via SignalR WebSocket group push
            try
            {
                await _push.PushSessionKickAsync(old.Id.ToString());
            }
            catch (Exception)
            {
                // SignalR push failure should fail silently to not interrupt login process
            }
            
            bool hasDeviceIdMatch = !string.IsNullOrEmpty(deviceId) && old.DeviceInfo != null && old.DeviceInfo.EndsWith($"|{deviceId}");

            if ((old.IpAddress == ipAddress && old.DeviceInfo == newDeviceInfo) || hasDeviceIdMatch)
            {
                await LogSecurityEventAsync(user.Id, "SESSION_REPLACED", ipAddress, userAgent,
                    JsonSerializer.Serialize(new { replacedSessionId = old.Id, reason = hasDeviceIdMatch ? "SAME_DEVICE_ID" : "SAME_IP_AND_AGENT" }));
            }
            else
            {
                await LogSecurityEventAsync(user.Id, "SESSION_KICKED", ipAddress, userAgent,
                    JsonSerializer.Serialize(new
                    {
                        kickedSessionId = old.Id,
                        kickedDeviceInfo = old.DeviceInfo,
                        kickedIp = old.IpAddress,
                        newIp = ipAddress
                    }));
            }
        }

        var deviceSession = new DeviceSession
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            IpAddress = ipAddress,
            UserAgent = userAgent,
            DeviceInfo = newDeviceInfo,
            LoginAt = DateTime.UtcNow,
            IsActive = true
        };
        _context.DeviceSessions.Add(deviceSession);
        await _context.SaveChangesAsync();

        var lastKnownIp = existingSessions.FirstOrDefault()?.IpAddress;
        if (!string.IsNullOrEmpty(lastKnownIp) && lastKnownIp != ipAddress)
        {
            await LogSecurityEventAsync(user.Id,  "NEW_IP_LOGIN", ipAddress, userAgent,
                JsonSerializer.Serialize(new { previousIp = lastKnownIp, newIp = ipAddress }));
        }

        await LogSecurityEventAsync(user.Id,  "LOGIN_SUCCESS", ipAddress, userAgent,
            JsonSerializer.Serialize(new { deviceInfo = deviceSession.DeviceInfo, sessionId = deviceSession.Id }));

        var token = GenerateJwtToken(user, deviceSession.Id);
        var refreshToken = GenerateRefreshToken();

        await StoreRefreshTokenAsync(user.Id, refreshToken, deviceSession.Id);

        return new AuthResponse(token, refreshToken, DateTime.UtcNow.AddHours(AccessTokenExpiryHours), MapToDto(user));
    }

    public async Task<AuthResponse> RegisterAsync(RegisterRequest request)
    {
        var maxStudentsStr = Environment.GetEnvironmentVariable("MAX_STUDENTS");
        if (!string.IsNullOrEmpty(maxStudentsStr) && int.TryParse(maxStudentsStr, out var maxStudents) && maxStudents > 0)
        {
            var activeStudentsCount = await _context.Users
                .CountAsync(u => u.IsActive && u.Role == UserRole.Student);

            if (activeStudentsCount >= maxStudents)
            {
                throw new QuotaExceededException("Öğrenci kotanız dolmuştur. Kapasite arttırımı için ilgili kişilerle iletişime geçiniz.");
            }
        }

        if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            throw new InvalidOperationException("Bu e-posta adresi zaten kayıtlı.");

        var user = new User
        {
            Id = Guid.NewGuid(),
            FirstName = request.FirstName,
            LastName = request.LastName,
            Email = request.Email,
            Username = request.Email, // Register defaults username to email
            Phone = request.Phone,
            PasswordHash = request.Password,
            Role = UserRole.Student,
            StudentType = StudentType.Active,
        };

        _context.Users.Add(user);

        await _context.SaveChangesAsync();

        user = await _context.Users
            .FirstAsync(u => u.Id == user.Id);

        var deviceSession = new DeviceSession
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            LoginAt = DateTime.UtcNow,
            IsActive = true
        };
        _context.DeviceSessions.Add(deviceSession);
        await _context.SaveChangesAsync();

        var token = GenerateJwtToken(user, deviceSession.Id);
        var refreshToken = GenerateRefreshToken();
        await StoreRefreshTokenAsync(user.Id, refreshToken, deviceSession.Id);

        return new AuthResponse(token, refreshToken, DateTime.UtcNow.AddHours(AccessTokenExpiryHours), MapToDto(user));
    }

    public async Task<UserDto> GetCurrentUserAsync(Guid userId)
    {
        var user = await _context.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Id == userId)
            ?? throw new KeyNotFoundException("Kullanıcı bulunamadı.");

        return MapToDto(user);
    }
}
