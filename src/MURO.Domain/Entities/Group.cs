using MURO.Domain.Common;
using MURO.Domain.Enums;

namespace MURO.Domain.Entities;

public class Group : ISoftDeletable
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;

    public bool IsDeleted { get; set; }
    public DateTime? DeletedAt { get; set; }
    public string? Description { get; set; }
    public string? Color { get; set; }          // hex: #6366f1
    public string? EducationType { get; set; }   // Canlı, Offline, Kamp, Sınav, Hibrit, Demo
    public DateTime? ExpirationDate { get; set; } // Grubun son kullanma tarihi
    public Guid? ParentId { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public Group? Parent { get; set; }
    public ICollection<Group> Children { get; set; } = new List<Group>();
    public ICollection<GroupMember> Members { get; set; } = new List<GroupMember>();
    public ICollection<CourseGroup> CourseGroups { get; set; } = new List<CourseGroup>();
    public ICollection<Announcement> Announcements { get; set; } = new List<Announcement>();
    public ICollection<CalendarEvent> CalendarEvents { get; set; } = new List<CalendarEvent>();
}
