package com.smartadmin.modules.system.dto.request;

import com.smartadmin.common.pojo.PageReq;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * 角色分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "角色分页查询请求")
public class RolePageQueryReq extends PageReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "角色名称（模糊）", example = "管理员")
    private String name;

    @Schema(description = "角色编码（模糊）", example = "admin")
    private String code;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;
}