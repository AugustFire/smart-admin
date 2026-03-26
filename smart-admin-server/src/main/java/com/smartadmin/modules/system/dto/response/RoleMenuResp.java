package com.smartadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

/**
 * 角色菜单响应
 */
@Data
@Schema(description = "角色菜单响应")
public class RoleMenuResp {

    @Schema(description = "角色 ID")
    private Long roleId;

    @Schema(description = "角色名称")
    private String name;

    @Schema(description = "角色编码")
    private String code;

    @Schema(description = "菜单 ID 列表")
    private List<Long> menuIds;
}