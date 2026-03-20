package com.autoadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.io.Serializable;

/**
 * 重置用户密码请求
 */
@Data
@Schema(description = "重置用户密码请求")
public class UserResetPwdReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "用户 ID 不能为空")
    @Schema(description = "用户 ID", example = "1")
    private Long userId;

    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 20, message = "密码长度 6-20 位")
    @Schema(description = "新密码", example = "new123456")
    private String password;
}