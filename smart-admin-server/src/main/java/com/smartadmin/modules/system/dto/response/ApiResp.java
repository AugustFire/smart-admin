package com.smartadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 接口资源响应
 */
@Data
@Builder
@Schema(description = "接口资源响应")
public class ApiResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "接口 ID")
    private Long id;

    @Schema(description = "接口路径")
    private String path;

    @Schema(description = "请求方法")
    private String method;

    @Schema(description = "接口名称")
    private String name;

    @Schema(description = "是否公开接口：0=否，1=是")
    private Integer isPublic;

    @Schema(description = "关联的菜单 ID 列表")
    private List<Long> menuIds;

    @Schema(description = "关联的菜单名称列表")
    private List<String> menuNames;

    @Schema(description = "状态：1=启用，0=禁用")
    private Integer status;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "创建人")
    private String creator;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;

    @Schema(description = "更新人")
    private String updater;

    @Schema(description = "更新时间")
    private LocalDateTime updateTime;
}