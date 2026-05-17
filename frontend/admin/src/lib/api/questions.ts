import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const questionApi = {
    list: (token: string, tenantId: string, params?: { page?: number; pageSize?: number; status?: string; instructorId?: string }) => {
        const qs = new URLSearchParams();
        if (params?.page) qs.set('page', String(params.page));
        if (params?.pageSize) qs.set('pageSize', String(params.pageSize));
        if (params?.status) qs.set('status', params.status);
        if (params?.instructorId) qs.set('instructorId', params.instructorId);
        return api<{ items: QuestionDto[]; totalCount: number; page: number; pageSize: number; totalPages: number }>("/questions?" + qs.toString(), { token, tenantId });
    },

    getById: (token: string, tenantId: string, id: string) =>
        api<QuestionDto>("/questions/" + id, { token, tenantId }),

    ask: (token: string, tenantId: string, data: CreateQuestionRequest) =>
        api<QuestionDto>('/questions', { method: 'POST', token, tenantId, body: JSON.stringify(data) }),

    answer: (token: string, tenantId: string, id: string, answerText: string) =>
        api<QuestionDto>("/questions/" + id + "/answer", { method: 'PUT', token, tenantId, body: JSON.stringify({ answer: answerText }) }),

    updateNote: (token: string, tenantId: string, id: string, note: string | null) =>
        api<QuestionDto>("/questions/" + id + "/note", { method: 'PATCH', token, tenantId, body: JSON.stringify({ note }) }),
        
    deleteQuestion: (token: string, tenantId: string, id: string) =>
        api<void>("/questions/" + id, { method: 'DELETE', token, tenantId }),
        
    deleteAnswer: (token: string, tenantId: string, id: string) =>
        api<QuestionDto>("/questions/" + id + "/answer", { method: 'DELETE', token, tenantId }),
};
