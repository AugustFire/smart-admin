package com.smartadmin.modules.dev.dto.response;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 表字段信息响应
 */
@Data
public class DmColumnResp {

    /** 主键 ID */
    private Long id;

    /** 所属表ID */
    private Long tableId;

    /** 表名称 */
    private String tableName;

    /** 字段显示名称 */
    private String name;

    /** 字段编码 */
    private String code;

    /** 数据类型（varchar、bigint等） */
    private String dataType;

    /** 长度 */
    private Integer length;

    /** 是否主键 0=否 1=是 */
    private Integer isPrimary;

    /** 是否外键 0=否 1=是 */
    private Integer isForeign;

    /** 是否可空 0=否 1=是 */
    private Integer isNullable;

    /** 是否核心字段 0=否 1=是 */
    private Integer isCore;

    /** 是否自增 0=否 1=是 */
    private Integer isAutoIncrement;

    /** 是否唯一 0=否 1=是 */
    private Integer isUnique;

    /** 索引类型 none=无索引 normal=普通索引 unique=唯一索引 fulltext=全文索引 */
    private String indexType;

    /** 默认值 */
    private String defaultValue;

    /** 字段描述 */
    private String description;

    /** 排序 */
    private Integer sort;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;
}
