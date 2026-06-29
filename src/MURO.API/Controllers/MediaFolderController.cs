using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MURO.Application.DTOs.Media;
using MURO.Application.Interfaces;

namespace MURO.API.Controllers;

[ApiController]
[Route("api/v1/media-folders")]
[Authorize(Roles = "SuperAdmin,Admin,Instructor")]
public class MediaFolderController : ControllerBase
{
    private readonly IMediaFolderService _folderService;
    
    public MediaFolderController(IMediaFolderService folderService)
    {
        _folderService = folderService;
            }



    [HttpGet]
    public async Task<IActionResult> GetFolders([FromQuery] Guid? parentFolderId = null, [FromQuery] string? search = null, [FromQuery] bool all = false)
    {
        var folders = await _folderService.GetFoldersAsync(parentFolderId, search, all);
        return Ok(folders);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetFolder(Guid id)
    {
        var folder = await _folderService.GetFolderByIdAsync(id);
        return Ok(folder);
    }

    [HttpPost]
    public async Task<IActionResult> CreateFolder([FromBody] CreateMediaFolderRequest request)
    {
        var folder = await _folderService.CreateFolderAsync(request);
        return Ok(folder);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateFolder(Guid id, [FromBody] UpdateMediaFolderRequest request)
    {
        var folder = await _folderService.UpdateFolderAsync(id, request);
        return Ok(folder);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteFolder(Guid id, [FromQuery] bool force = false)
    {
        try
        {
            await _folderService.DeleteFolderAsync(id, force);
            return NoContent();
        }
        catch (Exception ex) when (ex.Message == "NON_EMPTY_FOLDER")
        {
            return BadRequest(new { error = "NON_EMPTY_FOLDER" });
        }
    }

    [HttpGet("{id}/courses")]
    public async Task<IActionResult> GetFolderCourses(Guid id)
    {
        var courses = await _folderService.GetAssignedCourseIdsAsync(id);
        return Ok(courses);
    }
}
