using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using MURO.Application.DTOs.Connect;

namespace MURO.Application.Interfaces;

public interface IConnectApiService
{
    Task<Guid?> ValidateApiKeyAsync(string apiKeyHeader, CancellationToken ct = default);
    Task<ConnectEnrollResponse> EnrollStudentAsync(Guid tenantId, ConnectEnrollRequest request, CancellationToken ct = default);
    Task<ConnectUnenrollResponse> UnenrollStudentAsync(Guid tenantId, ConnectUnenrollRequest request, CancellationToken ct = default);
    Task<ConnectDemoLeadResponse> RegisterDemoLeadAsync(Guid tenantId, ConnectDemoLeadRequest request, CancellationToken ct = default);
    Task<ConnectBatchEnrollResponse> BatchEnrollStudentsAsync(Guid tenantId, ConnectBatchEnrollRequest request, CancellationToken ct = default);
    Task<ConnectStudentStatusResponse> GetStudentStatusAsync(Guid tenantId, string? email, string? phone, CancellationToken ct = default);
    Task<ConnectLiveStatusDto> GetLiveStatusAsync(Guid tenantId, CancellationToken ct = default);
    Task<string> GenerateMagicLoginUrlAsync(Guid tenantId, Guid userId, CancellationToken ct = default);
    Task<Guid?> ConsumeMagicLoginTokenAsync(string token, CancellationToken ct = default);
    Task<List<ConnectPackageItemDto>> GetPackagesCatalogAsync(Guid tenantId, CancellationToken ct = default);
    Task<List<ConnectGroupDto>> GetGroupsAsync(Guid tenantId, CancellationToken ct = default);
    Task<ConnectPackageSyncResponse> SyncPackagesAsync(Guid tenantId, List<ConnectPackageSyncItem> items, CancellationToken ct = default);
    Task<ConnectStatsDto> GetStatsAsync(Guid tenantId, CancellationToken ct = default);
    Task<TenantApiKeyDto> GetOrCreateApiKeyAsync(Guid tenantId, CancellationToken ct = default);
    Task<TenantApiKeyDto> RegenerateApiKeyAsync(Guid tenantId, string? name = null, CancellationToken ct = default);
    Task<List<ConnectApiLogDto>> GetLogsAsync(Guid tenantId, int take = 50, CancellationToken ct = default);
    Task LogRequestAsync(Guid tenantId, Guid? apiKeyId, string endpoint, string method, string? ip, int statusCode, string? reqBody, string? resBody, long durationMs);
}
