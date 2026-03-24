package com.smartadmin.modules.profile.controller;

import com.smartadmin.common.Result;
import com.smartadmin.common.annotation.OperLog;
import com.smartadmin.common.enums.BusinessType;
import com.smartadmin.modules.profile.biz.ProfileBiz;
import com.smartadmin.modules.profile.dto.request.PasswordReq;
import com.smartadmin.modules.profile.dto.request.ProfileUpdateReq;
import com.smartadmin.modules.profile.dto.response.ProfileResp;
import com.smartadmin.utils.UserContext;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/**
 * 个人中心 Controller
 */
@RestController
@RequestMapping("/profile")
@RequiredArgsConstructor
@Tag(name = "个人中心", description = "个人中心相关接口")
public class ProfileController {

    private final ProfileBiz profileBiz;

    /**
     * 获取当前用户信息
     */
    @GetMapping
    @Operation(summary = "获取当前用户信息")
    public Result<ProfileResp> getInfo() {
        Long userId = UserContext.getUserId();
        return Result.success(profileBiz.getProfile(userId));
    }

    /**
     * 修改个人信息
     */
    @PutMapping
    @OperLog(title = "个人中心", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改个人信息")
    public Result<Void> updateProfile(@Valid @RequestBody ProfileUpdateReq req) {
        Long userId = UserContext.getUserId();
        profileBiz.updateProfile(userId, req);
        return Result.success();
    }

    /**
     * 修改密码
     */
    @PutMapping("/password")
    @OperLog(title = "个人中心", businessType = BusinessType.UPDATE)
    @Operation(summary = "修改密码")
    public Result<Void> updatePassword(@Valid @RequestBody PasswordReq req) {
        Long userId = UserContext.getUserId();
        profileBiz.updatePassword(userId, req);
        return Result.success();
    }
}