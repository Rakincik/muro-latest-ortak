import { api, cachedApi, invalidateCache, invalidateCacheByPrefix, API_URL, PagedResult } from './core';
import { CourseListDto, SessionDto, CourseDetailDto, CourseMaterialDto, AuthResponse, UserDto, UserTenantDto, ExamListDto, ExamDetailDto, ExamAssignmentDto, ExamResultDto, ExamResultSummaryDto, ExamOverallSummaryDto, ScoreRangeDto, AssignmentListDto, StudentScorecardDto, CourseAttendanceDto, DashboardStatsDto, DeviceSessionDto, ScorecardSummaryDto, NotificationDto, AdminSentNotificationDto, GroupSummaryDto, SessionStartResult, RecordingDto, PlanDto, TransactionDto, MonthlyRevenueDto, PlanRevenueDto, AccountingSummaryDto, PaymentMethodBreakdownDto, CreateTransactionRequest, PodcastDto, GeneratePodcastRequest, GroupListDto, GroupMemberDto, GroupDetailDto, CalendarEventDto, CreateCalendarEventRequest, TicketDto, TicketReplyDto, AdminDashboardDto, PackageGroupDto, PackageDto, UserPackageDto, CreatePackageRequest, WebhookInfo, PagedUsersResult, CreateUserRequest, QuestionDto, CreateQuestionRequest, AuditLogDto, PagedAuditResult, AuditSummaryDto, TenantBrandingDto, SubmissionDto, AssignmentDetailDto } from './types';
import * as tus from 'tus-js-client';

export const uploadApi = {
    /** PDF veya dosya yüklemek için presigned URL al */
    getPresignedUrl: (token: string, tenantId: string, fileName: string, contentType: string) =>
        api<{ uploadUrl: string; publicUrl: string }>('/upload/presigned', {
            method: 'POST', token, tenantId,
            body: JSON.stringify({ fileName, contentType }),
        }),
    
    /** XMLHttpRequest ile ilerleme barını destekleyen direkt yükleme metodu (Eski Yöntem) */
    uploadMediaWithProgress: (uploadUrl: string, file: File, onProgress: (progress: number, etaSeconds?: number) => void): Promise<void> => {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open('PUT', uploadUrl, true);
            
            const startTime = Date.now();
            let lastProgressTime = 0;

            xhr.upload.onprogress = (event) => {
                if (event.lengthComputable) {
                    const percentComplete = Math.round((event.loaded / event.total) * 100);
                    
                    const now = Date.now();
                    if (now - lastProgressTime >= 100 || percentComplete === 100) {
                        lastProgressTime = now;
                        
                        let etaSeconds = 0;
                        const elapsedMs = now - startTime;
                        if (elapsedMs > 500 && event.loaded > 0) {
                            const bytesPerSec = event.loaded / (elapsedMs / 1000);
                            const remainingBytes = event.total - event.loaded;
                            etaSeconds = Math.max(0, Math.round(remainingBytes / bytesPerSec));
                        }
                        
                        onProgress(percentComplete, etaSeconds);
                    }
                }
            };
            
            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    resolve();
                } else {
                    reject(new Error(`Upload failed with status ${xhr.status}`));
                }
            };
            
            xhr.onerror = () => reject(new Error("Network error during upload"));
            
            xhr.setRequestHeader("Content-Type", file.type);
            xhr.send(file);
        });
    },

    /** TUS Protokolü ile kopmalara dayanıklı devam edilebilir yükleme (Yeni Yöntem) */
    uploadMediaWithTus: (file: File, token: string, tenantId: string, onProgress: (progress: number, etaSeconds?: number) => void): Promise<string> => {
        return new Promise((resolve, reject) => {
            const startTime = Date.now();
            let lastProgressTime = 0;

            const upload = new tus.Upload(file, {
                endpoint: API_URL.replace("/api/v1", "") + "/api/v1/upload/tus",
                retryDelays: [0, 3000, 5000, 10000, 20000], // Hata anında otomatik yeniden deneme süreleri
                metadata: {
                    filename: file.name,
                    filetype: file.type
                },
                headers: {
                    Authorization: `Bearer ${token}`,
                    "X-Tenant-Id": tenantId
                },
                onError: function (error) {
                    console.error("TUS Upload Error:", error);
                    reject(error);
                },
                onProgress: function (bytesUploaded, bytesTotal) {
                    const percentComplete = Math.round((bytesUploaded / bytesTotal) * 100);
                    const now = Date.now();

                    if (now - lastProgressTime >= 100 || percentComplete === 100) {
                        lastProgressTime = now;
                        let etaSeconds = 0;
                        const elapsedMs = now - startTime;
                        if (elapsedMs > 500 && bytesUploaded > 0) {
                            const bytesPerSec = bytesUploaded / (elapsedMs / 1000);
                            const remainingBytes = bytesTotal - bytesUploaded;
                            etaSeconds = Math.max(0, Math.round(remainingBytes / bytesPerSec));
                        }
                        onProgress(percentComplete, etaSeconds);
                    }
                },
                onSuccess: function () {
                    if (upload.url) {
                        const fileId = upload.url.split('/').pop();
                        const ext = file.name.substring(file.name.lastIndexOf('.'));
                        resolve(`/api/v1/uploads/${fileId}${ext}`);
                    } else {
                        reject(new Error("TUS Upload URL not returned."));
                    }
                }
            });

            upload.findPreviousUploads().then(function (previousUploads) {
                if (previousUploads.length) {
                    upload.resumeFromPreviousUpload(previousUploads[0]);
                }
                upload.start();
            });
        });
    }
};

// ── Package API ───────────────────────────────────────────────────────────────

