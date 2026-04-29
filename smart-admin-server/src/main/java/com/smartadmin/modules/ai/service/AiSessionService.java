package com.smartadmin.modules.ai.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.smartadmin.modules.ai.entity.AiChatSession;

/**
 * AI 会话服务接口
 */
public interface AiSessionService extends IService<AiChatSession> {

    /**
     * 根据 sessionKey 获取会话
     */
    AiChatSession getBySessionKey(String sessionKey);

    /**
     * 根据 sessionKey 删除会话
     */
    void deleteBySessionKey(String sessionKey);

    /**
     * 创建新会话
     */
    AiChatSession createSession(Long userId);
}
