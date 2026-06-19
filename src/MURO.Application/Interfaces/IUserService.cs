using MURO.Application.DTOs;
using MURO.Application.DTOs.Users;

namespace MURO.Application.Interfaces;

public interface IUserService
{
    Task<PagedResult<UserListDto>> GetUsersAsync(int page, int pageSize, string? search, string? role, string? sortBy, string? sortDir);
    Task<UserDetailDto> GetUserByIdAsync(Guid userId);
    Task<UserListDto> CreateUserAsync(CreateUserRequest request);
    Task<BulkImportResultDto> BulkCreateUsersAsync(List<CreateUserRequest> users);
    Task<UserListDto> UpdateUserAsync(Guid userId, UpdateUserRequest request, string? actorRole = null);
    Task DeleteUserAsync(Guid userId);
    Task BulkDeleteUsersAsync(List<Guid> userIds);
    Task AssignToGroupAsync(Guid userId, Guid groupId);
    Task AssignToCourseAsync(Guid userId, Guid courseId, string mode);
    Task<byte[]> ExportUsersAsync(string? role);
}
