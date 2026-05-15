import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const tenantApi = {
    /** Public — no auth needed. Uses subdomain/header to resolve tenant. */
    getBranding: (tenantId?: string) =>
        api<TenantBrandingDto>('/tenant/branding', { tenantId: tenantId ?? '' }),

    /** Admin — get full tenant settings. */
    getSettings: (token: string, tenantId: string) =>
        api<Record<string, unknown>>('/tenant/settings', { token, tenantId }),

    /** Admin — update branding (logo, colors, name). */
    updateSettings: (token: string, tenantId: string, data: {
        name?: string; logoUrl?: string; faviconUrl?: string;
        primaryColor?: string; accentColor?: string; footerText?: string;
    }) =>
        api<Record<string, unknown>>('/tenant/settings', {
            method: 'PUT', token, tenantId, body: JSON.stringify(data),
        }),

    /** Check feature flag. */
    checkFeature: (token: string, tenantId: string, featureName: string) =>
        api<boolean>(`/tenant/features/${featureName}`, { token, tenantId }),
};







