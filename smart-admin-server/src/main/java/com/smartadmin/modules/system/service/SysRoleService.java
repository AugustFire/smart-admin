package com.smartadmin.modules.system.service;

import com.smartadmin.common.base.BaseService;
import com.smartadmin.modules.system.entity.SysRole;

import java.util.Set;

/**
 * 角色基础服务接口
 */
public interface SysRoleService extends BaseService<SysRole> {

    /**
     * 检查角色编码是否存在
     */
    default boolean existsByCode(String code) {
        return lambdaQuery().eq(SysRole::getCode, code).exists();
    }

    /**
     * 检查角色编码是否被其他角色使用
     */
    default boolean existsByCode(String code, Long excludeId) {
        return lambdaQuery()
                .eq(SysRole::getCode, code)
                .ne(SysRole::getId, excludeId)
                .exists();
    }

    /**
     * 根据用户 ID 获取角色 ID 集合
     */
    Set<Long> getRoleIdsByUserId(Long userId);

    /**
     * 获取用户的角色列表
     */
    Set<SysRole> getRolesByUserId(Long userId);

    /**
     * 获取用户的角色编码集合
     */
    Set<String> getRoleCodesByUserId(Long userId);

    /**
     * 判断用户是否为超级管理员
     */
    boolean isSuperAdmin(Long userId);
}