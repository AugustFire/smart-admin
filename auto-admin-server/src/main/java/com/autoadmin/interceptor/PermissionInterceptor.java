package com.autoadmin.interceptor;

import com.autoadmin.common.exception.AuthorizationException;
import com.autoadmin.modules.system.entity.SysApi;
import com.autoadmin.modules.system.service.SysApiService;
import com.autoadmin.modules.system.service.SysRoleMenuService;
import com.autoadmin.modules.system.service.SysRoleService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Set;

/**
 * 权限拦截器
 * 检查用户是否有权限访问请求的接口
 * 权限验证流程：用户 → 角色 → 菜单 → 接口
 * 超级管理员（角色编码为 super_admin）默认拥有所有接口权限
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PermissionInterceptor implements HandlerInterceptor {

    private final SysApiService apiService;
    private final SysRoleService roleService;
    private final SysRoleMenuService roleMenuService;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String requestUri = request.getRequestURI();
        String method = request.getMethod();

        // 获取当前用户 ID（由 JwtInterceptor 设置）
        Long userId = (Long) request.getAttribute("userId");
        if (userId == null) {
            // 未登录，由 JwtInterceptor 处理
            return true;
        }

        // 检查是否为超级管理员
        if (roleService.isSuperAdmin(userId)) {
            log.debug("超级管理员用户 [{}] 访问接口 [{}] [{}]", userId, method, requestUri);
            return true;
        }

        // 获取用户的所有角色 ID
        Set<Long> roleIds = roleService.getRoleIdsByUserId(userId);
        if (roleIds.isEmpty()) {
            throw new AuthorizationException("用户未分配角色，无权访问");
        }

        // 获取用户的所有菜单 ID（通过角色获取）
        Set<Long> menuIds = roleMenuService.getMenuIdsByRoleIds(roleIds);
        if (menuIds.isEmpty()) {
            throw new AuthorizationException("用户未分配菜单权限，无权访问");
        }

        // 根据菜单 ID 获取用户的所有接口权限
        Set<SysApi> apis = apiService.getApisByMenuIds(menuIds);
        if (apis.isEmpty()) {
            throw new AuthorizationException("用户未分配接口权限，无权访问");
        }

        // 检查是否有访问权限
        boolean hasPermission = apis.stream()
                .anyMatch(api -> {
                    String apiUrl = api.getPath();
                    String apiMethod = api.getMethod();

                    // 匹配 URL 和方法
                    boolean urlMatch = pathMatcher.match(apiUrl, requestUri);
                    boolean methodMatch = apiMethod.equalsIgnoreCase(method);

                    return urlMatch && methodMatch;
                });

        if (!hasPermission) {
            log.warn("用户 [{}] 无权访问接口 [{}] [{}]", userId, method, requestUri);
            throw new AuthorizationException("无权访问该接口");
        }

        return true;
    }
}
