using MURO.Application.DTOs.Attendance;

namespace MURO.Application.Interfaces;

public interface ISessionAttendanceService
{
    Task<AttendanceSummaryDto> GetAttendanceBySessionAsync(Guid sessionId);
    Task<List<MyAttendanceDto>> GetMyAttendanceHistoryAsync(Guid userId);
    Task<SessionAttendanceDto> RecordJoinAsync(Guid sessionId, Guid userId);
    Task<SessionAttendanceDto> RecordLeaveAsync(Guid sessionId, Guid userId);
}
