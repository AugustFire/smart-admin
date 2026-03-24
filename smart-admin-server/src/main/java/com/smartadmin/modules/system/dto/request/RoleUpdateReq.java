package com.smartadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.io.Serializable;

/**
 * 更新角色请求
 */
@Data
@Schema(description = "更新角色请求")
public class RoleUpdateReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @NotNull(message = "角色 ID 不能为空")
    @Schema(description = "角色 ID", example = "1")
    private Long roleId;

    @NotBlank(message = "角色名称不能为空")
    @Size(max = 30, message = "角色名称长度不能超过 30 个字符")
    @Schema(description = "角色名称", example = "管理员")
    private String name;

    @NotBlank(message = "角色编码不能为空")
    @Size(max = 50, message = "角色编码长度不能超过 50 个字符")
    @Schema(description = "角色编码", example = "admin")
    private String code;

    @Schema(description = "排序", example = "1")
    private Integer sort;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;

    @Schema(description = "备注", example = "超级管理员")
    private String remark;
}