import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const examApi = {
    list: (token: string, tenantId: string, params?: { page?: number; pageSize?: number; search?: string; examType?: string; status?: string }) => {
        const qs = new URLSearchParams();
        if (params?.page) qs.set("page", String(params.page));
        if (params?.pageSize) qs.set("pageSize", String(params.pageSize));
        if (params?.search) qs.set("search", params.search);
        if (params?.examType) qs.set("examType", params.examType);
        if (params?.status) qs.set("status", params.status);
        return api<PagedResult<ExamListDto>>(`/exams?${qs}`, { token, tenantId });
    },

    getById: (token: string, tenantId: string, id: string) =>
        api<ExamDetailDto>(`/exams/${id}`, { token, tenantId }),

    create: (token: string, tenantId: string, data: {
        title: string; description?: string; examType: string; questionCount: number;
        optionCount: number; durationMinutes?: number; startDate?: string; endDate?: string;
        showResults: boolean; wrongPenaltyWeight?: number; resultMode?: string;
        resultPublishDate?: string; questionWeights?: Record<number, number>; sectionsJson?: string;
        maxScore?: number; baseScore?: number; virtualParticipantCount?: number; digitalQuestionsJson?: string;
    }) =>
        api<ExamListDto>("/exams", { method: "POST", token, tenantId, body: JSON.stringify(data) }),

    update: (token: string, tenantId: string, id: string, data: Record<string, unknown>) =>
        api<ExamListDto>(`/exams/${id}`, { method: "PUT", token, tenantId, body: JSON.stringify(data) }),

    delete: (token: string, tenantId: string, id: string) =>
        api(`/exams/${id}`, { method: "DELETE", token, tenantId }),

    updateAnswerKey: (token: string, tenantId: string, id: string, answerKey: Record<number, string>) =>
        api<ExamDetailDto>(`/exams/${id}/answer-key`, { method: "PUT", token, tenantId, body: JSON.stringify({ answerKey }) }),

    updateStatus: (token: string, tenantId: string, id: string, status: string) =>
        api<ExamListDto>(`/exams/${id}/status`, { method: "PUT", token, tenantId, body: JSON.stringify({ status }) }),

    updatePdf: (token: string, tenantId: string, id: string, data: { pdfUrl?: string; solutionPdfUrl?: string }) =>
        api<ExamDetailDto>(`/exams/${id}/pdf`, { method: "PUT", token, tenantId, body: JSON.stringify(data) }),

    assign: (token: string, tenantId: string, examId: string, data: { targetType: string; targetId: string; startsAt?: string; endsAt?: string }) =>
        api<ExamAssignmentDto>(`/exams/${examId}/assign`, { method: "POST", token, tenantId, body: JSON.stringify(data) }),

    removeAssignment: (token: string, tenantId: string, examId: string, assignmentId: string) =>
        api(`/exams/${examId}/assign/${assignmentId}`, { method: "DELETE", token, tenantId }),

    getResults: (token: string, tenantId: string, examId: string) =>
        api<ExamResultSummaryDto>(`/exams/${examId}/results`, { token, tenantId }),

    overallSummary: (token: string, tenantId: string) =>
        api<ExamOverallSummaryDto>(`/exams/results/summary`, { token, tenantId }),
};





// ── Assignment Types ──



// ── Analytics Types ──









// ── Analytics API ──



