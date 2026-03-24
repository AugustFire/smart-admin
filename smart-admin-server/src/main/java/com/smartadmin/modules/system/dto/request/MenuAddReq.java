package com.smartadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serializable;

/**
 * 新增菜单请求
 */
@Data
@Schema(description = "新增菜单请求")
public class MenuAddReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "父菜单 ID 0=顶级", example = "0")
    private Long parentId;

    @NotBlank(message = "菜单名称不能为空")
    @Schema(description = "菜单名称", example = "用户管理")
    private String name;

    @NotNull(message = "菜单类型不能为空")
    @Schema(description = "类型 1=目录 2=菜单 3=按钮", example = "2")
    private Integer type;

    @Schema(description = "路由路径", example = "/system/user")
    private String path;

    @Schema(description = "组件路径", example = "system/user/index")
    private String component;

    @Schema(description = "权限标识", example = "system:user:list")
    private String permission;

    @Schema(description = "图标", example = "user")
    private String icon;

    @Schema(description = "排序", example = "1")
    private Integer sort;

    @Schema(description = "是否可见 0=隐藏 1=显示", example = "1")
    private Integer visible;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;
}