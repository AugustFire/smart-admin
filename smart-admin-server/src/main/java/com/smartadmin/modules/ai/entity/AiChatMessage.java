package com.smartadmin.modules.ai.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AI 聊天消息实体
 */
@Data
@TableName("ai_chat_message")
public class AiChatMessage {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 会话ID */
    private Long sessionId;

    /** 用户ID */
    private Long userId;

    /** 角色：user/assistant/system */
    private String role;

    /** 消息内容 */
    private String content;

    /** 使用的模型 */
    private String model;

    /** 消耗的 token 数 */
    private Integer tokens;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
