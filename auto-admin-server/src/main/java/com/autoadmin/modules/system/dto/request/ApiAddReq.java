package com.autoadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 新增接口请求
 */
@Data
@Schema(description = "新增接口请求")
public class ApiAddReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotBlank(message = "接口路径不能为空")
    @Schema(description = "接口路径", example = "/api/user/list")
    private String path;

    @NotBlank(message = "请求方法不能为空")
    @Schema(description = "请求方法", example = "GET")
    private String method;

    @NotBlank(message = "接口名称不能为空")
    @Schema(description = "接口名称", example = "获取用户列表")
    private String name;

    @Schema(description = "关联的菜单 ID 列表（支持多选）", example = "[10, 11]")
    private List<Long> menuIds;

    @Schema(description = "是否公开接口：0=否，1=是", example = "0")
    private Integer isPublic;

    @Schema(description = "状态：1=启用，0=禁用", example = "1")
    private Integer status;

    @Schema(description = "备注", example = "")
    private String remark;
}