import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const groupsApi = {
    list: (token: string, tenantId: string, params?: { pageSize?: number }) => {
        const qs = new URLSearchParams();
        if (params?.pageSize) qs.set('pageSize', String(params.pageSize));
        return api<PagedResult<GroupListDto>>(`/groups?${qs}`, { token, tenantId });
    },
    get: (token: string, tenantId: string, id: string) =>
        api<GroupDetailDto>(`/groups/${id}`, { token, tenantId }),
    create: async (token: string, tenantId: string, data: { name: string; description?: string; parentGroupId?: string; color?: string; educationType?: string; expirationDate?: string }) => {
        const res = await api<GroupListDto>('/groups', { method: 'POST', token, tenantId, body: JSON.stringify(data) });
        invalidateCacheByPrefix('groups:');
        return res;
    },
    update: async (token: string, tenantId: string, id: string, data: { name?: string; description?: string; color?: string; educationType?: string; expirationDate?: string }) => {
        const res = await api<GroupListDto>(`/groups/${id}`, { method: 'PUT', token, tenantId, body: JSON.stringify(data) });
        invalidateCacheByPrefix('groups:');
        return res;
    },
    delete: async (token: string, tenantId: string, id: string) => {
        await api<void>(`/groups/${id}`, { method: 'DELETE', token, tenantId });
        invalidateCacheByPrefix('groups:');
    },
    addMembers: async (token: string, tenantId: string, id: string, userIds: string[]) => {
        await api<void>(`/groups/${id}/members`, { method: 'POST', token, tenantId, body: JSON.stringify({ userIds }) });
        invalidateCacheByPrefix('groups:');
    },
    removeMember: async (token: string, tenantId: string, id: string, userId: string) => {
        await api<void>(`/groups/${id}/members/${userId}`, { method: 'DELETE', token, tenantId });
        invalidateCacheByPrefix('groups:');
    },
    moveMembers: async (token: string, tenantId: string, fromGroupId: string, toGroupId: string, userIds: string[]) => {
        await api<void>(`/groups/${fromGroupId}/members/move`, { method: 'POST', token, tenantId, body: JSON.stringify({ toGroupId, userIds }) });
        invalidateCacheByPrefix('groups:');
    },
    assignCourse: async (token: string, tenantId: string, groupId: string, courseId: string, mode: string) => {
        await api<void>(`/courses/${courseId}/groups`, { method: 'POST', token, tenantId, body: JSON.stringify({ groupId, mode }) });
        invalidateCacheByPrefix('groups:');
        invalidateCacheByPrefix('courses:');
    },
    removeCourse: async (token: string, tenantId: string, groupId: string, courseId: string) => {
        await api<void>(`/courses/${courseId}/groups/${groupId}`, { method: 'DELETE', token, tenantId });
        invalidateCacheByPrefix('groups:');
        invalidateCacheByPrefix('courses:');
    },
    forceDelete: async (token: string, tenantId: string, id: string) => {
        await api<void>(`/groups/${id}/force`, { method: 'DELETE', token, tenantId });
        invalidateCacheByPrefix('groups:');
        invalidateCacheByPrefix('users:');
    },
    clone: async (token: string, tenantId: string, id: string, newName: string, copyMembers: boolean, copyCourses: boolean) => {
        const qs = new URLSearchParams({ newName, copyMembers: String(copyMembers), copyCourses: String(copyCourses) });
        const res = await api<GroupListDto>(`/groups/${id}/clone?${qs}`, { method: 'POST', token, tenantId });
        invalidateCacheByPrefix('groups:');
        if (copyMembers) invalidateCacheByPrefix('users:');
        return res;
    },
};

// ── Calendar Types & API ─────────────────────────────────────────────────────







