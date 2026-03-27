package com.smartadmin.config;

import com.smartadmin.interceptor.JwtInterceptor;
import com.smartadmin.interceptor.PermissionInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Web 配置
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final JwtInterceptor jwtInterceptor;
    private final PermissionInterceptor permissionInterceptor;

    public WebConfig(JwtInterceptor jwtInterceptor, PermissionInterceptor permissionInterceptor) {
        this.jwtInterceptor = jwtInterceptor;
        this.permissionInterceptor = permissionInterceptor;
    }

    /**
     * 密码编码器 Bean
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    /**
     * 配置拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // JWT 拦截器
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/auth/login",           // 登录接口
                        "/doc.html",             // Knife4j 文档
                        "/webjars/**",           // Swagger 静态资源
                        "/v3/api-docs/**",       // OpenAPI 文档
                        "/favicon.ico"           // 图标
                )
                .order(1);

        // 权限拦截器
        registry.addInterceptor(permissionInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/auth/login",
                        "/auth/logout",          // 登出只需要登录，不需要额外权限
                        "/doc.html",             // Knife4j 文档
                        "/webjars/**",           // Swagger 静态资源
                        "/v3/api-docs/**",       // OpenAPI 文档
                        "/favicon.ico"           // 图标
                )
                .order(2);
    }

    /**
     * 跨域配置
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("http://localhost:*", "http://127.0.0.1:*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }

    /**
     * 静态资源配置
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Knife4j/Swagger 静态资源
        registry.addResourceHandler("doc.html")
                .addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

        // 其他静态资源
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
    }
}
