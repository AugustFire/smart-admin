package com.smartadmin.modules.dev.dto.response;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 数据库信息响应
 */
@Data
public class DmDatabaseResp {

    /** 主键 ID */
    private Long id;

    /** 数据库显示名称 */
    private String name;

    /** 数据库编码（唯一标识） */
    private String code;

    /** 数据库类型：mysql、sqlserver、postgresql */
    private String type;

    /** 描述 */
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
