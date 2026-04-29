package com.smartadmin.modules.ai.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import java.time.Duration;

/**
 * AI 配置类
 */
@Configuration
@EnableConfigurationProperties(AiProperties.class)
public class AiConfig {

    @Bean
    public RestTemplate aiRestTemplate(AiProperties aiProperties) {
        RestTemplate restTemplate = new RestTemplate();
        // 可以在这里配置 RestTemplate 的超时时间等
        return restTemplate;
    }
}
