package com.smartadmin.modules.auth.biz;

import com.smartadmin.modules.auth.dto.request.LoginRequest;
import com.smartadmin.modules.auth.dto.response.LoginResponse;
import com.smartadmin.modules.auth.dto.response.UserInfoResponse;
import com.smartadmin.modules.system.entity.SysLoginLog;
import com.smartadmin.modules.system.entity.SysMenu;
import com.smartadmin.modules.system.service.SysMenuService;
import com.smartadmin.modules.system.dto.response.RoleInfo;
import com.smartadmin.modules.system.entity.SysRole;
import com.smartadmin.modules.system.service.SysRoleService;
import com.smartadmin.modules.system.entity.SysUser;
import com.smartadmin.modules.system.service.SysUserService;
import com.smartadmin.utils.JwtUtils;
import com.smartadmin.utils.PasswordUtils;
import com.smartadmin.modules.system.service.SysLoginLogService;
import com.smartadmin.utils.ServletUtils;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 认证业务类
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AuthBiz {

    private final SysUserService userService;
    private final SysRoleService roleService;
    private final SysMenuService menuService;
    private final SysLoginLogService loginLogService;
    private final JwtUtils jwtUtils;

    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        HttpServletRequest servletRequest = getCurrentRequest();
        String ip = servletRequest != null ? ServletUtils.getClientIP(servletRequest) : "";
        String browser = getBrowser(servletRequest);
        String os = getOs(servletRequest);

        // 查询用户
        SysUser user = userService.lambdaQuery()
                .eq(SysUser::getUsername, request.getUsername())
                .one();

        if (user == null) {
            log.warn("登录失败：用户 {} 不存在", request.getUsername());
            saveLoginLog(null, request.getUsername(), 0, ip, browser, os, "用户不存在");
            return null;
        }

        // 验证密码
        if (!PasswordUtils.matches(request.getPassword(), user.getPassword())) {
            log.warn("登录失败：用户 {} 密码错误", request.getUsername());
            saveLoginLog(user.getId(), user.getUsername(), 0, ip, browser, os, "密码错误");
            return null;
        }

        // 检查用户状态
        if (user.getStatus() == 0) {
            log.warn("登录失败：用户 {} 已被禁用", request.getUsername());
            saveLoginLog(user.getId(), user.getUsername(), 0, ip, browser, os, "账号已被禁用");
            return null;
        }

        // 生成 Token
        String token = jwtUtils.createToken(user.getId(), user.getUsername());

        // 记录登录成功日志
        saveLoginLog(user.getId(), user.getUsername(), 1, ip, browser, os, "登录成功");

        return LoginResponse.builder()
                .token(token)
                .tokenType("Bearer")
                .expiresIn(7200L)
                .userId(user.getId())
                .username(user.getUsername())
                .nickname(user.getNickname())
                .avatar(user.getAvatar())
                .build();
    }

    /**
     * 用户登出
     */
    public void logout(String username) {
        HttpServletRequest request = getCurrentRequest();
        String ip = request != null ? ServletUtils.getClientIP(request) : "";
        String browser = getBrowser(request);
        String os = getOs(request);

        // 查询用户获取 userId
        SysUser user = userService.lambdaQuery()
                .eq(SysUser::getUsername, username)
                .one();
        Long userId = user != null ? user.getId() : null;

        saveLoginLog(userId, username, 1, ip, browser, os, "退出成功");
    }

    /**
     * 获取当前请求
     */
    private HttpServletRequest getCurrentRequest() {
        ServletRequestAttributes attributes =
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attributes != null ? attributes.getRequest() : null;
    }

    /**
     * 保存登录日志
     */
    private void saveLoginLog(Long userId, String username, Integer status, String ip,
                              String browser, String os, String msg) {
        SysLoginLog loginLog = new SysLoginLog();
        loginLog.setUserId(userId);
        loginLog.setUsername(username);
        loginLog.setLoginStatus(status);
        loginLog.setIp(ip);
        loginLog.setAddress(""); // 暂不实现 IP 地址解析
        loginLog.setBrowser(browser);
        loginLog.setOs(os);
        loginLog.setMsg(msg);
        loginLog.setLoginTime(LocalDateTime.now());
        loginLogService.save(loginLog);
    }

    /**
     * 获取浏览器信息
     */
    private String getBrowser(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        String userAgent = request.getHeader("User-Agent");
        if (userAgent == null) {
            return "";
        }
        if (userAgent.contains("Edg")) {
            return "Microsoft Edge";
        } else if (userAgent.contains("Chrome")) {
            return "Chrome";
        } else if (userAgent.contains("Firefox")) {
            return "Firefox";
        } else if (userAgent.contains("Safari")) {
            return "Safari";
        } else if (userAgent.contains("Opera") || userAgent.contains("OPR")) {
            return "Opera";
        } else if (userAgent.contains("Trident") || userAgent.contains("MSIE")) {
            return "IE";
        }
        return "未知";
    }

    /**
     * 获取操作系统信息
     */
    private String getOs(HttpServletRequest request) {
        if (request == null) {
            return "";
        }
        String userAgent = request.getHeader("User-Agent");
        if (userAgent == null) {
            return "";
        }
        if (userAgent.contains("Windows")) {
            return "Windows";
        } else if (userAgent.contains("Mac")) {
            return "Mac OS";
        } else if (userAgent.contains("Linux")) {
            return "Linux";
        } else if (userAgent.contains("Android")) {
            return "Android";
        } else if (userAgent.contains("iPhone") || userAgent.contains("iPad")) {
            return "iOS";
        }
        return "未知";
    }

    /**
     * 获取当前用户信息
     */
    public UserInfoResponse getUserInfo(Long userId) {
        SysUser user = userService.getById(userId);
        if (user == null) {
            return null;
        }

        // 查询用户角色
        Set<SysRole> roles = roleService.getRolesByUserId(userId);

        List<RoleInfo> roleInfoList = null;
        if (roles != null && !roles.isEmpty()) {
            roleInfoList = roles.stream()
                    .map(role -> {
                        RoleInfo roleInfo = new RoleInfo();
                        roleInfo.setRoleId(role.getId());
                        roleInfo.setCode(role.getCode());
                        roleInfo.setName(role.getName());
                        return roleInfo;
                    })
                    .collect(Collectors.toList());
        }

        // 获取用户权限标识列表
        List<String> permissions = null;
        Set<SysRole> roleSet = roles;
        if (roleSet != null && !roleSet.isEmpty()) {
            // 检查是否为超级管理员
            boolean isSuperAdmin = roleSet.stream()
                    .anyMatch(role -> "super_admin".equals(role.getCode()));

            if (isSuperAdmin) {
                // 超级管理员拥有所有权限
                permissions = menuService.list().stream()
                        .map(SysMenu::getPermission)
                        .filter(p -> p != null && !p.isEmpty())
                        .collect(Collectors.toList());
            } else {
                // 获取用户的所有菜单（包括按钮）
                List<SysMenu> menus = menuService.getMenusByUserId(userId);
                permissions = menus.stream()
                        .map(SysMenu::getPermission)
                        .filter(p -> p != null && !p.isEmpty())
                        .collect(Collectors.toList());
            }
        }

        UserInfoResponse response = new UserInfoResponse();
        response.setUserId(user.getId());
        response.setUsername(user.getUsername());
        response.setNickname(user.getNickname());
        response.setAvatar(user.getAvatar());
        response.setRoles(roleInfoList);
        response.setPermissions(permissions);

        return response;
    }

    /**
     * 获取用户菜单权限
     */
    public List<SysMenu> getUserMenus(Long userId) {
        return menuService.getMenuTreeByUserId(userId);
    }

    /**
     * 刷新令牌
     */
    public String refreshToken(String refreshToken) {
        // TODO: 实现刷新令牌逻辑
        return null;
    }
}