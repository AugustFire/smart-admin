package com.smartadmin.modules.system.service;

import com.smartadmin.common.base.BaseService;
import com.smartadmin.modules.system.entity.SysUser;

/**
 * 用户基础服务接口
 * 继承 MyBatis Plus IService，提供用户基础 CRUD 操作
 */
public interface SysUserService extends BaseService<SysUser> {

    /**
     * 检查用户名是否存在
     *
     * @param username 用户名
     * @return true 存在
     */
    default boolean existsByUsername(String username) {
        return lambdaQuery().eq(SysUser::getUsername, username).exists();
    }

    /**
     * 检查用户名是否被其他用户使用
     *
     * @param username 用户名
     * @param excludeId 排除的用户 ID
     * @return true 存在
     */
    default boolean existsByUsername(String username, Long excludeId) {
        return lambdaQuery()
                .eq(SysUser::getUsername, username)
                .ne(SysUser::getId, excludeId)
                .exists();
    }
}