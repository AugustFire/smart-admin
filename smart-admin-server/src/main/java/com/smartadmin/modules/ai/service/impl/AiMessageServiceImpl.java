package com.smartadmin.modules.ai.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartadmin.modules.ai.entity.AiChatMessage;
import com.smartadmin.modules.ai.mapper.AiMessageMapper;
import com.smartadmin.modules.ai.service.AiMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * AI 消息服务实现
 */
@Service
@RequiredArgsConstructor
public class AiMessageServiceImpl extends ServiceImpl<AiMessageMapper, AiChatMessage> implements AiMessageService {

    @Override
    public List<AiChatMessage> getBySessionId(Long sessionId) {
        return lambdaQuery()
                .eq(AiChatMessage::getSessionId, sessionId)
                .orderByAsc(AiChatMessage::getCreateTime)
                .list();
    }
}
