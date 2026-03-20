package com.autoadmin.modules.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;

/**
 * 刷新令牌请求
 */
@Data
@Schema(description = "刷新令牌请求")
public class TokenRefreshRequest implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "令牌不能为空")
    @Schema(description = "刷新令牌", example = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    private String refreshToken;
}
