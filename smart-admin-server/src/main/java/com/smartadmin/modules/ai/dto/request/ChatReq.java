package com.smartadmin.modules.ai.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 聊天请求
 */
@Data
@Schema(description = "聊天请求")
public class ChatReq {

    @Schema(description = "会话标识，为空则创建新会话")
    private String sessionKey;

    @NotBlank(message = "消息内容不能为空")
    @Schema(description = "消息内容")
    private String content;
}
