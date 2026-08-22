import { api } from './core';

export interface IntegrationItem {
    id: string;
    providerKey: string;
    category: string;
    title: string;
    description: string | null;
    isEnabled: boolean;
    configJson: string | null;
    triggerSettingsJson?: string | null;
    lastTestedAt: string | null;
    testStatus: string | null;
    testMessage: string | null;
    updatedAt: string;
    updatedBy: string | null;
    isConfigured: boolean;
}

export interface VatanSmsConfig {
    apiId: string;
    apiKey: string;
    sender: string;
    messageType: "normal" | "turkce";
    messageContentType: "bilgi" | "ticari";
}

export interface TopluSmsConfig {
    apiKey: string;
    sender: string;
    messageType: "normal" | "turkce";
    messageContentType: "bilgi" | "ticari";
    addCancelLink: boolean;
}

export interface SmsAccountInfo {
    success: boolean;
    customerName?: string;
    balance?: string;
    senders: string[];
    message?: string;
}

export interface SmsSendResult {
    success: boolean;
    reportId?: string;
    status?: string;
    message?: string;
    rawResponse?: string;
}

export interface SmsTriggerSettings {
    liveLessonReminderEnabled: boolean;
    liveLessonReminderTemplate: string;
    liveLessonStartedEnabled: boolean;
    liveLessonStartedTemplate: string;
    welcomeStudentEnabled: boolean;
    welcomeStudentTemplate: string;
    recordingReadyEnabled: boolean;
    recordingReadyTemplate: string;
    newExamEnabled: boolean;
    newExamTemplate: string;
}

export interface SmsTargetItem {
    id: string;
    title: string;
    type: "course" | "group" | "package";
}

export interface SmsTargetsResponse {
    courses: SmsTargetItem[];
    groups: SmsTargetItem[];
    packages: SmsTargetItem[];
}

export interface SmsRecipientPreview {
    userId: string;
    fullName: string;
    phone: string;
    targetName: string;
    renderedMessage: string;
    isValidPhone: boolean;
}

export interface BulkSmsPreviewResult {
    totalRecipients: number;
    validPhonesCount: number;
    invalidPhonesCount: number;
    estimatedSmsUnits: number;
    recipients: SmsRecipientPreview[];
}

export interface BulkSmsExecutionResult {
    success: boolean;
    sentCount: number;
    failedCount: number;
    reportId?: string;
    message?: string;
}

export interface BulkSmsCampaignPayload {
    targetType: "course" | "group" | "package" | "all" | "custom";
    targetIds: string[];
    customPhones?: string[];
    messageTemplate: string;
    sender?: string;
    sendTime?: string;
}

export const adminIntegrationApi = {
    list: (token: string, tenantId: string) =>
        api<IntegrationItem[]>('/admin/integrations', { token, tenantId }),

    get: (token: string, tenantId: string, providerKey: string) =>
        api<IntegrationItem>(`/admin/integrations/${providerKey}`, { token, tenantId }),

    update: (token: string, tenantId: string, providerKey: string, data: { isEnabled: boolean; configJson?: string | null }) =>
        api<IntegrationItem>(`/admin/integrations/${providerKey}`, {
            method: 'PUT',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    test: (token: string, tenantId: string, providerKey: string, data: { configJson?: string | null; testPhone?: string | null }) =>
        api<SmsAccountInfo>(`/admin/integrations/${providerKey}/test`, {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    sendTestSms: (token: string, tenantId: string, data: { phone: string; message: string; sender?: string; isOtp?: boolean }) =>
        api<SmsSendResult>('/admin/integrations/sms/send-test', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    getSenders: (token: string, tenantId: string) =>
        api<string[]>('/admin/integrations/sms/senders', { token, tenantId }),

    getAccountInfo: (token: string, tenantId: string) =>
        api<SmsAccountInfo>('/admin/integrations/sms/account-info', { token, tenantId })
};

export const adminSmsCenterApi = {
    getTargets: (token: string, tenantId: string) =>
        api<SmsTargetsResponse>('/admin/sms/targets', { token, tenantId }),

    preview: (token: string, tenantId: string, data: BulkSmsCampaignPayload) =>
        api<BulkSmsPreviewResult>('/admin/sms/preview', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    sendBulk: (token: string, tenantId: string, data: BulkSmsCampaignPayload) =>
        api<BulkSmsExecutionResult>('/admin/sms/send-bulk', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    getTriggers: (token: string, tenantId: string) =>
        api<SmsTriggerSettings>('/admin/sms/triggers', { token, tenantId }),

    updateTriggers: (token: string, tenantId: string, data: SmsTriggerSettings) =>
        api<SmsTriggerSettings>('/admin/sms/triggers', {
            method: 'PUT',
            token,
            tenantId,
            body: JSON.stringify(data)
        })
};

export interface TenantApiKeyInfo {
    id: string;
    keyPrefix: string;
    fullKey?: string | null;
    name: string;
    scopes: string;
    isEnabled: boolean;
    lastUsedAt?: string | null;
    createdAt: string;
}

export interface ConnectApiLogItem {
    id: string;
    endpoint: string;
    httpMethod: string;
    ipAddress?: string | null;
    statusCode: number;
    requestBody?: string | null;
    responseBody?: string | null;
    durationMs: number;
    createdAt: string;
}

export interface ConnectEnrollResult {
    success: boolean;
    action: string;
    userId: string;
    username: string;
    email: string;
    phone: string;
    packageName?: string | null;
    generatedPassword?: string | null;
    message: string;
    magicLoginUrl?: string | null;
}

export interface ConnectPackageDto {
    id: string;
    name: string;
    code?: string | null;
    description?: string | null;
    price: number;
    durationDays: number;
    courseCount: number;
    courseTitles: string[];
}

export interface ConnectUnenrollResult {
    success: boolean;
    username: string;
    packageName?: string | null;
    message: string;
}

export interface ConnectDemoResult {
    success: boolean;
    userId: string;
    username: string;
    demoExpiresAt: string;
    message: string;
    magicLoginUrl?: string | null;
}

export const adminConnectApi = {
    getKey: (token: string, tenantId: string) =>
        api<TenantApiKeyInfo>('/admin/connect/key', { token, tenantId }),

    regenerateKey: (token: string, tenantId: string, name?: string) =>
        api<TenantApiKeyInfo>('/admin/connect/key/regenerate', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify({ name })
        }),

    getLogs: (token: string, tenantId: string, take: number = 50) =>
        api<ConnectApiLogItem[]>(`/admin/connect/logs?take=${take}`, { token, tenantId }),

    getPackages: (token: string, tenantId: string) =>
        api<ConnectPackageDto[]>('/admin/connect/packages', { token, tenantId }),

    testEnroll: (token: string, tenantId: string, data: any) =>
        api<ConnectEnrollResult>('/admin/connect/test-enroll', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    testDemo: (token: string, tenantId: string, data: any) =>
        api<ConnectDemoResult>('/admin/connect/test-demo', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        }),

    testUnenroll: (token: string, tenantId: string, data: any) =>
        api<ConnectUnenrollResult>('/admin/connect/test-unenroll', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        })
};

