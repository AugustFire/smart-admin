package com.autoadmin.modules.system.biz;

import com.autoadmin.common.exception.BusinessException;
import com.autoadmin.modules.system.dto.request.MenuAddReq;
import com.autoadmin.modules.system.dto.request.MenuUpdateReq;
import com.autoadmin.modules.system.dto.response.MenuResp;
import com.autoadmin.modules.system.dto.response.MenuTreeResp;
import com.autoadmin.modules.system.entity.SysMenu;
import com.autoadmin.modules.system.mapper.MenuConverter;
import com.autoadmin.modules.system.service.SysMenuService;
import com.autoadmin.modules.system.service.SysRoleMenuService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 菜单管理业务类
 */
@Component
@RequiredArgsConstructor
public class MenuBiz {

    private final SysMenuService menuService;
    private final SysRoleMenuService roleMenuService;

    /**
     * 获取菜单树形列表
     */
    public List<MenuTreeResp> getTreeList() {
        List<SysMenu> menus = menuService.listAllOrdered();
        return buildTreeList(menus, 0L);
    }

    /**
     * 获取菜单选项列表（用于角色分配权限时展示）
     */
    public List<MenuTreeResp> getOptions() {
        List<SysMenu> menus = menuService.listDirAndMenu();
        return buildTreeList(menus, 0L);
    }

    /**
     * 获取菜单详情
     */
    public MenuResp getMenuById(Long id) {
        SysMenu menu = menuService.getByIdOrThrow(id);
        return MenuConverter.INSTANCE.toResp(menu);
    }

    /**
     * 新增菜单
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addMenu(MenuAddReq req) {
        SysMenu menu = MenuConverter.INSTANCE.toEntity(req);
        if (menu.getParentId() == null) {
            menu.setParentId(0L);
        }
        if (menu.getSort() == null) {
            menu.setSort(0);
        }
        if (menu.getVisible() == null) {
            menu.setVisible(1);
        }
        if (menu.getStatus() == null) {
            menu.setStatus(1);
        }
        menuService.save(menu);
        return menu.getId();
    }

    /**
     * 更新菜单
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateMenu(MenuUpdateReq req) {
        menuService.getByIdOrThrow(req.getId());

        SysMenu menu = new SysMenu();
        menu.setId(req.getId());
        menu.setParentId(req.getParentId());
        menu.setName(req.getName());
        menu.setType(req.getType());
        menu.setPath(req.getPath());
        menu.setComponent(req.getComponent());
        menu.setPermission(req.getPermission());
        menu.setIcon(req.getIcon());
        menu.setSort(req.getSort());
        menu.setVisible(req.getVisible());
        menu.setStatus(req.getStatus());
        menuService.updateById(menu);
    }

    /**
     * 删除菜单
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteMenu(Long id) {
        menuService.getByIdOrThrow(id);

        // 检查是否有子菜单
        long count = menuService.lambdaQuery()
                .eq(SysMenu::getParentId, id)
                .count();
        if (count > 0) {
            throw new BusinessException("存在子菜单，无法删除");
        }

        menuService.removeById(id);

        // 删除角色菜单关联
        roleMenuService.deleteByMenuId(id);
    }

    /**
     * 根据用户 ID 获取菜单树
     */
    public List<SysMenu> getMenuTreeByUserId(Long userId) {
        return menuService.getMenuTreeByUserId(userId);
    }

    /**
     * 根据角色 ID 列表获取菜单
     */
    public List<MenuResp> getMenusByRoleIds(List<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return List.of();
        }
        Set<Long> roleIdSet = roleIds.stream().collect(Collectors.toSet());
        List<SysMenu> menus = menuService.getMenusByRoleIds(roleIdSet);
        return MenuConverter.INSTANCE.toRespList(menus);
    }

    /**
     * 构建树形结构（树形响应）
     */
    private List<MenuTreeResp> buildTreeList(List<SysMenu> menus, Long parentId) {
        return menus.stream()
                .filter(menu -> menu.getParentId().equals(parentId))
                .map(menu -> {
                    MenuTreeResp resp = MenuConverter.INSTANCE.toTreeResp(menu);
                    resp.setChildren(buildTreeList(menus, menu.getId()));
                    return resp;
                })
                .sorted((a, b) -> a.getSort().compareTo(b.getSort()))
                .collect(Collectors.toList());
    }
}