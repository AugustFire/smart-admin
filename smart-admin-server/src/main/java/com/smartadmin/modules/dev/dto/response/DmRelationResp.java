package com.smartadmin.modules.dev.dto.response;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 表关系信息响应
 */
@Data
public class DmRelationResp {

    /** 主键 ID */
    private Long id;

    /** 源表ID */
    private Long sourceTableId;

    /** 源表名称 */
    private String sourceTableName;

    /** 源表编码 */
    private String sourceTableCode;

    /** 源字段ID */
    private Long sourceColumnId;

    /** 源字段编码 */
    private String sourceColumnCode;

    /** 目标表ID */
    private Long targetTableId;

    /** 目标表名称 */
    private String targetTableName;

    /** 目标表编码 */
    private String targetTableCode;

    /** 目标字段ID */
    private Long targetColumnId;

    /** 目标字段编码 */
    private String targetColumnCode;

    /** 关系类型：ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE、MANY_TO_MANY */
    private String relationType;

    /** 关系类型描述 */
    private String relationTypeName;

    /** 关系描述 */
    private String description;

    /** 创建时间 */
    private LocalDateTime createTime;

    /** 更新时间 */
    private LocalDateTime updateTime;
}
