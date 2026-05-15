import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const assignmentApi = {
    list: (token: string, tenantId: string, params?: { courseId?: string, search?: string, page?: number, pageSize?: number }) => {
        const q = new URLSearchParams();
        if (params?.courseId) q.append("courseId", params.courseId);
        if (params?.search) q.append("search", params.search);
        if (params?.page) q.append("page", params.page.toString());
        if (params?.pageSize) q.append("pageSize", params.pageSize.toString());
        return api<{ items: AssignmentListDto[], totalCount: number }>(`/assignments?${q}`, { token, tenantId });
    },
    getById: (token: string, tenantId: string, id: string) =>
        api<AssignmentDetailDto>(`/assignments/${id}`, { token, tenantId }),
    create: (token: string, tenantId: string, data: { title: string; description?: string; courseId: string; dueDate: string; maxScore: number; fileUrl?: string }) =>
        api<AssignmentListDto>(`/assignments`, { method: "POST", token, tenantId, body: JSON.stringify(data) }),
    update: (token: string, tenantId: string, id: string, data: Partial<{ title: string; description?: string; courseId: string; dueDate: string; maxScore: number; fileUrl?: string }>) =>
        api<AssignmentListDto>(`/assignments/${id}`, { method: "PUT", token, tenantId, body: JSON.stringify(data) }),
    delete: (token: string, tenantId: string, id: string) =>
        api<void>(`/assignments/${id}`, { method: "DELETE", token, tenantId }),
    gradeSubmission: (token: string, tenantId: string, assignmentId: string, submissionId: string, data: { score: number; feedback?: string }) =>
        api<SubmissionDto>(`/assignments/${assignmentId}/submissions/${submissionId}/grade`, { method: "POST", token, tenantId, body: JSON.stringify(data) })
};

