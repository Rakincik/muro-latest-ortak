import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const supportApi = {
    list: (token: string, tenantId: string, params?: { status?: string; page?: number; pageSize?: number }) => {
        const qs = new URLSearchParams();
        if (params?.status) qs.set('status', params.status);
        if (params?.page) qs.set('page', String(params.page));
        if (params?.pageSize) qs.set('pageSize', String(params.pageSize));
        return api<PagedResult<TicketDto>>(`/support/tickets?${qs}`, { token, tenantId });
    },
    get: (token: string, tenantId: string, id: string) =>
        api<TicketDto>(`/support/tickets/${id}`, { token, tenantId }),
    reply: (token: string, tenantId: string, ticketId: string, message: string) =>
        api<TicketReplyDto>(`/support/tickets/${ticketId}/reply`, { method: 'POST', token, tenantId, body: JSON.stringify({ body: message }) }),
    updateStatus: (token: string, tenantId: string, ticketId: string, status: string) =>
        api<TicketDto>(`/support/tickets/${ticketId}/status`, { method: 'PUT', token, tenantId, body: JSON.stringify({ status }) }),
    delete: (token: string, tenantId: string, id: string) =>
        api<void>(`/support/tickets/${id}`, { method: 'DELETE', token, tenantId }),
};

// ── Analytics Admin Dashboard Types ──────────────────────────────────────────
