package com.autoadmin.modules.profile.biz;

import com.autoadmin.common.exception.BusinessException;
import com.autoadmin.modules.profile.dto.request.PasswordReq;
import com.autoadmin.modules.profile.dto.request.ProfileUpdateReq;
import com.autoadmin.modules.profile.dto.response.ProfileResp;
import com.autoadmin.modules.profile.service.SysProfileService;
import com.autoadmin.modules.system.entity.SysUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * 个人中心业务类
 */
@Component
@RequiredArgsConstructor
public class ProfileBiz {

    private final SysProfileService profileService;
    private final PasswordEncoder passwordEncoder;

    /**
     * 获取当前用户信息
     */
    public ProfileResp getProfile(Long userId) {
        SysUser user = profileService.getByIdOrThrow(userId);

        return ProfileResp.builder()
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .email(user.getEmail())
                .phone(user.getPhone())
                .sex(user.getSex())
                .build();
    }

    /**
     * 更新个人信息
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateProfile(Long userId, ProfileUpdateReq req) {
        SysUser user = new SysUser();
        user.setId(userId);
        user.setNickname(req.getNickname());
        user.setAvatar(req.getAvatar());
        user.setEmail(req.getEmail());
        user.setPhone(req.getPhone());
        user.setSex(req.getSex());
        profileService.updateById(user);
    }

    /**
     * 修改密码
     */
    @Transactional(rollbackFor = Exception.class)
    public void updatePassword(Long userId, PasswordReq req) {
        SysUser user = profileService.getByIdOrThrow(userId);

        // 验证旧密码
        if (!passwordEncoder.matches(req.getOldPassword(), user.getPassword())) {
            throw new BusinessException("旧密码错误");
        }

        // 更新密码
        SysUser updateUser = new SysUser();
        updateUser.setId(userId);
        updateUser.setPassword(passwordEncoder.encode(req.getNewPassword()));
        profileService.updateById(updateUser);
    }
}