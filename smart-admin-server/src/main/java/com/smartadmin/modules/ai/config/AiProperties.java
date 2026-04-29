package com.smartadmin.modules.ai.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * AI 配置属性
 */
@Data
@Component
@ConfigurationProperties(prefix = "ai")
public class AiProperties {

    /** AI 服务地址 */
    private String baseUrl = "http://localhost:8000";

    /** 连接超时时间（毫秒） */
    private int connectTimeout = 10000;

    /** 读取超时时间（毫秒） */
    private int readTimeout = 60000;
}
