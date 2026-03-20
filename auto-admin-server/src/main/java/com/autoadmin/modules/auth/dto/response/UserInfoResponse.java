package com.autoadmin.modules.auth.dto.response;

import com.autoadmin.modules.system.dto.response.RoleInfo;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 用户信息响应
 */
@Data
@Schema(description = "用户信息响应")
public class UserInfoResponse implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "用户 ID")
    private Long userId;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "用户昵称")
    private String nickname;

    @Schema(description = "头像 URL")
    private String avatar;

    @Schema(description = "用户角色列表")
    private List<RoleInfo> roles;

    @Schema(description = "权限标识列表")
    private List<String> permissions;
}
