package com.smartadmin.interceptor;

import com.smartadmin.common.exception.AuthorizationException;
import com.smartadmin.modules.system.entity.SysApi;
import com.smartadmin.modules.system.service.SysApiService;
import com.smartadmin.modules.system.service.SysMenuApiService;
import com.smartadmin.modules.system.service.SysRoleMenuService;
import com.smartadmin.modules.system.service.SysRoleService;
import com.smartadmin.utils.UserContext;
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
 * 权限验证流程：
 * 1. 检查是否为公开接口（is_public=1）→ 直接放行
 * 2. 检查用户 → 角色 → 菜单 → 菜单接口关联 → 接口
 * 超级管理员（角色编码为 super_admin）默认拥有所有接口权限
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PermissionInterceptor implements HandlerInterceptor {

    private final SysApiService apiService;
    private final SysRoleService roleService;
    private final SysRoleMenuService roleMenuService;
    private final SysMenuApiService menuApiService;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        String requestUri = request.getRequestURI();
        String method = request.getMethod();

        // 1. 优先检查是否为公开接口
        if (apiService.isPublicApi(requestUri, method)) {
            log.debug("公开接口访问 [{}] [{}]", method, requestUri);
            return true;
        }

        // 2. 获取当前用户 ID（由 UserContext 提供）
        Long userId = UserContext.getUserId();
        if (userId == null) {
            throw new AuthorizationException("未登录或登录已过期");
        }

        // 3. 检查是否为超级管理员
        if (roleService.isSuperAdmin(userId)) {
            log.debug("超级管理员用户 [{}] 访问接口 [{}] [{}]", userId, method, requestUri);
            return true;
        }

        // 4. 获取用户的所有角色 ID
        Set<Long> roleIds = roleService.getRoleIdsByUserId(userId);
        if (roleIds.isEmpty()) {
            throw new AuthorizationException("用户未分配角色，无权访问");
        }

        // 5. 获取用户的所有菜单 ID（通过角色获取）
        Set<Long> menuIds = roleMenuService.getMenuIdsByRoleIds(roleIds);
        if (menuIds.isEmpty()) {
            throw new AuthorizationException("用户未分配菜单权限，无权访问");
        }

        // 6. 根据菜单 ID 获取接口 ID 列表（通过中间表）
        Set<Long> apiIds = menuApiService.getApiIdsByMenuIds(menuIds);
        if (apiIds.isEmpty()) {
            throw new AuthorizationException("用户未分配接口权限，无权访问");
        }

        // 7. 根据接口 ID 获取接口详情
        Set<SysApi> apis = apiService.getApisByIds(apiIds);
        if (apis.isEmpty()) {
            throw new AuthorizationException("用户未分配接口权限，无权访问");
        }

        // 8. 检查是否有访问权限
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
