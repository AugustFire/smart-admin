package com.autoadmin.modules.system.service;

import com.autoadmin.common.base.BaseService;
import com.autoadmin.modules.system.entity.SysMenu;

import java.util.List;
import java.util.Set;

/**
 * 菜单基础服务接口
 */
public interface SysMenuService extends BaseService<SysMenu> {

    /**
     * 获取所有菜单列表（按排序）
     */
    default List<SysMenu> listAllOrdered() {
        return lambdaQuery()
                .orderByAsc(SysMenu::getSort)
                .list();
    }

    /**
     * 获取目录和菜单类型的列表
     */
    default List<SysMenu> listDirAndMenu() {
        return lambdaQuery()
                .in(SysMenu::getType, 1, 2)
                .orderByAsc(SysMenu::getSort)
                .list();
    }

    /**
     * 根据角色 ID 集合查询菜单
     */
    List<SysMenu> getMenusByRoleIds(Set<Long> roleIds);

    /**
     * 构建菜单树
     */
    List<SysMenu> buildMenuTree(List<SysMenu> menus, Long parentId);

    /**
     * 获取用户的菜单树
     */
    List<SysMenu> getMenuTreeByUserId(Long userId);

    /**
     * 获取用户的所有菜单（包括按钮），用于提取权限标识
     */
    List<SysMenu> getMenusByUserId(Long userId);
}