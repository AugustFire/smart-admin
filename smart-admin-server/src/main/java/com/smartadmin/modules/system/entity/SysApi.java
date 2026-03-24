package com.smartadmin.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 接口资源实体
 */
@Data
@TableName("sys_api")
public class SysApi implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主键 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 接口路径 */
    private String path;

    /** 请求方法 */
    private String method;

    /** 接口名称 */
    private String name;

    /** 是否公开接口：0=否，1=是（无需权限即可访问） */
    private Integer isPublic;

    /** 状态：1=启用，0=禁用 */
    private Integer status;

    /** 备注 */
    private String remark;

    /** 创建人 */
    private String creator;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新人 */
    private String updater;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    /** 删除标志：0=未删除，1=已删除 */
    @TableLogic
    private Integer deleted;
}