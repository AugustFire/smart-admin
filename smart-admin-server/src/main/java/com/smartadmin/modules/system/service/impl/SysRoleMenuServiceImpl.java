package com.smartadmin.modules.system.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.system.entity.SysRoleMenu;
import com.smartadmin.modules.system.mapper.SysRoleMenuMapper;
import com.smartadmin.modules.system.service.SysRoleMenuService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 角色菜单关联服务实现
 */
@Service
public class SysRoleMenuServiceImpl extends BaseServiceImpl<SysRoleMenuMapper, SysRoleMenu> implements SysRoleMenuService {

    @Override
    public List<Long> getMenuIdsByRoleId(Long roleId) {
        List<SysRoleMenu> roleMenus = lambdaQuery()
                .eq(SysRoleMenu::getRoleId, roleId)
                .list();
        if (roleMenus.isEmpty()) {
            return new ArrayList<>();
        }
        return roleMenus.stream()
                .map(SysRoleMenu::getMenuId)
                .collect(Collectors.toList());
    }

    @Override
    public Set<Long> getMenuIdsByRoleIds(Set<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return new HashSet<>();
        }

        List<SysRoleMenu> roleMenus = lambdaQuery()
                .in(SysRoleMenu::getRoleId, roleIds)
                .list();

        if (roleMenus.isEmpty()) {
            return new HashSet<>();
        }

        return roleMenus.stream()
                .map(SysRoleMenu::getMenuId)
                .collect(Collectors.toSet());
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void assignMenus(Long roleId, List<Long> menuIds) {
        // 删除原有菜单关联
        lambdaUpdate()
                .eq(SysRoleMenu::getRoleId, roleId)
                .remove();

        // 添加新菜单关联（去重）
        if (menuIds != null && !menuIds.isEmpty()) {
            Set<Long> uniqueMenuIds = new HashSet<>(menuIds);
            List<SysRoleMenu> roleMenus = uniqueMenuIds.stream()
                    .map(menuId -> {
                        SysRoleMenu roleMenu = new SysRoleMenu();
                        roleMenu.setRoleId(roleId);
                        roleMenu.setMenuId(menuId);
                        return roleMenu;
                    })
                    .collect(Collectors.toList());
            saveBatch(roleMenus);
        }
    }
}