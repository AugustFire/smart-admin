package com.autoadmin.modules.system.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.system.entity.SysMenu;
import com.autoadmin.modules.system.mapper.SysMenuMapper;
import com.autoadmin.modules.system.service.SysMenuService;
import com.autoadmin.modules.system.service.SysRoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Set;

/**
 * 菜单基础服务实现
 */
@Service
@RequiredArgsConstructor
public class SysMenuServiceImpl extends BaseServiceImpl<SysMenuMapper, SysMenu> implements SysMenuService {

    private final SysRoleService roleService;

    @Override
    public List<SysMenu> getMenusByRoleIds(Set<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return new ArrayList<>();
        }
        return baseMapper.selectMenusByRoleIds(roleIds);
    }

    @Override
    public List<SysMenu> buildMenuTree(List<SysMenu> menus, Long parentId) {
        return menus.stream()
                .filter(menu -> menu.getParentId().equals(parentId))
                .peek(menu -> {
                    List<SysMenu> children = buildMenuTree(menus, menu.getId());
                    menu.setChildren(children);
                })
                .sorted(Comparator.comparingInt(SysMenu::getSort))
                .collect(java.util.stream.Collectors.toList());
    }

    @Override
    public List<SysMenu> getMenuTreeByUserId(Long userId) {
        // 获取用户的角色 ID 集合
        Set<Long> roleIds = roleService.getRoleIdsByUserId(userId);
        if (roleIds.isEmpty()) {
            return new ArrayList<>();
        }

        List<SysMenu> menus;
        if (roleService.isSuperAdmin(userId)) {
            // 超级管理员返回所有菜单
            menus = listDirAndMenu();
        } else {
            // 普通用户返回角色对应的菜单
            menus = getMenusByRoleIds(roleIds);
        }

        return buildMenuTree(menus, 0L);
    }
}