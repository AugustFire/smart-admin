package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysRoleMenu;

import java.util.List;
import java.util.Set;

/**
 * 角色菜单关联服务接口
 */
public interface SysRoleMenuService extends BaseService<SysRoleMenu> {

    /**
     * 根据角色 ID 删除关联
     */
    default void deleteByRoleId(Long roleId) {
        lambdaUpdate().eq(SysRoleMenu::getRoleId, roleId).remove();
    }

    /**
     * 根据菜单 ID 删除关联
     */
    default void deleteByMenuId(Long menuId) {
        lambdaUpdate().eq(SysRoleMenu::getMenuId, menuId).remove();
    }

    /**
     * 获取角色的菜单 ID 列表
     */
    List<Long> getMenuIdsByRoleId(Long roleId);

    /**
     * 根据多个角色 ID 获取菜单 ID 列表
     */
    Set<Long> getMenuIdsByRoleIds(Set<Long> roleIds);

    /**
     * 给角色分配菜单
     */
    void assignMenus(Long roleId, List<Long> menuIds);
}