package com.autoadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.io.Serializable;

/**
 * 角色信息（用于用户信息响应）
 */
@Data
@Schema(description = "角色信息")
public class RoleInfo implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "角色 ID")
    private Long roleId;

    @Schema(description = "角色编码")
    private String code;

    @Schema(description = "角色名称")
    private String name;
}