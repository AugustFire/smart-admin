package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysUserRole;

import java.util.List;

/**
 * 用户角色关联服务接口
 */
public interface SysUserRoleService extends BaseService<SysUserRole> {

    /**
     * 根据用户 ID 删除关联
     */
    default void deleteByUserId(Long userId) {
        lambdaUpdate().eq(SysUserRole::getUserId, userId).remove();
    }

    /**
     * 根据角色 ID 删除关联
     */
    default void deleteByRoleId(Long roleId) {
        lambdaUpdate().eq(SysUserRole::getRoleId, roleId).remove();
    }

    /**
     * 获取用户的角色 ID 列表
     */
    List<Long> getRoleIdsByUserId(Long userId);

    /**
     * 给用户分配角色
     */
    void assignRoles(Long userId, List<Long> roleIds);
}