package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysApi;

import java.util.Set;

/**
 * 接口资源服务接口
 */
public interface SysApiService extends BaseService<SysApi> {

    /**
     * 检查接口路径是否存在
     */
    default boolean existsByPathAndMethod(String path, String method) {
        return lambdaQuery()
                .eq(SysApi::getPath, path)
                .eq(SysApi::getMethod, method)
                .exists();
    }

    /**
     * 检查接口路径是否存在（排除指定 ID）
     */
    default boolean existsByPathAndMethod(String path, String method, Long excludeId) {
        return lambdaQuery()
                .eq(SysApi::getPath, path)
                .eq(SysApi::getMethod, method)
                .ne(SysApi::getId, excludeId)
                .exists();
    }

    /**
     * 根据菜单 ID 列表获取接口列表
     */
    Set<SysApi> getApisByMenuIds(Set<Long> menuIds);
}