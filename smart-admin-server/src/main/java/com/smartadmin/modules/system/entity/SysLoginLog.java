package com.smartadmin.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 登录日志实体
 */
@Data
@TableName("sys_login_log")
public class SysLoginLog implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主键 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户 ID */
    private Long userId;

    /** 用户名 */
    private String username;

    /** 登录状态 0=失败 1=成功 */
    private Integer loginStatus;

    /** 登录 IP */
    private String ip;

    /** 登录地点 */
    private String address;

    /** 浏览器 */
    private String browser;

    /** 操作系统 */
    private String os;

    /** 提示信息 */
    private String msg;

    /** 登录时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime loginTime;
}