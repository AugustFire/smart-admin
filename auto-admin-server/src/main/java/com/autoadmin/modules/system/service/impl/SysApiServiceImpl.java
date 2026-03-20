package com.autoadmin.modules.system.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.system.entity.SysApi;
import com.autoadmin.modules.system.mapper.SysApiMapper;
import com.autoadmin.modules.system.service.SysApiService;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 接口资源服务实现
 */
@Service
public class SysApiServiceImpl extends BaseServiceImpl<SysApiMapper, SysApi> implements SysApiService {

    @Override
    public Set<SysApi> getApisByMenuIds(Set<Long> menuIds) {
        if (menuIds == null || menuIds.isEmpty()) {
            return new HashSet<>();
        }

        // 根据菜单 ID 列表查询关联的接口
        List<SysApi> apis = lambdaQuery()
                .in(SysApi::getMenuId, menuIds)
                .eq(SysApi::getStatus, 1) // 只查询启用的接口
                .list();

        return new HashSet<>(apis);
    }
}