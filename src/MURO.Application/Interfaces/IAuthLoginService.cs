using MURO.Application.DTOs.Auth;

namespace MURO.Application.Interfaces;

public interface IAuthLoginService
{
    Task<AuthResponse> LoginAsync(LoginRequest request, string? ipAddress = null, string? userAgent = null, string? deviceId = null);
    Task<AuthResponse> RegisterAsync(RegisterRequest request);
    Task<UserDto> GetCurrentUserAsync(Guid userId);
}
