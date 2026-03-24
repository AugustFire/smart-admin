package com.smartadmin.modules.system.biz;

import com.smartadmin.common.exception.BusinessException;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.system.dto.request.RoleAddReq;
import com.smartadmin.modules.system.dto.request.RoleAssignMenuReq;
import com.smartadmin.modules.system.dto.request.RolePageQueryReq;
import com.smartadmin.modules.system.dto.request.RoleUpdateReq;
import com.smartadmin.modules.system.dto.response.RoleResp;
import com.smartadmin.modules.system.entity.SysMenu;
import com.smartadmin.modules.system.entity.SysRole;
import com.smartadmin.modules.system.mapper.RoleConverter;
import com.smartadmin.modules.system.service.SysMenuService;
import com.smartadmin.modules.system.service.SysRoleMenuService;
import com.smartadmin.modules.system.service.SysRoleService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 角色管理业务类
 */
@Component
@RequiredArgsConstructor
public class RoleBiz {

    private final SysRoleService roleService;
    private final SysRoleMenuService roleMenuService;
    private final SysMenuService menuService;

    /**
     * 新增角色
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addRole(RoleAddReq req) {
        // 校验角色编码是否存在
        if (roleService.existsByCode(req.getCode())) {
            throw new BusinessException("角色编码已存在");
        }

        SysRole role = RoleConverter.INSTANCE.toEntity(req);
        if (role.getSort() == null) {
            role.setSort(0);
        }
        if (role.getStatus() == null) {
            role.setStatus(1);
        }

        roleService.save(role);
        return role.getId();
    }

    /**
     * 获取角色详情
     */
    public RoleResp getRoleById(Long id) {
        SysRole role = roleService.getByIdOrThrow(id);
        return RoleConverter.INSTANCE.toResp(role);
    }

    /**
     * 分页查询角色
     */
    public PageResp<RoleResp> pageRoles(RolePageQueryReq req) {
        IPage<SysRole> page = roleService.lambdaQuery()
                .like(req.getName() != null && !req.getName().isEmpty(), SysRole::getName, req.getName())
                .like(req.getCode() != null && !req.getCode().isEmpty(), SysRole::getCode, req.getCode())
                .eq(req.getStatus() != null, SysRole::getStatus, req.getStatus())
                .orderByAsc(SysRole::getSort)
                .page(new Page<>(req.getPageNum(), req.getPageSize()));

        List<RoleResp> roleRespList = page.getRecords().stream()
                .map(RoleConverter.INSTANCE::toResp)
                .collect(Collectors.toList());

        return PageResp.of(roleRespList, page.getTotal(), (int) page.getCurrent(), (int) page.getSize());
    }

    /**
     * 更新角色
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateRole(RoleUpdateReq req) {
        roleService.getByIdOrThrow(req.getRoleId());

        if (roleService.existsByCode(req.getCode(), req.getRoleId())) {
            throw new BusinessException("角色编码已存在");
        }

        SysRole role = new SysRole();
        role.setId(req.getRoleId());
        role.setName(req.getName());
        role.setCode(req.getCode());
        role.setSort(req.getSort());
        role.setStatus(req.getStatus());
        roleService.updateById(role);
    }

    /**
     * 删除角色
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteRole(Long id) {
        roleService.getByIdOrThrow(id);

        // 删除角色（逻辑删除）
        roleService.removeById(id);

        // 删除角色菜单关联
        roleMenuService.deleteByRoleId(id);
    }

    /**
     * 给角色分配菜单权限
     */
    @Transactional(rollbackFor = Exception.class)
    public void assignMenus(RoleAssignMenuReq req) {
        roleService.getByIdOrThrow(req.getRoleId());
        roleMenuService.assignMenus(req.getRoleId(), req.getMenuIds());
    }

    /**
     * 获取角色的菜单 ID 列表
     * 超级管理员角色返回全部菜单 ID
     */
    public List<Long> getMenuIdsByRoleId(Long roleId) {
        SysRole role = roleService.getByIdOrThrow(roleId);

        // 超级管理员返回全部菜单
        if ("super_admin".equals(role.getCode())) {
            return menuService.list().stream()
                    .map(SysMenu::getId)
                    .collect(Collectors.toList());
        }

        return roleMenuService.getMenuIdsByRoleId(roleId);
    }

    /**
     * 获取所有角色列表
     */
    public List<RoleResp> listRoles() {
        return roleService.lambdaQuery()
                .eq(SysRole::getStatus, 1)
                .orderByAsc(SysRole::getSort)
                .list()
                .stream()
                .map(RoleConverter.INSTANCE::toResp)
                .collect(Collectors.toList());
    }

    /**
     * 根据用户 ID 获取角色 ID 集合
     */
    public Set<Long> getRoleIdsByUserId(Long userId) {
        return roleService.getRoleIdsByUserId(userId);
    }

    /**
     * 获取用户的角色列表
     */
    public Set<SysRole> getRolesByUserId(Long userId) {
        return roleService.getRolesByUserId(userId);
    }

    /**
     * 判断用户是否为超级管理员
     */
    public boolean isSuperAdmin(Long userId) {
        return roleService.isSuperAdmin(userId);
    }
}