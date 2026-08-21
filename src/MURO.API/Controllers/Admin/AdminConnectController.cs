using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using MURO.Application.DTOs.Connect;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers.Admin;

[EnableRateLimiting("ApiPolicy")]
[Authorize(Roles = "SuperAdmin")]
[ApiController]
[Route("api/v1/admin/connect")]
public class AdminConnectController : ControllerBase
{
    private readonly IConnectApiService _connectService;

    public AdminConnectController(IConnectApiService connectService)
    {
        _connectService = connectService;
    }

    private Guid GetTenantId()
    {
        if (Request.Headers.TryGetValue("X-Tenant-Id", out var tidHeader) && Guid.TryParse(tidHeader, out var tid))
        {
            return tid;
        }
        return Guid.Empty;
    }

    [HttpGet("key")]
    public async Task<IActionResult> GetApiKey()
    {
        var tenantId = GetTenantId();
        var key = await _connectService.GetOrCreateApiKeyAsync(tenantId, HttpContext.RequestAborted);
        return Ok(key);
    }

    [HttpPost("key/regenerate")]
    public async Task<IActionResult> RegenerateApiKey([FromBody] RegenerateKeyRequest? request)
    {
        var tenantId = GetTenantId();
        var key = await _connectService.RegenerateApiKeyAsync(tenantId, request?.Name, HttpContext.RequestAborted);
        return Ok(key);
    }

    [HttpGet("logs")]
    public async Task<IActionResult> GetLogs([FromQuery] int take = 50)
    {
        var tenantId = GetTenantId();
        var logs = await _connectService.GetLogsAsync(tenantId, take, HttpContext.RequestAborted);
        return Ok(logs);
    }

    [HttpPost("test-enroll")]
    public async Task<IActionResult> TestEnroll([FromBody] ConnectEnrollRequest request)
    {
        var tenantId = GetTenantId();
        var result = await _connectService.EnrollStudentAsync(tenantId, request, HttpContext.RequestAborted);
        return Ok(result);
    }
}

public class RegenerateKeyRequest
{
    public string? Name { get; set; }
}
