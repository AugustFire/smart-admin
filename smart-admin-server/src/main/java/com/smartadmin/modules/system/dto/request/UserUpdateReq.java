package com.smartadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.util.List;

/**
 * 更新用户请求
 */
@Data
@Schema(description = "更新用户请求")
public class UserUpdateReq {

    @NotNull(message = "用户 ID 不能为空")
    @Schema(description = "用户 ID", example = "1")
    private Long userId;

    @NotBlank(message = "用户名不能为空")
    @Size(min = 3, max = 20, message = "用户名长度 3-20 位")
    @Schema(description = "用户名", example = "admin")
    private String username;

    @Schema(description = "用户昵称", example = "管理员")
    private String nickname;

    @Schema(description = "头像 URL", example = "https://example.com/avatar.jpg")
    private String avatar;

    @Schema(description = "邮箱", example = "admin@example.com")
    private String email;

    @Schema(description = "手机号", example = "13800138000")
    private String phone;

    @Schema(description = "性别 0=未知 1=男 2=女", example = "1")
    private Integer sex;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;

    @Schema(description = "角色 ID 列表")
    private List<Long> roleIds;
}