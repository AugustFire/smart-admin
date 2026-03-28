package com.smartadmin.modules.dev.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 数据模型-数据表信息表
 */
@Data
@TableName("dev_dm_table")
public class DevDmTable {

    /** 主键 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属数据库ID */
    private Long databaseId;

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
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 删除标志 0=未删除 1=已删除 */
    @TableLogic
    private Integer deleted;
}
