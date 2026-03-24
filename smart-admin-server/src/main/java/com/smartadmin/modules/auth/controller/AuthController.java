package com.smartadmin.modules.auth.controller;

import com.smartadmin.modules.auth.biz.AuthBiz;
import com.smartadmin.modules.auth.dto.request.LoginRequest;
import com.smartadmin.modules.auth.dto.response.LoginResponse;
import com.smartadmin.modules.auth.dto.response.UserInfoResponse;
import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.modules.system.entity.SysMenu;
import com.smartadmin.utils.UserContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 认证 Controller
 */
@Slf4j
@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "认证管理", description = "登录、登出、用户信息等")
public class AuthController {

    private final AuthBiz authBiz;

    /**
     * 登录
     */
    @PostMapping("/login")
    @OperLog(title = "用户登录", businessType = BusinessType.LOGIN)
    @Operation(summary = "用户登录")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = authBiz.login(request);
        if (response == null) {
            return Result.error("用户名或密码错误");
        }
        log.info("用户 {} 登录成功", request.getUsername());
        return Result.success(response);
    }

    /**
     * 登出
     */
    @PostMapping("/logout")
    @OperLog(title = "用户登出", businessType = BusinessType.LOGOUT)
    @Operation(summary = "用户登出")
    public Result<Void> logout() {
        String username = UserContext.getUsername();
        log.info("用户 {} 登出成功", username);
        return Result.success();
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/userInfo")
    @Operation(summary = "获取当前用户信息")
    public Result<UserInfoResponse> getUserInfo() {
        Long userId = UserContext.getUserId();
        UserInfoResponse userInfo = authBiz.getUserInfo(userId);
        if (userInfo == null) {
            return Result.error("用户不存在");
        }
        return Result.success(userInfo);
    }

    /**
     * 获取当前用户菜单权限
     */
    @GetMapping("/userMenus")
    @Operation(summary = "获取当前用户菜单权限")
    public Result<List<SysMenu>> getUserMenus() {
        Long userId = UserContext.getUserId();
        List<SysMenu> menus = authBiz.getUserMenus(userId);
        return Result.success(menus);
    }
}
