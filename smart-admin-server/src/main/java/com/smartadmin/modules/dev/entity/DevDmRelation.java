package com.smartadmin.modules.dev.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 数据模型-表关系信息表
 */
@Data
@TableName("dev_dm_relation")
public class DevDmRelation {

    /** 主键 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 源表ID */
    private Long sourceTableId;

    /** 源字段ID */
    private Long sourceColumnId;

    /** 目标表ID */
    private Long targetTableId;

    /** 目标字段ID */
    private Long targetColumnId;

    /** 关系类型：ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE、MANY_TO_MANY */
    private String relationType;

    /** 关系描述 */
    private String description;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 删除标志 0=未删除 1=已删除 */
    @TableLogic
    private Integer deleted;
}
