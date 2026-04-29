package com.smartadmin.modules.ai.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartadmin.modules.ai.entity.AiChatSession;
import com.smartadmin.modules.ai.mapper.AiSessionMapper;
import com.smartadmin.modules.ai.service.AiSessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * AI 会话服务实现
 */
@Service
@RequiredArgsConstructor
public class AiSessionServiceImpl extends ServiceImpl<AiSessionMapper, AiChatSession> implements AiSessionService {

    @Override
    public AiChatSession getBySessionKey(String sessionKey) {
        return lambdaQuery().eq(AiChatSession::getSessionKey, sessionKey).one();
    }

    @Override
    public void deleteBySessionKey(String sessionKey) {
        lambdaUpdate().eq(AiChatSession::getSessionKey, sessionKey).remove();
    }

    @Override
    public AiChatSession createSession(Long userId) {
        AiChatSession session = new AiChatSession();
        session.setSessionKey(UUID.randomUUID().toString().replace("-", ""));
        session.setUserId(userId);
        session.setTitle("新对话");
        session.setModel("deepseek-chat");
        session.setStatus(1);
        save(session);
        return session;
    }
}
