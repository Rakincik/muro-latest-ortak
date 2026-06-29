using Microsoft.EntityFrameworkCore;
using MURO.Application.DTOs.Media;
using MURO.Application.Interfaces;
using MURO.Domain.Entities;
using MURO.Infrastructure.Persistence;

namespace MURO.Infrastructure.Services;

public class MediaFolderService : IMediaFolderService
{
    private readonly MuroDbContext _context;
    private readonly IMediaService _mediaService;

    public MediaFolderService(MuroDbContext context, IMediaService mediaService)
    {
        _context = context;
        _mediaService = mediaService;
    }

    public async Task<List<MediaFolderDto>> GetFoldersAsync(Guid? parentFolderId = null, string? search = null, bool all = false)
    {
        if (all)
        {
            return await _context.MediaFolders
                .OrderBy(f => f.Name)
                .Select(f => new MediaFolderDto(
                    f.Id,
                    f.Name,
                    f.ParentFolderId,
                    f.CreatedAt,
                    f.SubFolders.Count,
                    f.MediaAssets.Count,
                    null
                ))
                .ToListAsync();
        }
        if (!string.IsNullOrEmpty(search))
        {
            var searchLower = search.ToLower();
            var matchedFolders = await _context.MediaFolders
                .Where(f => f.Name.ToLower().Contains(searchLower))
                .OrderBy(f => f.Name)
                .Select(f => new {
                    f.Id,
                    f.Name,
                    f.ParentFolderId,
                    f.CreatedAt,
                    SubFolderCount = f.SubFolders.Count,
                    MediaAssetCount = f.MediaAssets.Count
                })
                .ToListAsync();

            var allFoldersLookup = await _context.MediaFolders
                .Select(f => new { f.Id, f.Name, f.ParentFolderId })
                .ToDictionaryAsync(f => f.Id);

            var result = new List<MediaFolderDto>();
            foreach (var f in matchedFolders)
            {
                var pathList = new List<FolderMinDto>();
                var currentId = f.ParentFolderId;
                var visited = new HashSet<Guid>();
                while (currentId.HasValue && allFoldersLookup.TryGetValue(currentId.Value, out var parent))
                {
                    if (!visited.Add(parent.Id)) break;
                    pathList.Insert(0, new FolderMinDto(parent.Id, parent.Name));
                    currentId = parent.ParentFolderId;
                }
                pathList.Add(new FolderMinDto(f.Id, f.Name));

                result.Add(new MediaFolderDto(
                    f.Id,
                    f.Name,
                    f.ParentFolderId,
                    f.CreatedAt,
                    f.SubFolderCount,
                    f.MediaAssetCount,
                    pathList
                ));
            }

            return result;
        }

        var folders = await _context.MediaFolders
            .Where(f => f.ParentFolderId == parentFolderId)
            .OrderBy(f => f.Name)
            .Select(f => new MediaFolderDto(
                f.Id,
                f.Name,
                f.ParentFolderId,
                f.CreatedAt,
                f.SubFolders.Count,
                f.MediaAssets.Count,
                null
            ))
            .ToListAsync();

        return folders;
    }

    public async Task<MediaFolderDto> GetFolderByIdAsync(Guid folderId)
    {
        var folder = await _context.MediaFolders
            .Include(f => f.SubFolders)
            .Include(f => f.MediaAssets)
            .FirstOrDefaultAsync(f => f.Id == folderId);

        if (folder == null)
            throw new Exception("Folder not found");

        return new MediaFolderDto(
            folder.Id,
            folder.Name,
            folder.ParentFolderId,
            folder.CreatedAt,
            folder.SubFolders.Count,
            folder.MediaAssets.Count
        );
    }

    public async Task<MediaFolderDto> CreateFolderAsync(CreateMediaFolderRequest request)
    {
        var folder = new MediaFolder
        {
            Name = request.Name,
            ParentFolderId = request.ParentFolderId
        };

        _context.MediaFolders.Add(folder);
        await _context.SaveChangesAsync();

        return new MediaFolderDto(
            folder.Id,
            folder.Name,
            folder.ParentFolderId,
            folder.CreatedAt,
            0,
            0
        );
    }

    public async Task<MediaFolderDto> UpdateFolderAsync(Guid folderId, UpdateMediaFolderRequest request)
    {
        var folder = await _context.MediaFolders.FirstOrDefaultAsync(f => f.Id == folderId);
        
        if (folder == null)
            throw new Exception("Folder not found");

        folder.Name = request.Name;
        folder.ParentFolderId = request.ParentFolderId;

        await _context.SaveChangesAsync();

        return new MediaFolderDto(
            folder.Id,
            folder.Name,
            folder.ParentFolderId,
            folder.CreatedAt,
            _context.MediaFolders.Count(sf => sf.ParentFolderId == folder.Id),
            _context.MediaAssets.Count(ma => ma.FolderId == folder.Id)
        );
    }

    public async Task DeleteFolderAsync(Guid folderId, bool force = false)
    {
        var folder = await _context.MediaFolders
            .Include(f => f.SubFolders)
            .Include(f => f.MediaAssets)
            .FirstOrDefaultAsync(f => f.Id == folderId);

        if (folder == null)
            throw new Exception("Folder not found");

        if (!force && (folder.SubFolders.Any() || folder.MediaAssets.Any()))
            throw new Exception("NON_EMPTY_FOLDER"); // We will catch this exact message in the frontend

        if (force)
        {
            await DeleteFolderRecursiveAsync(folder);
        }
        else
        {
            _context.MediaFolders.Remove(folder);
            await _context.SaveChangesAsync();
        }
    }

    private async Task DeleteFolderRecursiveAsync(MediaFolder folder)
    {
        // First delete all media assets via IMediaService to ensure files are deleted from storage
        var assets = await _context.MediaAssets
            .Where(a => a.FolderId == folder.Id )
            .ToListAsync();
            
        foreach (var asset in assets)
        {
            await _mediaService.DeleteAssetAsync(asset.Id);
        }

        // Then recursively delete subfolders
        var subFolders = await _context.MediaFolders
            .Include(f => f.SubFolders)
            .Where(f => f.ParentFolderId == folder.Id )
            .ToListAsync();

        foreach (var subFolder in subFolders)
        {
            await DeleteFolderRecursiveAsync(subFolder);
        }

        _context.MediaFolders.Remove(folder);
        await _context.SaveChangesAsync();
    }

    public async Task<List<Guid>> GetAssignedCourseIdsAsync(Guid folderId)
    {
        var assetIds = await _context.MediaAssets
            .Where(ma => ma.FolderId == folderId)
            .Select(ma => ma.Id)
            .ToListAsync();

        if (!assetIds.Any()) return new List<Guid>();

        return await _context.CourseMedias
            .Where(cm => cm.MediaAssetId.HasValue && assetIds.Contains(cm.MediaAssetId.Value))
            .Select(cm => cm.CourseId)
            .Distinct()
            .ToListAsync();
    }
}
