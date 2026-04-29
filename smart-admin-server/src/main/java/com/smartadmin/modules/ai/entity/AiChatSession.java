package com.smartadmin.modules.ai.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AI 聊天会话实体
 */
@Data
@TableName("ai_chat_session")
public class AiChatSession {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 会话唯一标识 */
    private String sessionKey;

    /** 用户ID */
    private Long userId;

    /** 会话标题 */
    private String title;

    /** 使用的模型 */
    private String model;

    /** 状态：0=禁用 1=正常 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
