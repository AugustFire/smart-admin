package com.smartadmin.modules.system.service;

import com.smartadmin.common.base.BaseService;
import com.smartadmin.modules.system.entity.SysApi;

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
     * 根据接口 ID 列表获取接口列表
     */
    Set<SysApi> getApisByIds(Set<Long> apiIds);

    /**
     * 检查指定路径和方法的接口是否为公开接口
     * @param path 接口路径
     * @param method 请求方法
     * @return true=公开接口，false=非公开接口
     */
    boolean isPublicApi(String path, String method);
}