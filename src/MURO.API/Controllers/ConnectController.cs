using System;
using System.Diagnostics;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using MURO.Application.DTOs.Connect;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

/// <summary>
/// Harici web siteleri, Shopier, WordPress ve ödeme geçitleri için Evrensel Geliştirici API'si.
/// </summary>
[AllowAnonymous]
[EnableRateLimiting("ApiPolicy")]
[ApiController]
[Route("api/v1/connect")]
public class ConnectController : ControllerBase
{
    private readonly IConnectApiService _connectService;

    public ConnectController(IConnectApiService connectService)
    {
        _connectService = connectService;
    }

    private async Task<(Guid? tenantId, string? error)> AuthenticateRequestAsync()
    {
        if (!Request.Headers.TryGetValue("X-Muro-Key", out var keyValues) || string.IsNullOrWhiteSpace(keyValues))
        {
            return (null, "Geçersiz veya eksik API Anahtarı. Lütfen 'X-Muro-Key' başlığını ekleyiniz.");
        }

        var tenantId = await _connectService.ValidateApiKeyAsync(keyValues.ToString(), HttpContext.RequestAborted);
        if (!tenantId.HasValue)
        {
            return (null, "Yetkisiz erişim. API Anahtarı geçersiz veya iptal edilmiş.");
        }

        return (tenantId, null);
    }

    [HttpPost("enroll")]
    public async Task<IActionResult> EnrollStudent([FromBody] ConnectEnrollRequest request)
    {
        var sw = Stopwatch.StartNew();
        var (tenantId, authError) = await AuthenticateRequestAsync();

        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        string reqJson = "";
        try { reqJson = JsonSerializer.Serialize(request); } catch { }

        try
        {
            var result = await _connectService.EnrollStudentAsync(tenantId.Value, request, HttpContext.RequestAborted);
            sw.Stop();

            var resJson = JsonSerializer.Serialize(result);
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/enroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 200, reqJson, resJson, sw.ElapsedMilliseconds);

            return Ok(result);
        }
        catch (ArgumentException aEx)
        {
            sw.Stop();
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/enroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 400, reqJson, aEx.Message, sw.ElapsedMilliseconds);
            return BadRequest(new { error = aEx.Message });
        }
        catch (Exception ex)
        {
            sw.Stop();
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/enroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 500, reqJson, ex.Message, sw.ElapsedMilliseconds);
            return StatusCode(500, new { error = "Öğrenci kaydı sırasında bir sunucu hatası oluştu: " + ex.Message });
        }
    }

    [HttpPost("unenroll")]
    public async Task<IActionResult> UnenrollStudent([FromBody] ConnectUnenrollRequest request)
    {
        var sw = Stopwatch.StartNew();
        var (tenantId, authError) = await AuthenticateRequestAsync();

        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        string reqJson = "";
        try { reqJson = JsonSerializer.Serialize(request); } catch { }

        try
        {
            var result = await _connectService.UnenrollStudentAsync(tenantId.Value, request, HttpContext.RequestAborted);
            sw.Stop();

            var resJson = JsonSerializer.Serialize(result);
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/unenroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 200, reqJson, resJson, sw.ElapsedMilliseconds);

            return Ok(result);
        }
        catch (ArgumentException aEx)
        {
            sw.Stop();
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/unenroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 400, reqJson, aEx.Message, sw.ElapsedMilliseconds);
            return BadRequest(new { error = aEx.Message });
        }
        catch (Exception ex)
        {
            sw.Stop();
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/unenroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 500, reqJson, ex.Message, sw.ElapsedMilliseconds);
            return StatusCode(500, new { error = "İptal işlemi sırasında bir hata oluştu: " + ex.Message });
        }
    }

    [HttpPost("demo-lead")]
    public async Task<IActionResult> RegisterDemoLead([FromBody] ConnectDemoLeadRequest request)
    {
        var sw = Stopwatch.StartNew();
        var (tenantId, authError) = await AuthenticateRequestAsync();

        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        string reqJson = "";
        try { reqJson = JsonSerializer.Serialize(request); } catch { }

        try
        {
            var result = await _connectService.RegisterDemoLeadAsync(tenantId.Value, request, HttpContext.RequestAborted);
            sw.Stop();

            var resJson = JsonSerializer.Serialize(result);
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/demo-lead", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 200, reqJson, resJson, sw.ElapsedMilliseconds);

            return Ok(result);
        }
        catch (Exception ex)
        {
            sw.Stop();
            _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/demo-lead", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 400, reqJson, ex.Message, sw.ElapsedMilliseconds);
            return BadRequest(new { error = ex.Message });
        }
    }

    [HttpPost("batch-enroll")]
    public async Task<IActionResult> BatchEnroll([FromBody] ConnectBatchEnrollRequest request)
    {
        var sw = Stopwatch.StartNew();
        var (tenantId, authError) = await AuthenticateRequestAsync();

        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        string reqJson = "";
        try { reqJson = JsonSerializer.Serialize(request); } catch { }

        var result = await _connectService.BatchEnrollStudentsAsync(tenantId.Value, request, HttpContext.RequestAborted);
        sw.Stop();

        var resJson = JsonSerializer.Serialize(result);
        _ = _connectService.LogRequestAsync(tenantId.Value, null, "/api/v1/connect/batch-enroll", "POST", HttpContext.Connection.RemoteIpAddress?.ToString(), 200, reqJson, resJson, sw.ElapsedMilliseconds);

        return Ok(result);
    }

    [HttpGet("students/status")]
    public async Task<IActionResult> GetStudentStatus([FromQuery] string? email, [FromQuery] string? phone)
    {
        var (tenantId, authError) = await AuthenticateRequestAsync();
        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        var status = await _connectService.GetStudentStatusAsync(tenantId.Value, email, phone, HttpContext.RequestAborted);
        return Ok(status);
    }

    [HttpGet("live-status")]
    public async Task<IActionResult> GetLiveStatus()
    {
        var (tenantId, authError) = await AuthenticateRequestAsync();
        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        var status = await _connectService.GetLiveStatusAsync(tenantId.Value, HttpContext.RequestAborted);
        return Ok(status);
    }

    [HttpGet("packages")]
    public async Task<IActionResult> GetPackages()
    {
        var (tenantId, authError) = await AuthenticateRequestAsync();
        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        var packages = await _connectService.GetPackagesCatalogAsync(tenantId.Value, HttpContext.RequestAborted);
        return Ok(packages);
    }

    [HttpGet("stats")]
    public async Task<IActionResult> GetStats()
    {
        var (tenantId, authError) = await AuthenticateRequestAsync();
        if (authError != null || !tenantId.HasValue)
        {
            return Unauthorized(new { error = authError });
        }

        var stats = await _connectService.GetStatsAsync(tenantId.Value, HttpContext.RequestAborted);
        return Ok(stats);
    }
}
