using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using MURO.Application.DTOs.Integrations;
using MURO.Application.Interfaces;
using MURO.Infrastructure.Services;

namespace MURO.API.Controllers.Admin;

[EnableRateLimiting("ApiPolicy")]
[Authorize(Roles = "SuperAdmin,Admin")]
[ApiController]
[Route("api/v1/admin/integrations")]
public class AdminIntegrationController : ControllerBase
{
    private readonly IIntegrationService _integrationService;
    private readonly ISmsService _smsService;
    private readonly TopluSmsService _topluSmsService;

    public AdminIntegrationController(
        IIntegrationService integrationService,
        ISmsService smsService,
        TopluSmsService topluSmsService)
    {
        _integrationService = integrationService;
        _smsService = smsService;
        _topluSmsService = topluSmsService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAllIntegrations()
    {
        var integrations = await _integrationService.GetAllIntegrationsAsync(HttpContext.RequestAborted);
        return Ok(integrations);
    }

    [HttpGet("{providerKey}")]
    public async Task<IActionResult> GetIntegration(string providerKey)
    {
        var item = await _integrationService.GetIntegrationAsync(providerKey, HttpContext.RequestAborted);
        if (item == null) return NotFound(new { error = "Entegrasyon bulunamadı." });
        return Ok(item);
    }

    [HttpPut("{providerKey}")]
    public async Task<IActionResult> UpdateIntegration(string providerKey, [FromBody] UpdateIntegrationRequest request)
    {
        var updatedBy = User.FindFirstValue(ClaimTypes.Name) ?? User.FindFirstValue(ClaimTypes.Email) ?? "SuperAdmin";
        var result = await _integrationService.UpdateIntegrationAsync(providerKey, request, updatedBy, HttpContext.RequestAborted);
        return Ok(result);
    }

    [HttpPost("{providerKey}/test")]
    public async Task<IActionResult> TestIntegration(string providerKey, [FromBody] TestIntegrationRequest request)
    {
        if (providerKey.Equals("toplusms", StringComparison.OrdinalIgnoreCase))
        {
            var result = await _integrationService.TestTopluSmsAsync(request, HttpContext.RequestAborted);
            return Ok(result);
        }

        if (providerKey.Equals("vatansms", StringComparison.OrdinalIgnoreCase))
        {
            var result = await _integrationService.TestVatanSmsAsync(request, HttpContext.RequestAborted);
            return Ok(result);
        }

        return BadRequest(new { error = $"{providerKey} için test henüz desteklenmiyor." });
    }

    [HttpPost("sms/send-test")]
    public async Task<IActionResult> SendTestSms([FromBody] SendSingleSmsRequest request)
    {
        var result = await _smsService.SendSmsAsync(request, HttpContext.RequestAborted);
        return Ok(result);
    }

    [HttpGet("sms/senders")]
    public async Task<IActionResult> GetSmsSenders()
    {
        var toplusms = await _topluSmsService.GetActiveConfigAsync(null, HttpContext.RequestAborted);
        if (toplusms != null)
        {
            var s = await _topluSmsService.GetSendersAsync(toplusms, HttpContext.RequestAborted);
            return Ok(s);
        }

        var senders = await _smsService.GetSendersAsync(null, HttpContext.RequestAborted);
        return Ok(senders);
    }

    [HttpGet("sms/account-info")]
    public async Task<IActionResult> GetSmsAccountInfo()
    {
        var toplusms = await _topluSmsService.GetActiveConfigAsync(null, HttpContext.RequestAborted);
        if (toplusms != null)
        {
            var infoToplu = await _topluSmsService.GetAccountInfoAsync(toplusms, HttpContext.RequestAborted);
            return Ok(infoToplu);
        }

        var info = await _smsService.GetAccountInfoAsync(null, HttpContext.RequestAborted);
        return Ok(info);
    }
}
