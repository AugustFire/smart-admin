package com.autoadmin.modules.system.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.system.entity.SysRole;
import com.autoadmin.modules.system.mapper.SysRoleMapper;
import com.autoadmin.modules.system.service.SysRoleService;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 角色基础服务实现
 */
@Service
public class SysRoleServiceImpl extends BaseServiceImpl<SysRoleMapper, SysRole> implements SysRoleService {

    private static final String SUPER_ADMIN_CODE = "super_admin";

    @Override
    public Set<Long> getRoleIdsByUserId(Long userId) {
        Set<SysRole> roles = getRolesByUserId(userId);
        return roles.stream()
                .map(SysRole::getId)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<SysRole> getRolesByUserId(Long userId) {
        // 通过 Mapper 查询用户的角色 ID 列表
        List<Long> roleIdList = baseMapper.selectRoleIdsByUserId(userId);
        if (roleIdList.isEmpty()) {
            return Collections.emptySet();
        }
        Set<Long> roleIds = roleIdList.stream().collect(Collectors.toSet());
        return lambdaQuery()
                .in(SysRole::getId, roleIds)
                .list()
                .stream()
                .collect(Collectors.toSet());
    }

    @Override
    public Set<String> getRoleCodesByUserId(Long userId) {
        Set<SysRole> roles = getRolesByUserId(userId);
        return roles.stream()
                .map(SysRole::getCode)
                .collect(Collectors.toSet());
    }

    @Override
    public boolean isSuperAdmin(Long userId) {
        return getRoleCodesByUserId(userId).contains(SUPER_ADMIN_CODE);
    }
}