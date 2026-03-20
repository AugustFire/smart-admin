package com.autoadmin.modules.auth.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

/**
 * 登录响应
 */
@Data
@Builder
@Schema(description = "登录响应")
public class LoginResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "访问令牌")
    private String token;

    @Schema(description = "令牌类型", example = "Bearer")
    private String tokenType;

    @Schema(description = "过期时间（秒）", example = "7200")
    private Long expiresIn;

    @Schema(description = "用户 ID")
    private Long userId;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "用户昵称")
    private String nickname;

    @Schema(description = "头像 URL")
    private String avatar;
}
