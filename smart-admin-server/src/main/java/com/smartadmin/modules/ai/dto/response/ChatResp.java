package com.smartadmin.modules.ai.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 聊天响应
 */
@Data
@Schema(description = "聊天响应")
public class ChatResp {

    @Schema(description = "会话标识")
    private String sessionKey;

    @Schema(description = "消息内容")
    private String content;

    @Schema(description = "角色：user/assistant")
    private String role;

    @Schema(description = "使用的模型")
    private String model;

    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
