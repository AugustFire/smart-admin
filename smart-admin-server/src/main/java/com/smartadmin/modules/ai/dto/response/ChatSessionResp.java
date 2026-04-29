package com.smartadmin.modules.ai.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 会话响应
 */
@Data
@Schema(description = "会话响应")
public class ChatSessionResp {

    @Schema(description = "会话标识")
    private String sessionKey;

    @Schema(description = "会话标题")
    private String title;

    @Schema(description = "使用的模型")
    private String model;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
