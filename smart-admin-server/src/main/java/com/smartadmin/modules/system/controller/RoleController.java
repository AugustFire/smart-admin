package com.smartadmin.modules.system.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.system.biz.RoleBiz;
import com.smartadmin.modules.system.dto.request.RoleAddReq;
import com.smartadmin.modules.system.dto.request.RoleAssignMenuReq;
import com.smartadmin.modules.system.dto.request.RolePageQueryReq;
import com.smartadmin.modules.system.dto.request.RoleUpdateReq;
import com.smartadmin.modules.system.dto.response.RoleResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 角色管理 Controller
 */
@RestController
@RequestMapping("/role")
@RequiredArgsConstructor
@Tag(name = "角色管理", description = "角色 CRUD 操作")
public class RoleController {

    private final RoleBiz roleBiz;

    /**
     * 获取角色列表（分页）
     */
    @GetMapping("/page")
    @Operation(summary = "获取角色列表（分页）")
    public Result<PageResp<RoleResp>> pageRoles(RolePageQueryReq req) {
        return Result.success(roleBiz.pageRoles(req));
    }

    /**
     * 获取所有角色列表
     */
    @GetMapping("/list")
    @Operation(summary = "获取所有角色列表")
    public Result<List<RoleResp>> listRoles() {
        return Result.success(roleBiz.listRoles());
    }

    /**
     * 获取角色详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取角色详情")
    public Result<RoleResp> getById(@PathVariable Long id) {
        return Result.success(roleBiz.getRoleById(id));
    }

    /**
     * 新增角色
     */
    @PostMapping
    @OperLog(title = "角色管理", businessType = BusinessType.INSERT)
    @Operation(summary = "新增角色")
    public Result<Long> add(@Valid @RequestBody RoleAddReq req) {
        Long roleId = roleBiz.addRole(req);
        return Result.success(roleId);
    }

    /**
     * 修改角色
     */
    @PutMapping
    @OperLog(title = "角色管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改角色")
    public Result<Void> update(@Valid @RequestBody RoleUpdateReq req) {
        roleBiz.updateRole(req);
        return Result.success();
    }

    /**
     * 删除角色
     */
    @DeleteMapping("/{id}")
    @OperLog(title = "角色管理", businessType = BusinessType.DELETE)
    @Operation(summary = "删除角色")
    public Result<Void> delete(@PathVariable Long id) {
        roleBiz.deleteRole(id);
        return Result.success();
    }

    /**
     * 给角色分配菜单权限
     */
    @PutMapping("/assignMenus")
    @OperLog(title = "角色管理", businessType = BusinessType.ASSIGN)
    @Operation(summary = "给角色分配菜单权限")
    public Result<Void> assignMenus(@Valid @RequestBody RoleAssignMenuReq req) {
        roleBiz.assignMenus(req);
        return Result.success();
    }

    /**
     * 获取角色的菜单 ID 列表
     */
    @GetMapping("/menuIds/{roleId}")
    @Operation(summary = "获取角色的菜单 ID 列表")
    public Result<List<Long>> getMenuIdsByRoleId(@PathVariable Long roleId) {
        return Result.success(roleBiz.getMenuIdsByRoleId(roleId));
    }
}