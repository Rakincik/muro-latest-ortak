using MURO.Application.DTOs;
using MURO.Application.DTOs.Groups;

namespace MURO.Application.Interfaces;

public interface IGroupService
{
    Task<PagedResult<GroupListDto>> GetGroupsAsync(int page, int pageSize, string? search);
    Task<List<GroupTreeDto>> GetGroupTreeAsync();
    Task<GroupDetailDto> GetGroupByIdAsync(Guid groupId);
    Task<GroupListDto> CreateGroupAsync(CreateGroupRequest request);
    Task<GroupListDto> UpdateGroupAsync(Guid groupId, UpdateGroupRequest request);
    Task DeleteGroupAsync(Guid groupId);
    Task ForceDeleteGroupAsync(Guid groupId);
    Task<GroupListDto> CloneGroupAsync(Guid groupId, string newName, bool copyMembers, bool copyCourses);
    Task AddMembersAsync(Guid groupId, List<Guid> userIds);
    Task RemoveMemberAsync(Guid groupId, Guid userId);
    Task MoveMembersAsync(Guid fromGroupId, Guid toGroupId, List<Guid> userIds);
}
