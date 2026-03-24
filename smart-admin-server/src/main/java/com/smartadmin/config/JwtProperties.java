package com.smartadmin.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * JWT 配置属性
 */
@Data
@Component
@ConfigurationProperties(prefix = "jwt")
public class JwtProperties {

    /**
     * JWT 密钥
     */
    private String secret;

    /**
     * 过期时间 (毫秒) 默认 2 小时
     */
    private Long expiration = 7200000L;

    /**
     * Token 前缀
     */
    private String prefix = "Bearer ";

    /**
     * Header 名
     */
    private String header = "Authorization";
}
