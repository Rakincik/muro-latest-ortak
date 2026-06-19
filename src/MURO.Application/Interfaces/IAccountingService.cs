using MURO.Application.DTOs.Accounting;

namespace MURO.Application.Interfaces;

public interface IAccountingService
{
    Task<AccountingSummaryDto> GetSummaryAsync(DateTime? from, DateTime? to);
    
    Task<List<TransactionDto>> GetTransactionsAsync(string? type, string? status, Guid? planId, DateTime? from, DateTime? to, int page, int pageSize);
    
    Task<TransactionDto> CreateTransactionAsync(Guid userId, CreateTransactionRequest req, string? ipAddress);
    
    Task<bool> DeleteTransactionAsync(Guid userId, Guid transactionId, string? ipAddress);

    Task<List<PlanDto>> GetPlansAsync();

    Task<PlanDto> CreatePlanAsync(Guid userId, CreatePlanRequest req, string? ipAddress);

    Task<bool> DeletePlanAsync(Guid userId, Guid planId, string? ipAddress);
}
