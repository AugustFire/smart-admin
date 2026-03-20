package com.autoadmin.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 角色菜单关联实体
 */
@Data
@TableName("sys_role_menu")
public class SysRoleMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主键 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 角色 ID */
    private Long roleId;

    /** 菜单 ID */
    private Long menuId;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 删除标志 0=未删除 1=已删除 */
    @TableLogic
    private Integer deleted;
}