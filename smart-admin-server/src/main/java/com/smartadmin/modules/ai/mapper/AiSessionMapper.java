package com.smartadmin.modules.ai.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.ai.entity.AiChatSession;
import org.apache.ibatis.annotations.Mapper;

/**
 * AI 会话 Mapper
 */
@Mapper
public interface AiSessionMapper extends BaseMapper<AiChatSession> {
}
