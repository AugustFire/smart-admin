package com.autoadmin.modules.auth.controller;

import com.autoadmin.modules.auth.biz.AuthBiz;
import com.autoadmin.modules.auth.dto.request.LoginRequest;
import com.autoadmin.modules.auth.dto.response.LoginResponse;
import com.autoadmin.modules.auth.dto.response.UserInfoResponse;
import com.autoadmin.common.Result;
import com.autoadmin.common.annotation.OperLog;
import com.autoadmin.common.enums.BusinessType;
import com.autoadmin.modules.system.entity.SysMenu;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
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
    public Result<Void> logout(HttpServletRequest request) {
        String username = (String) request.getAttribute("username");
        log.info("用户 {} 登出成功", username);
        return Result.success();
    }

    /**
     * 获取当前用户信息
     */
    @GetMapping("/userInfo")
    @Operation(summary = "获取当前用户信息")
    public Result<UserInfoResponse> getUserInfo(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
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
    public Result<List<SysMenu>> getUserMenus(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        List<SysMenu> menus = authBiz.getUserMenus(userId);
        return Result.success(menus);
    }
}
