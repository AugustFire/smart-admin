package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysMenuApi;

import java.util.List;
import java.util.Set;

/**
 * 菜单接口关联服务接口
 */
public interface SysMenuApiService extends BaseService<SysMenuApi> {

    /**
     * 根据菜单 ID 删除关联
     */
    default void deleteByMenuId(Long menuId) {
        lambdaUpdate().eq(SysMenuApi::getMenuId, menuId).remove();
    }

    /**
     * 根据接口 ID 删除关联
     */
    default void deleteByApiId(Long apiId) {
        lambdaUpdate().eq(SysMenuApi::getApiId, apiId).remove();
    }

    /**
     * 根据菜单 ID 获取接口 ID 列表
     */
    List<Long> getApiIdsByMenuId(Long menuId);

    /**
     * 根据多个菜单 ID 获取接口 ID 列表
     */
    Set<Long> getApiIdsByMenuIds(Set<Long> menuIds);

    /**
     * 根据接口 ID 获取关联的菜单 ID 列表
     */
    List<Long> getMenuIdsByApiId(Long apiId);

    /**
     * 根据菜单 ID 获取关联的接口数量
     */
    int countByMenuId(Long menuId);

    /**
     * 给菜单分配接口
     */
    void assignApis(Long menuId, List<Long> apiIds);

    /**
     * 给接口分配菜单（支持多选）
     */
    void assignMenus(Long apiId, List<Long> menuIds);
}