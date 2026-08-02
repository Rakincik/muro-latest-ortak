using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

[ApiController]
[Route("api/v1/users")]
[Authorize]
public class MeController : ControllerBase
{
    private readonly IUserService _userService;

    public MeController(IUserService userService)
    {
        _userService = userService;
    }

    [HttpPut("me/password")]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequest request)
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
            return Unauthorized(new { error = "Kullanıcı bulunamadı veya oturumunuz geçersiz." });

        try
        {
            await _userService.ChangePasswordAsync(userId, request.CurrentPassword, request.NewPassword);
            return Ok(new { message = "Şifre başarıyla güncellendi." });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }
}

public record ChangePasswordRequest(
    string CurrentPassword,
    string NewPassword
);
