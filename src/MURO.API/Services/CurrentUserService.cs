using System;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using MURO.Application.Interfaces;

namespace MURO.API.Services;

public class CurrentUserService : ICurrentUserService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CurrentUserService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public Guid? UserId
    {
        get
        {
            var id = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            return id != null ? Guid.Parse(id) : null;
        }
    }

    public string? UserName
    {
        get
        {
            var user = _httpContextAccessor.HttpContext?.User;
            if (user == null) return null;

            var firstName = user.FindFirst(ClaimTypes.GivenName)?.Value;
            var lastName = user.FindFirst(ClaimTypes.Surname)?.Value;

            if (!string.IsNullOrEmpty(firstName))
            {
                return $"{firstName} {lastName}".Trim();
            }

            return user.FindFirst(ClaimTypes.Name)?.Value;
        }
    }

    public string? IpAddress
    {
        get
        {
            var context = _httpContextAccessor.HttpContext;
            if (context == null) return null;

            var forwardedHeader = context.Request.Headers["X-Forwarded-For"].FirstOrDefault();
            if (!string.IsNullOrEmpty(forwardedHeader))
            {
                return forwardedHeader.Split(',')[0].Trim();
            }

            return context.Connection?.RemoteIpAddress?.ToString();
        }
    }
}
