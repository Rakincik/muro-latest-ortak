import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';

export const userApi = {
    list: (token: string, tenantId: string, params?: { page?: number; pageSize?: number; search?: string; role?: string }) => {
        const qs = new URLSearchParams();
        if (params?.page) qs.set('page', String(params.page));
        if (params?.pageSize) qs.set('pageSize', String(params.pageSize));
        if (params?.search) qs.set('search', params.search);
        if (params?.role) qs.set('role', params.role);
        return api<PagedUsersResult>(`/users?${qs}`, { token, tenantId });
    },

    get: (token: string, tenantId: string, id: string) =>
        api<UserDto>(`/users/${id}`, { token, tenantId }),

    create: (token: string, tenantId: string, data: CreateUserRequest) =>
        api<UserDto>('/users', { method: 'POST', token, tenantId, body: JSON.stringify(data) }),

    update: (token: string, tenantId: string, id: string, data: Partial<CreateUserRequest> & { isActive?: boolean }) =>
        api<UserDto>(`/users/${id}`, { method: 'PUT', token, tenantId, body: JSON.stringify(data) }),

    delete: (token: string, tenantId: string, id: string) =>
        api<void>(`/users/${id}/delete`, { method: 'POST', token, tenantId }),

    bulkDelete: (token: string, tenantId: string, ids: string[]) =>
        api<void>('/users/bulk-delete', { method: 'POST', token, tenantId, body: JSON.stringify(ids) }),

    exportCSV: async (token: string, tenantId: string, role?: string) => {
        const params = role ? `?role=${role}` : '';
        const res = await fetch(`${API_URL}/users/export${params}`, {
            headers: { Authorization: `Bearer ${token}`, 'X-Tenant-Id': tenantId },
        });
        if (!res.ok) throw new Error('Export başarısız');
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url; a.download = `kullanicilar_${new Date().toISOString().slice(0, 10)}.csv`;
        a.click(); URL.revokeObjectURL(url);
    },

    exportTemplate: async (token: string, tenantId: string) => {
        const res = await fetch(`${API_URL}/users/export-template`, {
            headers: { Authorization: `Bearer ${token}`, 'X-Tenant-Id': tenantId },
        });
        if (!res.ok) throw new Error('Şablon export başarısız');
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url; a.download = `ogrenci_sablon.xlsx`;
        a.click(); URL.revokeObjectURL(url);
    },

    exportExcel: async (token: string, tenantId: string, userIds: string[]) => {
        const res = await fetch(`${API_URL}/users/export-excel`, {
            method: 'POST',
            headers: { Authorization: `Bearer ${token}`, 'X-Tenant-Id': tenantId, 'Content-Type': 'application/json' },
            body: JSON.stringify({ userIds })
        });
        if (!res.ok) throw new Error('Excel export başarısız');
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url; a.download = `kullanicilar_${new Date().toISOString().slice(0, 10)}.xlsx`;
        a.click(); URL.revokeObjectURL(url);
    },

    importExcel: async (token: string, tenantId: string, file: File, groupId?: string): Promise<{ message: string; importedCount: number; skippedCount: number; details: { firstName: string, lastName: string, email: string, status: string, reason: string }[] }> => {
        const formData = new FormData();
        formData.append('file', file);
        const url = groupId ? `${API_URL}/users/import-excel?groupId=${groupId}` : `${API_URL}/users/import-excel`;
        const res = await fetch(url, {
            method: 'POST',
            headers: { Authorization: `Bearer ${token}`, 'X-Tenant-Id': tenantId },
            body: formData,
        });
        if (!res.ok) throw new Error(await res.text());
        return res.json();
    },

    bulkCreate: (token: string, tenantId: string, users: CreateUserRequest[]) =>
        api<{ id: string; firstName: string; lastName: string; email: string }[]>('/users/bulk', {
            method: 'POST', token, tenantId,
            body: JSON.stringify({ users }),
        }),
        
    getDirectCourses: (token: string, tenantId: string, userId: string) =>
        api<CourseListDto[]>(`/users/${userId}/courses/direct`, { token, tenantId }),
};

// ── Question (Soru-Cevap) API ─────────────────────────────────────────────



