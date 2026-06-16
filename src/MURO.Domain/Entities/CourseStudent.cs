using System;

namespace MURO.Domain.Entities;

public class CourseStudent
{
    public Guid Id { get; set; }
    public Guid CourseId { get; set; }
    public Guid UserId { get; set; }
    public DateTime AssignedAt { get; set; } = DateTime.UtcNow;
    public DateTime? ExpiresAt { get; set; }

    // Navigation
    public Course Course { get; set; } = null!;
    public User User { get; set; } = null!;
}
