package com.autoadmin.modules.system.controller;

import com.autoadmin.common.Result;
import com.autoadmin.common.annotation.OperLog;
import com.autoadmin.common.enums.BusinessType;
import com.autoadmin.modules.system.biz.MenuBiz;
import com.autoadmin.modules.system.dto.request.MenuAddReq;
import com.autoadmin.modules.system.dto.request.MenuUpdateReq;
import com.autoadmin.modules.system.dto.response.MenuResp;
import com.autoadmin.modules.system.dto.response.MenuTreeResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 菜单管理 Controller
 */
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
@Tag(name = "菜单管理", description = "菜单 CRUD 操作")
public class MenuController {

    private final MenuBiz menuBiz;

    /**
     * 获取菜单树形列表
     */
    @GetMapping("/tree")
    @Operation(summary = "获取菜单树形列表")
    public Result<List<MenuTreeResp>> tree() {
        return Result.success(menuBiz.getTreeList());
    }

    /**
     * 获取菜单详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取菜单详情")
    public Result<MenuResp> getById(@PathVariable Long id) {
        return Result.success(menuBiz.getMenuById(id));
    }

    /**
     * 新增菜单
     */
    @PostMapping
    @OperLog(title = "菜单管理", businessType = BusinessType.INSERT)
    @Operation(summary = "新增菜单")
    public Result<Long> add(@Valid @RequestBody MenuAddReq req) {
        Long menuId = menuBiz.addMenu(req);
        return Result.success(menuId);
    }

    /**
     * 修改菜单
     */
    @PutMapping
    @OperLog(title = "菜单管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改菜单")
    public Result<Void> update(@Valid @RequestBody MenuUpdateReq req) {
        menuBiz.updateMenu(req);
        return Result.success();
    }

    /**
     * 删除菜单
     */
    @DeleteMapping("/{id}")
    @OperLog(title = "菜单管理", businessType = BusinessType.DELETE)
    @Operation(summary = "删除菜单")
    public Result<Void> delete(@PathVariable Long id) {
        menuBiz.deleteMenu(id);
        return Result.success();
    }

    /**
     * 获取菜单选项列表（用于角色分配权限时展示）
     */
    @GetMapping("/options")
    @Operation(summary = "获取菜单选项列表")
    public Result<List<MenuTreeResp>> options() {
        return Result.success(menuBiz.getOptions());
    }
}