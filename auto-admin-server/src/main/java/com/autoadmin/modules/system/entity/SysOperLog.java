package com.autoadmin.modules.system.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 操作日志实体
 */
@Data
@TableName("sys_oper_log")
public class SysOperLog implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 主键 ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 模块标题 */
    private String title;

    /** 业务类型 0=其它 1=新增 2=修改 3=删除 */
    private Integer businessType;

    /** 方法名称 */
    private String method;

    /** 请求方式 */
    private String requestMethod;

    /** 操作人员 */
    private String operName;

    /** 主机地址 */
    private String operIp;

    /** 操作地点 */
    private String operLocation;

    /** 部门名称 */
    private String deptName;

    /** 请求 URL */
    private String operUrl;

    /** 请求参数 */
    private String operParam;

    /** 返回参数 */
    private String jsonResult;

    /** 操作状态 0=失败 1=成功 */
    private Integer status;

    /** 错误消息 */
    private String errorMsg;

    /** 操作时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime operTime;

    /** 消耗时间 (毫秒) */
    private Long costTime;
}