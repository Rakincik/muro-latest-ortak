using System;

namespace MURO.Application.Interfaces;

public interface ICurrentUserService
{
    Guid? UserId { get; }
    string? UserName { get; }
    string? IpAddress { get; }
}
