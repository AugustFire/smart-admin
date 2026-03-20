package com.autoadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;

/**
 * 用户角色响应（用于给用户分配角色时展示）
 */
@Data
@Schema(description = "用户角色响应")
public class UserRoleResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "用户 ID")
    private Long userId;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "昵称")
    private String nickname;

    @Schema(description = "角色 ID 列表")
    private java.util.List<Long> roleIds;
}