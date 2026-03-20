package com.autoadmin.modules.system.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 登录日志响应
 */
@Data
@Builder
@Schema(description = "登录日志响应")
public class LoginLogResp implements Serializable {

    private static final long serialVersionUID = 1L;

    @Schema(description = "日志 ID")
    private Long id;

    @Schema(description = "用户名")
    private String username;

    @Schema(description = "登录状态 0=失败 1=成功")
    private Integer loginStatus;

    @Schema(description = "IP 地址")
    private String ipAddress;

    @Schema(description = "登录地点")
    private String loginLocation;

    @Schema(description = "浏览器类型")
    private String browser;

    @Schema(description = "操作系统")
    private String os;

    @Schema(description = "提示信息")
    private String msg;

    @Schema(description = "登录时间")
    private LocalDateTime loginTime;
}