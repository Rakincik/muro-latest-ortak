import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const packageApi = {
    list: (token: string, tenantId: string) =>
        api<PackageDto[]>('/packages', { token, tenantId }),

    get: (token: string, tenantId: string, id: string) =>
        api<PackageDto>(`/packages/${id}`, { token, tenantId }),

    create: (token: string, tenantId: string, data: CreatePackageRequest) =>
        api<PackageDto>('/packages', { method: 'POST', token, tenantId, body: JSON.stringify(data) }),

    update: (token: string, tenantId: string, id: string, data: Partial<CreatePackageRequest> & { isActive?: boolean }) =>
        api<PackageDto>(`/packages/${id}`, { method: 'PUT', token, tenantId, body: JSON.stringify(data) }),

    delete: (token: string, tenantId: string, id: string) =>
        api<void>(`/packages/${id}`, { method: 'DELETE', token, tenantId }),

    activateForUser: (token: string, tenantId: string, packageId: string, userId: string, manualExpiresAt?: string) =>
        api<UserPackageDto>(`/packages/${packageId}/activate`, {
            method: 'POST', token, tenantId,
            body: JSON.stringify({ userId, manualExpiresAt }),
        }),

    getUserPackages: (token: string, tenantId: string, userId: string) =>
        api<UserPackageDto[]>(`/packages/user/${userId}`, { token, tenantId }),

    extend: (token: string, tenantId: string, userPackageId: string, extraDays: number) =>
        api<UserPackageDto>(`/packages/user-packages/${userPackageId}/extend`, {
            method: 'POST', token, tenantId,
            body: JSON.stringify({ extraDays }),
        }),

    cancel: (token: string, tenantId: string, userPackageId: string) =>
        api<{ success: boolean }>(`/packages/user-packages/${userPackageId}/cancel`, {
            method: 'POST', token, tenantId,
        }),

    webhookInfo: (token: string, tenantId: string) =>
        api<WebhookInfo>('/packages/webhook-info', { token, tenantId }),
};

// ── User API ──────────────────────────────────────────────────────────────




