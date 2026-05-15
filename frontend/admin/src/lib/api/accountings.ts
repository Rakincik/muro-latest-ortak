import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const accountingApi = {
    summary: (token: string, tenantId: string, params?: { from?: string; to?: string }) => {
        const qs = new URLSearchParams();
        if (params?.from) qs.set('from', params.from);
        if (params?.to) qs.set('to', params.to);
        const q = qs.toString();
        return api<AccountingSummaryDto>(`/accounting/summary${q ? '?' + q : ''}`, { token, tenantId });
    },

    transactions: (token: string, tenantId: string, params?: Record<string, string>) => {
        const q = params ? "?" + new URLSearchParams(params).toString() : "";
        return api<TransactionDto[]>(`/accounting/transactions${q}`, { token, tenantId });
    },

    createTransaction: (token: string, tenantId: string, body: CreateTransactionRequest) =>
        api<TransactionDto>(`/accounting/transactions`, {
            method: "POST", token, tenantId, body: JSON.stringify(body),
        }),

    updateTransaction: (token: string, tenantId: string, id: string, body: Partial<CreateTransactionRequest>) =>
        api<TransactionDto>(`/accounting/transactions/${id}`, {
            method: "PUT", token, tenantId, body: JSON.stringify(body),
        }),

    deleteTransaction: (token: string, tenantId: string, id: string) =>
        api<void>(`/accounting/transactions/${id}`, { method: "DELETE", token, tenantId }),

    plans: (token: string, tenantId: string) =>
        api<PlanDto[]>(`/accounting/plans`, { token, tenantId }),

    createPlan: (token: string, tenantId: string, body: Omit<PlanDto, "id" | "isActive" | "transactionCount">) =>
        api<PlanDto>(`/accounting/plans`, { method: "POST", token, tenantId, body: JSON.stringify(body) }),

    updatePlan: (token: string, tenantId: string, id: string, body: Partial<Omit<PlanDto, "id" | "transactionCount">>) =>
        api<PlanDto>(`/accounting/plans/${id}`, { method: "PUT", token, tenantId, body: JSON.stringify(body) }),

    deletePlan: (token: string, tenantId: string, id: string) =>
        api<void>(`/accounting/plans/${id}`, { method: "DELETE", token, tenantId }),
};

// ── Podcast Types ─────────────────────────────────────────────────────────────





