package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 数据表修改请求
 */
@Data
public class DmTableUpdateReq {

    /** 主键 ID */
    @NotNull(message = "ID不能为空")
    private Long id;

    /** 表显示名称 */
    @NotBlank(message = "表名称不能为空")
    private String name;

    /** 表描述 */
    private String description;

    /** 排序 */
    private Integer sort;

    /** 状态 0=禁用 1=正常 */
    private Integer status;
}
