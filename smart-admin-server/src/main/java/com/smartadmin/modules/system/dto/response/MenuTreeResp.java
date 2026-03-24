package com.smartadmin.modules.system.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 菜单树形响应
 */
@Data
@Builder
@Schema(description = "菜单树形响应")
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class MenuTreeResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "菜单 ID")
    private Long id;

    @Schema(description = "父菜单 ID")
    private Long parentId;

    @Schema(description = "菜单名称")
    private String name;

    @Schema(description = "类型 1=目录 2=菜单 3=按钮")
    private Integer type;

    @Schema(description = "路由路径")
    private String path;

    @Schema(description = "组件路径")
    private String component;

    @Schema(description = "权限标识")
    private String permission;

    @Schema(description = "图标")
    private String icon;

    @Schema(description = "排序")
    private Integer sort;

    @Schema(description = "是否可见 0=隐藏 1=显示")
    private Integer visible;

    @Schema(description = "子菜单列表")
    private List<MenuTreeResp> children;
}