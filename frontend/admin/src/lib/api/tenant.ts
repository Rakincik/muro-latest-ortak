import { api } from './core';
import { TenantBrandingDto } from './types';

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

    /** SuperAdmin — get dynamic branding. */
    getAdminBranding: (token: string, tenantId: string) =>
        api<{
            id: string;
            tenantName: string;
            logoUrl: string | null;
            faviconUrl: string | null;
            primaryColor: string;
            accentColor: string | null;
            footerText: string | null;
            sidebarLogoUrl?: string | null;
            useWhiteLogoBackground?: boolean;
            videoSortRule?: string | null;
        }>('/admin/tenant/branding', { token, tenantId }),

    /** SuperAdmin — update dynamic branding. */
    updateAdminBranding: (token: string, tenantId: string, data: {
        name: string; logoUrl?: string | null; faviconUrl?: string | null;
        primaryColor: string; accentColor?: string | null; footerText?: string | null;
        sidebarLogoUrl?: string | null; useWhiteLogoBackground?: boolean;
        usernameRule?: string; passwordRule?: string; videoSortRule?: string;
        applyToStudents?: boolean; applyToAllUsers?: boolean;
        featuresJson?: string | null;
    }) =>
        api<unknown>('/admin/tenant/branding', {
            method: 'POST', token, tenantId, body: JSON.stringify(data),
        }),
};
