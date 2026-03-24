package com.autoadmin.modules.system.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.system.entity.SysMenuApi;
import com.autoadmin.modules.system.mapper.SysMenuApiMapper;
import com.autoadmin.modules.system.service.SysMenuApiService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 菜单接口关联服务实现
 */
@Service
public class SysMenuApiServiceImpl extends BaseServiceImpl<SysMenuApiMapper, SysMenuApi> implements SysMenuApiService {

    @Override
    public List<Long> getApiIdsByMenuId(Long menuId) {
        List<SysMenuApi> menuApis = lambdaQuery()
                .eq(SysMenuApi::getMenuId, menuId)
                .list();
        if (menuApis.isEmpty()) {
            return new ArrayList<>();
        }
        return menuApis.stream()
                .map(SysMenuApi::getApiId)
                .collect(Collectors.toList());
    }

    @Override
    public Set<Long> getApiIdsByMenuIds(Set<Long> menuIds) {
        if (menuIds == null || menuIds.isEmpty()) {
            return new HashSet<>();
        }

        List<SysMenuApi> menuApis = lambdaQuery()
                .in(SysMenuApi::getMenuId, menuIds)
                .list();

        if (menuApis.isEmpty()) {
            return new HashSet<>();
        }

        return menuApis.stream()
                .map(SysMenuApi::getApiId)
                .collect(Collectors.toSet());
    }

    @Override
    public List<Long> getMenuIdsByApiId(Long apiId) {
        List<SysMenuApi> menuApis = lambdaQuery()
                .eq(SysMenuApi::getApiId, apiId)
                .list();
        if (menuApis.isEmpty()) {
            return new ArrayList<>();
        }
        return menuApis.stream()
                .map(SysMenuApi::getMenuId)
                .collect(Collectors.toList());
    }

    @Override
    public int countByMenuId(Long menuId) {
        Long count = lambdaQuery()
                .eq(SysMenuApi::getMenuId, menuId)
                .count();
        return count == null ? 0 : count.intValue();
    }

    @Override
    public void assignApis(Long menuId, List<Long> apiIds) {
        // 删除原有接口
        deleteByMenuId(menuId);

        // 添加新接口
        if (apiIds != null && !apiIds.isEmpty()) {
            List<SysMenuApi> menuApis = apiIds.stream()
                    .map(apiId -> {
                        SysMenuApi menuApi = new SysMenuApi();
                        menuApi.setMenuId(menuId);
                        menuApi.setApiId(apiId);
                        return menuApi;
                    })
                    .collect(Collectors.toList());
            saveBatch(menuApis);
        }
    }

    @Override
    public void assignMenus(Long apiId, List<Long> menuIds) {
        // 删除原有菜单
        deleteByApiId(apiId);

        // 添加新菜单
        if (menuIds != null && !menuIds.isEmpty()) {
            List<SysMenuApi> menuApis = menuIds.stream()
                    .map(menuId -> {
                        SysMenuApi menuApi = new SysMenuApi();
                        menuApi.setMenuId(menuId);
                        menuApi.setApiId(apiId);
                        return menuApi;
                    })
                    .collect(Collectors.toList());
            saveBatch(menuApis);
        }
    }
}