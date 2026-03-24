package com.smartadmin.interceptor;

import com.smartadmin.common.exception.AuthenticationException;
import com.smartadmin.config.JwtProperties;
import com.smartadmin.utils.JwtUtils;
import com.smartadmin.utils.UserContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.List;

/**
 * JWT 拦截器
 * 验证 Token 有效性，将用户信息存入 UserContext
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtInterceptor implements HandlerInterceptor {

    private final JwtUtils jwtUtils;
    private final JwtProperties jwtProperties;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    /**
     * 白名单路径（不需要 Token）
     */
    private static final List<String> WHITE_LIST = List.of(
            "/auth/login",
            "/auth/logout",
            "/doc.html",
            "/webjars/**",
            "/v3/api-docs/**",
            "/favicon.ico",
            "/error"
    );

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String requestUri = request.getRequestURI();

        // 检查是否在白名单中
        for (String pattern : WHITE_LIST) {
            if (pathMatcher.match(pattern, requestUri)) {
                return true;
            }
        }

        // 获取 Token
        String token = resolveToken(request);
        if (token == null) {
            throw new AuthenticationException("未提供 Token");
        }

        // 验证 Token
        if (!jwtUtils.validateToken(token)) {
            throw new AuthenticationException("Token 无效或已过期");
        }

        // 将用户信息存入 UserContext
        Long userId = jwtUtils.getUserIdFromToken(token);
        String username = jwtUtils.getUsernameFromToken(token);
        UserContext.setUserId(userId);
        UserContext.setUsername(username);

        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        // 清理 UserContext，防止内存泄漏
        UserContext.clear();
    }

    /**
     * 从请求中解析 Token
     */
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader(jwtProperties.getHeader());
        if (bearerToken != null && bearerToken.startsWith(jwtProperties.getPrefix())) {
            return bearerToken.substring(jwtProperties.getPrefix().length()).trim();
        }
        return null;
    }
}
