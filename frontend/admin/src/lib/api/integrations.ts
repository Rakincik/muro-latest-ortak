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
