package com.smartadmin.modules.ai.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.smartadmin.modules.ai.entity.AiChatMessage;
import java.util.List;

/**
 * AI 消息服务接口
 */
public interface AiMessageService extends IService<AiChatMessage> {

    /**
     * 获取会话的所有消息
     */
    List<AiChatMessage> getBySessionId(Long sessionId);
}
