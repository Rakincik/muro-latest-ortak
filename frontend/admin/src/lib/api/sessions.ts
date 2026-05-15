import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const sessionApi = {
    create: (token: string, tenantId: string, courseId: string, data: {
        title: string; description?: string; order?: number; videoUrl?: string;
        durationMinutes?: number; isFree?: boolean; scheduledStart?: string; scheduledEnd?: string; recordingEnabled?: boolean;
    }) =>
        api<any>(`/courses/${courseId}/sessions`, { method: "POST", token, tenantId, body: JSON.stringify(data) }),
    start: (token: string, tenantId: string, courseId: string, sessionId: string) =>
        api<SessionStartResult>(
            `/courses/${courseId}/sessions/${sessionId}/start`,
            { method: "POST", token, tenantId }
        ),
    join: (token: string, tenantId: string, courseId: string, sessionId: string) =>
        api<{ sessionId: string; joinUrl: string; isModerator: boolean }>(
            `/courses/${courseId}/sessions/${sessionId}/join`,
            { method: "POST", token, tenantId }
        ),
    end: (token: string, tenantId: string, courseId: string, sessionId: string) =>
        api<{ message: string }>(
            `/courses/${courseId}/sessions/${sessionId}/end`,
            { method: "POST", token, tenantId }
        ),
    getAttendance: (token: string, tenantId: string, sessionId: string) =>
        api<{
            sessionId: string;
            sessionTitle: string;
            totalAssigned: number;
            totalPresent: number;
            attendanceRate: number;
            attendees: {
                userId: string;
                userFullName: string;
                joinedAt: string;
                leftAt: string | null;
                durationMinutes: number | null;
                isPresent: boolean;
            }[];
        }>(`/attendance/sessions/${sessionId}`, { token, tenantId }),
};

// ── Recording Types ──



