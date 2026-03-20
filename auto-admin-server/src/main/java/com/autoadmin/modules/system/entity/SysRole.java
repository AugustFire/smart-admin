package com.autoadmin.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 角色实体
 */
@Data
@TableName("sys_role")
public class SysRole implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 角色 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 角色名称 */
    private String name;

    /** 角色编码 */
    private String code;

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