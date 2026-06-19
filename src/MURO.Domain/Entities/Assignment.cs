using MURO.Domain.Common;

namespace MURO.Domain.Entities;

public class Assignment : ISoftDeletable
{
    public Guid Id { get; set; }
    public Guid CourseId { get; set; }

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Description { get; set; }
    public DateTime DueDate { get; set; }
    public string? FileUrl { get; set; }
    public int MaxScore { get; set; } = 100;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public Course Course { get; set; } = null!;
    public ICollection<AssignmentSubmission> Submissions { get; set; } = new List<AssignmentSubmission>();
}
