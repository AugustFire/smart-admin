package com.smartadmin.modules.system.dto.request;

import com.smartadmin.common.pojo.PageReq;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * 接口分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "接口分页查询请求")
public class ApiPageQueryReq extends PageReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "接口路径")
    private String path;

    @Schema(description = "请求方法")
    private String method;

    @Schema(description = "接口名称")
    private String name;

    @Schema(description = "关联菜单 ID")
    private Long menuId;

    @Schema(description = "状态")
    private Integer status;
}