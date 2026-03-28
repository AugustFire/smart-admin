package com.smartadmin.modules.dev.dto.response;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 数据表信息响应
 */
@Data
public class DmTableResp {

    /** 主键 ID */
    private Long id;

    /** 所属数据库ID */
    private Long databaseId;

    /** 数据库名称 */
    private String databaseName;

    /** 表显示名称 */
    private String name;

    /** 表编码（如 sys_user） */
    private String code;

    /** 表描述 */
    private String description;

    /** 排序 */
    private Integer sort;

    /** 状态 0=禁用 1=正常 */
    private Integer status;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;
}
