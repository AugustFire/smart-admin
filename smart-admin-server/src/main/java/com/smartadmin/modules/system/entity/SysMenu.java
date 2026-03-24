package com.smartadmin.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 菜单实体（目录、菜单页面、按钮）
 */
@Data
@TableName("sys_menu")
public class SysMenu implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 菜单 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 父菜单 ID 0=顶级 */
    private Long parentId;

    /** 菜单名称 */
    private String name;

    /** 类型 1=目录 2=菜单 3=按钮 */
    private Integer type;

    /** 路由路径 */
    private String path;

    /** 组件路径 */
    private String component;

    /** 权限标识 (如 user:add) */
    private String permission;

    /** 图标 */
    private String icon;

    /** 排序 */
    private Integer sort;

    /** 是否可见 0=隐藏 1=显示 */
    private Integer visible;

    /** 状态 0=禁用 1=正常 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 子节点 (不持久化到数据库) */
    @TableField(exist = false)
    private List<SysMenu> children = new ArrayList<>();
}