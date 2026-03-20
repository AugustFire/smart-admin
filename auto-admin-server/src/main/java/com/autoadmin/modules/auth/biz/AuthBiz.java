package com.autoadmin.modules.auth.biz;

import com.autoadmin.modules.auth.dto.request.LoginRequest;
import com.autoadmin.modules.auth.dto.response.LoginResponse;
import com.autoadmin.modules.auth.dto.response.UserInfoResponse;
import com.autoadmin.modules.system.entity.SysMenu;
import com.autoadmin.modules.system.service.SysMenuService;
import com.autoadmin.modules.system.dto.response.RoleInfo;
import com.autoadmin.modules.system.entity.SysRole;
import com.autoadmin.modules.system.service.SysRoleService;
import com.autoadmin.modules.system.entity.SysUser;
import com.autoadmin.modules.system.service.SysUserService;
import com.autoadmin.utils.JwtUtils;
import com.autoadmin.utils.PasswordUtils;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

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
    private final JwtUtils jwtUtils;

    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        // 查询用户
        SysUser user = userService.lambdaQuery()
                .eq(SysUser::getUsername, request.getUsername())
                .one();

        if (user == null) {
            log.warn("登录失败：用户 {} 不存在", request.getUsername());
            return null;
        }

        // 验证密码
        if (!PasswordUtils.matches(request.getPassword(), user.getPassword())) {
            log.warn("登录失败：用户 {} 密码错误", request.getUsername());
            return null;
        }

        // 检查用户状态
        if (user.getStatus() == 0) {
            log.warn("登录失败：用户 {} 已被禁用", request.getUsername());
            return null;
        }

        // 生成 Token
        String token = jwtUtils.createToken(user.getId(), user.getUsername());

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

        UserInfoResponse response = new UserInfoResponse();
        response.setUserId(user.getId());
        response.setUsername(user.getUsername());
        response.setNickname(user.getNickname());
        response.setAvatar(user.getAvatar());
        response.setRoles(roleInfoList);

        // TODO: 获取权限标识列表

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