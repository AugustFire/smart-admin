package com.autoadmin.modules.profile.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 修改密码请求
 */
@Data
@Schema(description = "修改密码请求")
public class PasswordReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "旧密码不能为空")
    @Schema(description = "旧密码", example = "admin123")
    private String oldPassword;

    @NotBlank(message = "新密码不能为空")
    @Schema(description = "新密码", example = "new123456")
    private String newPassword;
}