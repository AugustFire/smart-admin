package com.smartadmin.modules.system.biz;

import com.smartadmin.common.exception.BusinessException;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.modules.system.dto.response.RoleInfo;
import com.smartadmin.modules.system.dto.request.UserAddReq;
import com.smartadmin.modules.system.dto.request.UserPageQueryReq;
import com.smartadmin.modules.system.dto.request.UserResetPwdReq;
import com.smartadmin.modules.system.dto.request.UserUpdateReq;
import com.smartadmin.modules.system.dto.response.UserResp;
import com.smartadmin.modules.system.entity.SysRole;
import com.smartadmin.modules.system.entity.SysUser;
import com.smartadmin.modules.system.mapper.UserConverter;
import com.smartadmin.modules.system.service.SysUserRoleService;
import com.smartadmin.modules.system.service.SysUserService;
import com.smartadmin.modules.system.service.SysRoleService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 用户管理业务类
 * 组合多个 Service 完成复杂业务逻辑
 */
@Component
@RequiredArgsConstructor
public class UserBiz {

    private final SysUserService userService;
    private final SysUserRoleService userRoleService;
    private final SysRoleService roleService;
    private final PasswordEncoder passwordEncoder;

    /**
     * 新增用户
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addUser(UserAddReq req) {
        // 校验用户名是否存在
        if (userService.existsByUsername(req.getUsername())) {
            throw new BusinessException("用户名已存在");
        }

        // DTO -> Entity
        SysUser user = UserConverter.INSTANCE.toEntity(req);
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        if (req.getStatus() == null) {
            user.setStatus(1);
        }

        // 保存用户
        userService.save(user);

        // 处理角色关联
        if (req.getRoleIds() != null && !req.getRoleIds().isEmpty()) {
            userRoleService.assignRoles(user.getId(), req.getRoleIds());
        }

        return user.getId();
    }

    /**
     * 获取用户详情
     */
    public UserResp getUserById(Long id) {
        SysUser user = userService.getByIdOrThrow(id);

        UserResp.UserRespBuilder builder = UserConverter.INSTANCE.toResp(user).toBuilder();
        builder.roles(getUserRoles(user.getId()));

        return builder.build();
    }

    /**
     * 分页查询用户
     */
    public PageResp<UserResp> pageUsers(UserPageQueryReq req) {
        // 构建分页查询
        IPage<SysUser> page = userService.lambdaQuery()
                .like(req.getUsername() != null && !req.getUsername().isEmpty(),
                        SysUser::getUsername, req.getUsername())
                .like(req.getPhone() != null && !req.getPhone().isEmpty(),
                        SysUser::getPhone, req.getPhone())
                .eq(req.getStatus() != null, SysUser::getStatus, req.getStatus())
                .orderByDesc(SysUser::getCreateTime)
                .page(new Page<>(req.getPageNum(), req.getPageSize()));

        // Entity -> DTO 转换
        List<UserResp> userRespList = page.getRecords().stream()
                .map(user -> UserConverter.INSTANCE.toResp(user).toBuilder()
                        .roles(getUserRoles(user.getId()))
                        .build())
                .collect(Collectors.toList());

        return PageResp.of(userRespList, page.getTotal(), (int) page.getCurrent(), (int) page.getSize());
    }

    /**
     * 更新用户
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateUser(UserUpdateReq req) {
        // 检查用户是否存在
        userService.getByIdOrThrow(req.getUserId());

        // 检查用户名是否被其他用户使用
        if (userService.existsByUsername(req.getUsername(), req.getUserId())) {
            throw new BusinessException("用户名已存在");
        }

        // 更新用户
        SysUser user = new SysUser();
        user.setId(req.getUserId());
        user.setUsername(req.getUsername());
        user.setNickname(req.getNickname());
        user.setAvatar(req.getAvatar());
        user.setEmail(req.getEmail());
        user.setPhone(req.getPhone());
        user.setSex(req.getSex());
        user.setStatus(req.getStatus());
        userService.updateById(user);

        // 处理角色关联
        if (req.getRoleIds() != null) {
            userRoleService.assignRoles(req.getUserId(), req.getRoleIds());
        }
    }

    /**
     * 删除用户
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteUser(Long id) {
        userService.getByIdOrThrow(id);

        // 删除用户（逻辑删除）
        userService.removeById(id);

        // 删除用户角色关联
        userRoleService.deleteByUserId(id);
    }

    /**
     * 重置密码
     */
    @Transactional(rollbackFor = Exception.class)
    public void resetPassword(UserResetPwdReq req) {
        userService.getByIdOrThrow(req.getUserId());

        SysUser user = new SysUser();
        user.setId(req.getUserId());
        user.setPassword(passwordEncoder.encode(req.getPassword()));
        userService.updateById(user);
    }

    /**
     * 获取用户的角色 ID 列表
     */
    public List<Long> getRoleIdsByUserId(Long userId) {
        return userRoleService.getRoleIdsByUserId(userId);
    }

    /**
     * 给用户分配角色
     */
    @Transactional(rollbackFor = Exception.class)
    public void assignRoles(Long userId, List<Long> roleIds) {
        // 验证用户存在
        userService.getByIdOrThrow(userId);
        // 分配角色
        userRoleService.assignRoles(userId, roleIds);
    }

    /**
     * 获取用户角色列表
     */
    private List<RoleInfo> getUserRoles(Long userId) {
        List<Long> roleIds = userRoleService.getRoleIdsByUserId(userId);
        if (roleIds.isEmpty()) {
            return List.of();
        }

        List<SysRole> roles = roleService.listByIds(roleIds);
        return roles.stream()
                .map(role -> {
                    RoleInfo roleInfo = new RoleInfo();
                    roleInfo.setRoleId(role.getId());
                    roleInfo.setCode(role.getCode());
                    roleInfo.setName(role.getName());
                    return roleInfo;
                })
                .collect(Collectors.toList());
    }
}