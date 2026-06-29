using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs.Media;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

[ApiController]
[Authorize] // Allow all authenticated users (including students)
[Route("api/v1/courses/{courseId}/media")]
public class CourseMediaController : ControllerBase
{
    private readonly ICourseMediaService _courseMediaService;

    public CourseMediaController(ICourseMediaService courseMediaService)
    {
        _courseMediaService = courseMediaService;
    }



    [HttpGet]
    public async Task<IActionResult> GetCourseMedias(Guid courseId)
    {
        var medias = await _courseMediaService.GetCourseMediasAsync(courseId);
        return Ok(medias);
    }

    [HttpPost("assign")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> AssignMedia(Guid courseId, [FromBody] AssignMediaToCourseRequest request)
    {
        var result = await _courseMediaService.AssignMediaAsync(courseId, request);
        return Ok(result);
    }

    [HttpPost("assign-exam")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> AssignExam(Guid courseId, [FromBody] AssignExamToCourseRequest request)
    {
        var result = await _courseMediaService.AssignExamAsync(courseId, request);
        return Ok(result);
    }

    [HttpPost("bulk-assign-folder")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> BulkAssignFolder(Guid courseId, [FromBody] BulkAssignFolderToCourseRequest request)
    {
        await _courseMediaService.BulkAssignFolderAsync(courseId, request);
        return Ok();
    }

    [HttpDelete("{mediaAssetId}")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> RemoveMedia(Guid courseId, Guid mediaAssetId)
    {
        await _courseMediaService.RemoveMediaAsync(courseId, mediaAssetId);
        return NoContent();
    }

    [HttpDelete("item/{courseMediaId}")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> RemoveItem(Guid courseId, Guid courseMediaId)
    {
        await _courseMediaService.RemoveItemAsync(courseId, courseMediaId);
        return NoContent();
    }

    [HttpPost("reorder")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> ReorderMedias(Guid courseId, [FromBody] ReorderCourseMediaRequest request)
    {
        await _courseMediaService.ReorderMediasAsync(courseId, request);
        return Ok();
    }
    [HttpPut("{courseMediaId:guid}/title")]
    [Authorize(Roles = "SuperAdmin,Admin,Instructor")]
    public async Task<IActionResult> UpdateTitle(Guid courseId, Guid courseMediaId, [FromBody] UpdateCourseMediaTitleRequest request)
    {
        await _courseMediaService.UpdateCustomTitleAsync(courseId, courseMediaId, request.Title);
        return NoContent();
    }
}
