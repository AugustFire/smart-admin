package com.smartadmin.modules.profile.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import lombok.Data;

/**
 * 更新个人信息请求
 */
@Data
@Schema(description = "更新个人信息请求")
public class ProfileUpdateReq {

    @Schema(description = "用户昵称", example = "管理员")
    private String nickname;

    @Schema(description = "头像 URL", example = "https://example.com/avatar.jpg")
    private String avatar;

    @Email(message = "邮箱格式不正确")
    @Schema(description = "邮箱", example = "admin@example.com")
    private String email;

    @Schema(description = "手机号", example = "13800138000")
    private String phone;

    @Schema(description = "性别 0=未知 1=男 2=女", example = "1")
    private Integer sex;
}