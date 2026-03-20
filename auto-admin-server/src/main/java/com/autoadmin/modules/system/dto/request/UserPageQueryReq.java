package com.autoadmin.modules.system.dto.request;

import com.autoadmin.common.pojo.PageReq;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * 用户分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "用户分页查询请求")
public class UserPageQueryReq extends PageReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "用户名（模糊）", example = "admin")
    private String username;

    @Schema(description = "手机号", example = "13800138000")
    private String phone;

    @Schema(description = "状态 0=禁用 1=正常", example = "1")
    private Integer status;

    @Schema(description = "部门 ID", example = "1")
    private Long deptId;
}