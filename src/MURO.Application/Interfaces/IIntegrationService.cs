using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using MURO.Application.DTOs.Integrations;

namespace MURO.Application.Interfaces;

public interface IIntegrationService
{
    Task<List<IntegrationItemDto>> GetAllIntegrationsAsync(CancellationToken ct = default);
    Task<IntegrationItemDto?> GetIntegrationAsync(string providerKey, CancellationToken ct = default);
    Task<IntegrationItemDto> UpdateIntegrationAsync(string providerKey, UpdateIntegrationRequest request, string? updatedBy, CancellationToken ct = default);
    Task<SmsAccountInfoResult> TestVatanSmsAsync(TestIntegrationRequest request, CancellationToken ct = default);
}
