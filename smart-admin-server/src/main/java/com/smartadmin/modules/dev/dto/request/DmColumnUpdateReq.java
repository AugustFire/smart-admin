package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 字段修改请求
 */
@Data
public class DmColumnUpdateReq {

    /** 主键 ID */
    @NotNull(message = "ID不能为空")
    private Long id;

    /** 字段显示名称 */
    private String name;

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
}
