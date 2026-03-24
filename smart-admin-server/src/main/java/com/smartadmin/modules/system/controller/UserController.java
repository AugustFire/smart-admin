package com.smartadmin.modules.system.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.system.biz.UserBiz;
import com.smartadmin.modules.system.dto.request.UserAddReq;
import com.smartadmin.modules.system.dto.request.UserPageQueryReq;
import com.smartadmin.modules.system.dto.request.UserResetPwdReq;
import com.smartadmin.modules.system.dto.request.UserUpdateReq;
import com.smartadmin.modules.system.dto.response.UserResp;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户管理 Controller
 */
@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@Tag(name = "用户管理", description = "用户 CRUD 操作")
public class UserController {

    private final UserBiz userBiz;

    /**
     * 获取用户列表（分页）
     */
    @GetMapping("/page")
    @Operation(summary = "获取用户列表（分页）")
    public Result<PageResp<UserResp>> pageUsers(UserPageQueryReq req) {
        return Result.success(userBiz.pageUsers(req));
    }

    /**
     * 获取用户详情
     */
    @GetMapping("/{id}")
    @Operation(summary = "获取用户详情")
    public Result<UserResp> getById(@PathVariable Long id) {
        return Result.success(userBiz.getUserById(id));
    }

    /**
     * 新增用户
     */
    @PostMapping
    @OperLog(title = "用户管理", businessType = BusinessType.INSERT)
    @Operation(summary = "新增用户")
    public Result<Long> add(@Valid @RequestBody UserAddReq req) {
        Long userId = userBiz.addUser(req);
        return Result.success(userId);
    }

    /**
     * 修改用户
     */
    @PutMapping
    @OperLog(title = "用户管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改用户")
    public Result<Void> update(@Valid @RequestBody UserUpdateReq req) {
        userBiz.updateUser(req);
        return Result.success();
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    @OperLog(title = "用户管理", businessType = BusinessType.DELETE)
    @Operation(summary = "删除用户")
    public Result<Void> delete(@PathVariable Long id) {
        userBiz.deleteUser(id);
        return Result.success();
    }

    /**
     * 重置用户密码
     */
    @PutMapping("/resetPwd")
    @OperLog(title = "用户管理", businessType = BusinessType.UPDATE)
    @Operation(summary = "重置用户密码")
    public Result<Void> resetPwd(@Valid @RequestBody UserResetPwdReq req) {
        userBiz.resetPassword(req);
        return Result.success();
    }

    /**
     * 给用户分配角色
     */
    @PutMapping("/assignRoles")
    @OperLog(title = "用户管理", businessType = BusinessType.ASSIGN)
    @Operation(summary = "给用户分配角色")
    public Result<Void> assignRoles(@RequestParam Long userId, @RequestBody List<Long> roleIds) {
        userBiz.assignRoles(userId, roleIds);
        return Result.success();
    }

    /**
     * 获取用户的角色 ID 列表
     */
    @GetMapping("/roleIds/{userId}")
    @Operation(summary = "获取用户的角色 ID 列表")
    public Result<List<Long>> getRoleIdsByUserId(@PathVariable Long userId) {
        return Result.success(userBiz.getRoleIdsByUserId(userId));
    }
}