package com.smartadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 操作日志响应
 */
@Data
@Builder
@Schema(description = "操作日志响应")
public class OperLogResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "日志 ID")
    private Long operId;

    @Schema(description = "系统模块")
    private String title;

    @Schema(description = "业务类型")
    private Integer businessType;

    @Schema(description = "请求方法")
    private String method;

    @Schema(description = "操作人员")
    private String operName;

    @Schema(description = "部门名称")
    private String deptName;

    @Schema(description = "请求 URL")
    private String operUrl;

    @Schema(description = "主机地址")
    private String operIp;

    @Schema(description = "操作地点")
    private String operLocation;

    @Schema(description = "请求参数")
    private String operParam;

    @Schema(description = "返回参数")
    private String jsonResult;

    @Schema(description = "操作状态 0=失败 1=成功")
    private Integer status;

    @Schema(description = "错误消息")
    private String errorMsg;

    @Schema(description = "操作时间")
    private LocalDateTime operTime;

    @Schema(description = "执行时间（毫秒）")
    private Long costTime;
}