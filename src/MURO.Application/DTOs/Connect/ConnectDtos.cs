using System;
using System.Collections.Generic;

namespace MURO.Application.DTOs.Connect;

public class ConnectEnrollRequest
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string? PackageCode { get; set; }
    public Guid? PackageId { get; set; }
    public Guid? CourseId { get; set; }
    public Guid? GroupId { get; set; }
    public string? Password { get; set; }
    public string? OrderId { get; set; }
    public string? Notes { get; set; }
    public bool SendWelcomeSms { get; set; } = true;
    public bool SendWelcomeEmail { get; set; } = true;
}

public class ConnectEnrollResponse
{
    public bool Success { get; set; }
    public string Action { get; set; } = "created_and_enrolled"; // "created_and_enrolled" | "enrolled_existing_user"
    public Guid UserId { get; set; }
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string? PackageName { get; set; }
    public string? GeneratedPassword { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? MagicLoginUrl { get; set; }
}

public class ConnectUnenrollRequest
{
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? PackageCode { get; set; }
    public Guid? PackageId { get; set; }
    public string? Reason { get; set; }
}

public class ConnectUnenrollResponse
{
    public bool Success { get; set; }
    public string Username { get; set; } = string.Empty;
    public string? PackageName { get; set; }
    public string Message { get; set; } = string.Empty;
}

public class ConnectDemoLeadRequest
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string? Email { get; set; }
    public string? PackageCode { get; set; }
    public int DemoDays { get; set; } = 7;
    public bool SendWelcomeSms { get; set; } = true;
}

public class ConnectDemoLeadResponse
{
    public bool Success { get; set; }
    public Guid UserId { get; set; }
    public string Username { get; set; } = string.Empty;
    public DateTime DemoExpiresAt { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? MagicLoginUrl { get; set; }
}

public class ConnectBatchEnrollItem
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public string? PackageCode { get; set; }
    public string? Password { get; set; }
}

public class ConnectBatchEnrollRequest
{
    public List<ConnectBatchEnrollItem> Students { get; set; } = new();
    public string? CorporateName { get; set; }
    public bool SendWelcomeSms { get; set; } = true;
}

public class ConnectBatchEnrollResponse
{
    public bool Success { get; set; }
    public int TotalSubmitted { get; set; }
    public int SuccessCount { get; set; }
    public int FailureCount { get; set; }
    public List<ConnectEnrollResponse> Results { get; set; } = new();
    public string Message { get; set; } = string.Empty;
}

public class ConnectStudentStatusResponse
{
    public bool UserExists { get; set; }
    public Guid? UserId { get; set; }
    public string? FullName { get; set; }
    public string? Username { get; set; }
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? StudentType { get; set; }
    public DateTime? DemoExpiresAt { get; set; }
    public List<ConnectUserPackageDto> ActivePackages { get; set; } = new();
    public string? MagicLoginUrl { get; set; }
}

public class ConnectUserPackageDto
{
    public Guid PackageId { get; set; }
    public string PackageName { get; set; } = string.Empty;
    public string? PackageCode { get; set; }
    public DateTime EnrolledAt { get; set; }
    public DateTime? ExpiresAt { get; set; }
}

public class ConnectLiveStatusDto
{
    public bool IsLiveNow { get; set; }
    public string? SessionTitle { get; set; }
    public string? CourseTitle { get; set; }
    public string? InstructorName { get; set; }
    public DateTime? StartedAt { get; set; }
    public int ViewerCount { get; set; }
    public string? JoinUrl { get; set; }
}

public class ConnectPackageItemDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Code { get; set; }
    public string? Description { get; set; }
    public decimal Price { get; set; }
    public int DurationDays { get; set; }
    public int CourseCount { get; set; }
    public List<string> CourseTitles { get; set; } = new();
}

public class ConnectStatsDto
{
    public int TotalStudents { get; set; }
    public int TotalCourses { get; set; }
    public int TotalRecordings { get; set; }
    public int TotalLiveSessions { get; set; }
    public string TenantName { get; set; } = string.Empty;
}

public class TenantApiKeyDto
{
    public Guid Id { get; set; }
    public string KeyPrefix { get; set; } = string.Empty;
    public string? FullKey { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Scopes { get; set; } = string.Empty;
    public bool IsEnabled { get; set; }
    public DateTime? LastUsedAt { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class ConnectApiLogDto
{
    public Guid Id { get; set; }
    public string Endpoint { get; set; } = string.Empty;
    public string HttpMethod { get; set; } = "POST";
    public string? IpAddress { get; set; }
    public int StatusCode { get; set; }
    public string? RequestBody { get; set; }
    public string? ResponseBody { get; set; }
    public long DurationMs { get; set; }
    public DateTime CreatedAt { get; set; }
}
