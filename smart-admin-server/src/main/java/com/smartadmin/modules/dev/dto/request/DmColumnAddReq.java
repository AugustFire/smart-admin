package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 字段新增请求
 */
@Data
public class DmColumnAddReq {

    /** 主键ID（批量保存时用于区分新增/更新） */
    private Long id;

    /** 所属表ID */
    @NotNull(message = "表ID不能为空")
    private Long tableId;

    /** 字段显示名称 */
    @NotBlank(message = "字段名称不能为空")
    private String name;

    /** 字段编码 */
    @NotBlank(message = "字段编码不能为空")
    private String code;

    /** 数据类型（varchar、bigint等） */
    private String dataType;

    /** 长度 */
    private Integer length;

    /** 是否主键 0=否 1=是 */
    private Integer isPrimary = 0;

    /** 是否外键 0=否 1=是 */
    private Integer isForeign = 0;

    /** 是否可空 0=否 1=是 */
    private Integer isNullable = 1;

    /** 是否核心字段 0=否 1=是 */
    private Integer isCore = 0;

    /** 是否自增 0=否 1=是 */
    private Integer isAutoIncrement = 0;

    /** 是否唯一 0=否 1=是 */
    private Integer isUnique = 0;

    /** 索引类型 none=无索引 normal=普通索引 unique=唯一索引 fulltext=全文索引 */
    private String indexType = "none";

    /** 默认值 */
    private String defaultValue;

    /** 字段描述 */
    private String description;

    /** 排序 */
    private Integer sort = 0;
}
