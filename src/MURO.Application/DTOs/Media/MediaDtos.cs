namespace MURO.Application.DTOs.Media;

public record MediaAssetDto(
    Guid Id, string Title, string? FilePath, string? HlsPath,
    string? ThumbnailPath, int? DurationSeconds, string Status,
    Guid? CourseId, string? CourseName, Guid? FolderId, DateTime CreatedAt, string? Tags
);

public record CreateMediaAssetRequest(
    string Title, string? FilePath, int? DurationSeconds, Guid? CourseId, Guid? FolderId, string? Tags
);

public record UpdateMediaAssetRequest(
    string? Title, string? HlsPath, string? ThumbnailPath,
    int? DurationSeconds, string? Status, Guid? FolderId, string? Tags
);

// ─── Virtual Folders ────────────────────────────────────────────────────────

public record FolderMinDto(Guid Id, string Name);

public record MediaFolderDto(
    Guid Id, string Name, Guid? ParentFolderId, DateTime CreatedAt,
    int SubFolderCount, int MediaAssetCount, System.Collections.Generic.List<FolderMinDto>? Path = null
);

public record CreateMediaFolderRequest(string Name, Guid? ParentFolderId);
public record UpdateMediaFolderRequest(string Name, Guid? ParentFolderId);

// ─── Course Media Assignment ────────────────────────────────────────────────

public record CourseMediaDto(
    Guid Id, Guid CourseId, Guid? MediaAssetId, int OrderIndex,
    MediaAssetDto? MediaAsset, Guid? ExamId, string? ExamTitle,
    Guid? SessionId, string? SessionTitle, string Type,
    string? CustomTitle
);

public class AssignMediaToCourseRequest { public Guid MediaAssetId { get; set; } }
public class AssignExamToCourseRequest { public Guid ExamId { get; set; } }
public class BulkAssignFolderToCourseRequest { public Guid FolderId { get; set; } }
public class ReorderCourseMediaRequest { public List<Guid> CourseMediaIds { get; set; } = new(); }
public class UpdateCourseMediaTitleRequest { public string Title { get; set; } = string.Empty; }

public record VideoProgressDto(
    Guid Id, Guid MediaAssetId, string MediaTitle,
    int WatchedSeconds, int TotalSeconds, int LastPosition,
    double PercentComplete, DateTime? CompletedAt, DateTime UpdatedAt
);

public record UpdateVideoProgressRequest(
    int WatchedSeconds, int TotalSeconds, int LastPosition
);

public record PodcastDto(
    Guid Id, string Title, string? AudioUrl, int? DurationSeconds,
    string Status, Guid? CourseId, string? CourseName, DateTime CreatedAt
);

public record CreatePodcastRequest(string Title, string? AudioUrl, Guid? CourseId);
