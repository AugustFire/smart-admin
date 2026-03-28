package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 数据表新增请求
 */
@Data
public class DmTableAddReq {

    /** 所属数据库ID */
    @NotNull(message = "数据库ID不能为空")
    private Long databaseId;

    /** 表显示名称 */
    @NotBlank(message = "表名称不能为空")
    private String name;

    /** 表编码（如 sys_user） */
    @NotBlank(message = "表编码不能为空")
    private String code;

    /** 表描述 */
    private String description;

    /** 排序 */
    private Integer sort = 0;
}
