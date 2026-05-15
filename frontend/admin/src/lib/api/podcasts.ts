import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const podcastApi = {
    list: (token: string, tenantId: string, params?: { page?: number; pageSize?: number; courseId?: string }) => {
        const qs = new URLSearchParams();
        if (params?.page) qs.set("page", String(params.page));
        if (params?.pageSize) qs.set("pageSize", String(params.pageSize));
        if (params?.courseId) qs.set("courseId", params.courseId);
        return api<PagedResult<PodcastDto>>(`/podcasts?${qs}`, { token, tenantId });
    },

    generate: (token: string, tenantId: string, data: GeneratePodcastRequest) =>
        api<PodcastDto>("/podcasts/generate", {
            method: "POST", token, tenantId, body: JSON.stringify(data),
        }),

    delete: (token: string, tenantId: string, id: string) =>
        api<void>(`/podcasts/${id}`, { method: "DELETE", token, tenantId }),

    audioUrl: (id: string) =>
        `${API_URL}/podcasts/${id}/audio`,
};

// ── Groups API ────────────────────────────────────────────────────────────────







