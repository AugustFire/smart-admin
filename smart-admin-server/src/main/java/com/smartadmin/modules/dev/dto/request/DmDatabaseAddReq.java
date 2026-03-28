package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 数据库新增请求
 */
@Data
public class DmDatabaseAddReq {

    /** 数据库显示名称 */
    @NotBlank(message = "数据库名称不能为空")
    private String name;

    /** 数据库编码（唯一标识） */
    @NotBlank(message = "数据库编码不能为空")
    private String code;

    /** 数据库类型：mysql、sqlserver、postgresql */
    @NotBlank(message = "数据库类型不能为空")
    private String type = "mysql";

    /** 描述 */
    private String description;

    /** 排序 */
    private Integer sort = 0;
}
