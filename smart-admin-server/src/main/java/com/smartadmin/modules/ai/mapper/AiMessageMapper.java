package com.smartadmin.modules.ai.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.ai.entity.AiChatMessage;
import org.apache.ibatis.annotations.Mapper;

/**
 * AI 消息 Mapper
 */
@Mapper
public interface AiMessageMapper extends BaseMapper<AiChatMessage> {
}
