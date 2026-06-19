using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MURO.Domain.Entities;

public class StudentExamDraft
{
    [Key]
    public Guid Id { get; set; }

    public Guid ExamId { get; set; }
    public Guid UserId { get; set; }

    [Required]
    [Column(TypeName = "jsonb")]
    public string AnswersJson { get; set; } = "{}";

    public DateTime LastUpdatedAt { get; set; } = DateTime.UtcNow;

    // Navigation
    public virtual Exam? Exam { get; set; }
    public virtual User? User { get; set; }
}
