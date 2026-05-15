import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const calendarApi = {
    list: (token: string, tenantId: string, params?: { year?: number; month?: number }) => {
        const qs = new URLSearchParams();
        if (params?.year) qs.set('year', String(params.year));
        if (params?.month) qs.set('month', String(params.month));
        return api<CalendarEventDto[]>(`/calendar?${qs}`, { token, tenantId });
    },
    create: (token: string, tenantId: string, data: CreateCalendarEventRequest) =>
        api<CalendarEventDto>('/calendar', { method: 'POST', token, tenantId, body: JSON.stringify(data) }),
    update: (token: string, tenantId: string, id: string, data: Partial<CreateCalendarEventRequest>) =>
        api<CalendarEventDto>(`/calendar/${id}`, { method: 'PUT', token, tenantId, body: JSON.stringify(data) }),
    delete: (token: string, tenantId: string, id: string) =>
        api<void>(`/calendar/${id}`, { method: 'DELETE', token, tenantId }),
};

// ── Support (Ticket) Types & API ─────────────────────────────────────────────





