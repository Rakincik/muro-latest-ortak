using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using MURO.Application.DTOs.Integrations;

namespace MURO.Application.Interfaces;

public interface ISmsService
{
    Task<SmsSendResult> SendSmsAsync(SendSingleSmsRequest request, CancellationToken ct = default);
    Task<SmsSendResult> SendBulkSmsAsync(SendBulkSmsRequest request, CancellationToken ct = default);
    Task<SmsSendResult> SendOtpAsync(string phone, string code, CancellationToken ct = default);
    Task<SmsAccountInfoResult> GetAccountInfoAsync(VatanSmsConfigDto? overrideConfig = null, CancellationToken ct = default);
    Task<List<string>> GetSendersAsync(VatanSmsConfigDto? overrideConfig = null, CancellationToken ct = default);
}
