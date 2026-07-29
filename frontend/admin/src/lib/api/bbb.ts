import { api } from './core';

export interface BbbRecordingInfo {
    recordingId: string;
    meetingId: string;
    name: string;
    playbackUrl: string | null;
    durationSeconds: number;
    startTime: string;
    status: string;
}

export const adminBbbApi = {
    listRecordings: (token: string, tenantId: string) =>
        api<BbbRecordingInfo[]>('/admin/bbb/recordings', { token, tenantId }),
    assignRecording: (token: string, tenantId: string, data: { sessionId?: string | null; courseId?: string | null; recordingId?: string | null; playbackUrl: string; durationSeconds: number }) =>
        api<{ success: boolean; recordingId: string }>('/admin/bbb/recordings/assign', {
            method: 'POST',
            token,
            tenantId,
            body: JSON.stringify(data)
        })
};
