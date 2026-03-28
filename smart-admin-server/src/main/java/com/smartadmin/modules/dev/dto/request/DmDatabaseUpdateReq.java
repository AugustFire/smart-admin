package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 数据库修改请求
 */
@Data
public class DmDatabaseUpdateReq {

    /** 主键 ID */
    @NotNull(message = "ID不能为空")
    private Long id;

    /** 数据库显示名称 */
    @NotBlank(message = "数据库名称不能为空")
    private String name;

    /** 数据库类型：mysql、sqlserver、postgresql */
    private String type;

    /** 描述 */
    private String description;

    /** 排序 */
    private Integer sort;

    /** 状态 0=禁用 1=正常 */
    private Integer status;
}
