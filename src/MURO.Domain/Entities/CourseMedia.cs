using System;

namespace MURO.Domain.Entities;

public class CourseMedia
{
    public Guid Id { get; set; }
    public Guid CourseId { get; set; }
    public Guid? MediaAssetId { get; set; }
    public Guid? ExamId { get; set; }
    public Guid? SessionId { get; set; }
    public int OrderIndex { get; set; }
    public string? CustomTitle { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public Course Course { get; set; } = null!;
    public MediaAsset? MediaAsset { get; set; }
    public Exam? Exam { get; set; }
    public Session? Session { get; set; }
}
