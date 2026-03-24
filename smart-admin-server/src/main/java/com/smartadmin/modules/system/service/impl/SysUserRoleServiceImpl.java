package com.smartadmin.modules.system.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.system.entity.SysUserRole;
import com.smartadmin.modules.system.mapper.SysUserRoleMapper;
import com.smartadmin.modules.system.service.SysUserRoleService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 用户角色关联服务实现
 */
@Service
public class SysUserRoleServiceImpl extends BaseServiceImpl<SysUserRoleMapper, SysUserRole> implements SysUserRoleService {

    @Override
    public List<Long> getRoleIdsByUserId(Long userId) {
        List<SysUserRole> userRoles = lambdaQuery()
                .eq(SysUserRole::getUserId, userId)
                .list();
        if (userRoles.isEmpty()) {
            return new ArrayList<>();
        }
        return userRoles.stream()
                .map(SysUserRole::getRoleId)
                .collect(Collectors.toList());
    }

    @Override
    public void assignRoles(Long userId, List<Long> roleIds) {
        // 删除原有角色
        deleteByUserId(userId);

        // 添加新角色
        if (roleIds != null && !roleIds.isEmpty()) {
            List<SysUserRole> userRoles = roleIds.stream()
                    .map(roleId -> {
                        SysUserRole userRole = new SysUserRole();
                        userRole.setUserId(userId);
                        userRole.setRoleId(roleId);
                        return userRole;
                    })
                    .collect(Collectors.toList());
            saveBatch(userRoles);
        }
    }
}