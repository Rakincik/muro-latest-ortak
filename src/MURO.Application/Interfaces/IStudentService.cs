using MURO.Application.DTOs.Calendar;
using MURO.Application.DTOs.Analytics;

namespace MURO.Application.Interfaces;

public interface IStudentService
{
    /// <summary>
    /// Gets the upcoming and past live sessions for the student within a date range as calendar events.
    /// </summary>
    Task<List<CalendarEventDto>> GetCalendarEventsAsync(Guid userId, DateTime from, DateTime to);

    /// <summary>
    /// Gets the active group memberships for a student.
    /// </summary>
    Task<List<StudentGroupDto>> GetActiveGroupsAsync(Guid userId);
}
