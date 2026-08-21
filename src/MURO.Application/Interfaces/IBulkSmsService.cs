using System;
using System.Threading;
using System.Threading.Tasks;
using MURO.Application.DTOs.Integrations;

namespace MURO.Application.Interfaces;

public interface IBulkSmsService
{
    Task<BulkSmsPreviewResult> PreviewRecipientsAsync(BulkSmsCampaignRequest request, CancellationToken ct = default);
    Task<BulkSmsExecutionResult> SendBulkCampaignAsync(BulkSmsCampaignRequest request, CancellationToken ct = default);
    Task<SmsTriggerSettingsDto> GetTriggerSettingsAsync(CancellationToken ct = default);
    Task<SmsTriggerSettingsDto> UpdateTriggerSettingsAsync(SmsTriggerSettingsDto settings, CancellationToken ct = default);
    Task TriggerLiveLessonStartedSmsAsync(Guid courseId, string sessionTitle, CancellationToken ct = default);
    Task TriggerRecordingReadySmsAsync(Guid courseId, string sessionTitle, CancellationToken ct = default);
    Task TriggerWelcomeStudentSmsAsync(Guid userId, string? rawPassword = null, CancellationToken ct = default);
}
