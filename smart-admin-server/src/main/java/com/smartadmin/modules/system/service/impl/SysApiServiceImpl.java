package com.smartadmin.modules.system.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.system.entity.SysApi;
import com.smartadmin.modules.system.mapper.SysApiMapper;
import com.smartadmin.modules.system.service.SysApiService;
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
    public Set<SysApi> getApisByIds(Set<Long> apiIds) {
        if (apiIds == null || apiIds.isEmpty()) {
            return new HashSet<>();
        }

        List<SysApi> apis = lambdaQuery()
                .in(SysApi::getId, apiIds)
                .eq(SysApi::getStatus, 1)
                .list();

        return new HashSet<>(apis);
    }

    @Override
    public boolean isPublicApi(String path, String method) {
        return lambdaQuery()
                .eq(SysApi::getPath, path)
                .eq(SysApi::getMethod, method)
                .eq(SysApi::getIsPublic, 1)
                .eq(SysApi::getStatus, 1)
                .exists();
    }
}