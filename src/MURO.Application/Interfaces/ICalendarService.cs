using MURO.Application.DTOs;
using MURO.Application.DTOs.Calendar;

namespace MURO.Application.Interfaces;

public interface ICalendarService
{
    Task<List<CalendarEventDto>> GetEventsAsync(DateTime from, DateTime to, Guid? groupId, Guid? instructorId = null);
    Task<CalendarEventDto> GetEventByIdAsync(Guid eventId);
    Task<CalendarEventDto> CreateEventAsync(CreateCalendarEventRequest request, Guid? instructorId = null);
    Task<CalendarEventDto> UpdateEventAsync(Guid eventId, UpdateCalendarEventRequest request, Guid? instructorId = null);
    Task DeleteEventAsync(Guid eventId, Guid? instructorId = null);
}
