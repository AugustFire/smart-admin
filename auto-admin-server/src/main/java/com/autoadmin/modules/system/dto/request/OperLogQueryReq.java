package com.autoadmin.modules.system.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

/**
 * 操作日志查询请求
 */
@Data
@Schema(description = "操作日志查询请求")
public class OperLogQueryReq {

    @Schema(description = "页码", example = "1")
    private Integer pageNum = 1;

    @Schema(description = "每页数量", example = "10")
    private Integer pageSize = 10;

    @Schema(description = "系统模块（模糊）", example = "用户管理")
    private String title;

    @Schema(description = "操作人员（模糊）", example = "admin")
    private String operName;

    @Schema(description = "业务类型", example = "1")
    private Integer businessType;

    @Schema(description = "操作状态 0=失败 1=成功", example = "1")
    private Integer status;

    @Schema(description = "开始时间")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;

    @Schema(description = "结束时间")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;
}