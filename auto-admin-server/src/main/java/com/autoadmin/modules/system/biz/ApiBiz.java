package com.autoadmin.modules.system.biz;

import com.autoadmin.common.exception.BusinessException;
import com.autoadmin.common.pojo.PageResp;
import com.autoadmin.modules.system.dto.request.ApiAddReq;
import com.autoadmin.modules.system.dto.request.ApiPageQueryReq;
import com.autoadmin.modules.system.dto.request.ApiUpdateReq;
import com.autoadmin.modules.system.dto.response.ApiResp;
import com.autoadmin.modules.system.entity.SysApi;
import com.autoadmin.modules.system.entity.SysMenu;
import com.autoadmin.modules.system.service.SysApiService;
import com.autoadmin.modules.system.service.SysMenuService;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.stream.Collectors;

/**
 * 接口资源管理业务类
 */
@Component
@RequiredArgsConstructor
public class ApiBiz {

    private final SysApiService apiService;
    private final SysMenuService menuService;

    /**
     * 获取所有接口列表
     */
    public List<ApiResp> listAll() {
        List<SysApi> apis = apiService.lambdaQuery()
                .orderByAsc(SysApi::getMethod)
                .orderByAsc(SysApi::getPath)
                .list();
        return apis.stream()
                .map(this::convertToResp)
                .collect(Collectors.toList());
    }

    /**
     * 分页查询接口列表
     */
    public PageResp<ApiResp> pageApis(ApiPageQueryReq req) {
        IPage<SysApi> page = apiService.lambdaQuery()
                .like(StringUtils.hasText(req.getPath()), SysApi::getPath, req.getPath())
                .eq(StringUtils.hasText(req.getMethod()), SysApi::getMethod, req.getMethod())
                .like(StringUtils.hasText(req.getName()), SysApi::getName, req.getName())
                .eq(req.getMenuId() != null, SysApi::getMenuId, req.getMenuId())
                .eq(req.getStatus() != null, SysApi::getStatus, req.getStatus())
                .orderByDesc(SysApi::getCreateTime)
                .page(new Page<>(req.getPageNum(), req.getPageSize()));

        List<ApiResp> list = page.getRecords().stream()
                .map(this::convertToResp)
                .collect(Collectors.toList());

        return PageResp.of(list, page.getTotal(), (int) page.getCurrent(), (int) page.getSize());
    }

    /**
     * 获取接口详情
     */
    public ApiResp getById(Long id) {
        SysApi api = apiService.getByIdOrThrow(id);
        return convertToResp(api);
    }

    /**
     * 新增接口
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addApi(ApiAddReq req) {
        // 检查接口路径是否已存在
        if (apiService.existsByPathAndMethod(req.getPath(), req.getMethod())) {
            throw new BusinessException("接口路径已存在");
        }

        SysApi api = new SysApi();
        api.setPath(req.getPath());
        api.setMethod(req.getMethod());
        api.setName(req.getName());
        api.setMenuId(req.getMenuId());
        api.setStatus(req.getStatus() != null ? req.getStatus() : 1);
        api.setRemark(req.getRemark());
        apiService.save(api);
        return api.getId();
    }

    /**
     * 更新接口
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateApi(ApiUpdateReq req) {
        apiService.getByIdOrThrow(req.getId());

        // 检查接口路径是否被其他接口使用
        if (apiService.existsByPathAndMethod(req.getPath(), req.getMethod(), req.getId())) {
            throw new BusinessException("接口路径已存在");
        }

        SysApi api = new SysApi();
        api.setId(req.getId());
        api.setPath(req.getPath());
        api.setMethod(req.getMethod());
        api.setName(req.getName());
        api.setMenuId(req.getMenuId());
        api.setStatus(req.getStatus());
        api.setRemark(req.getRemark());
        apiService.updateById(api);
    }

    /**
     * 删除接口
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteApi(Long id) {
        apiService.getByIdOrThrow(id);
        apiService.removeById(id);
    }

    /**
     * 获取接口树（按菜单分组）
     */
    public List<?> getApisWithMenuGrouping() {
        // 获取所有接口
        List<SysApi> apis = apiService.list();

        // 获取所有菜单
        List<SysMenu> menus = menuService.list();

        // 构建菜单树结构
        List<Map<String, Object>> result = new ArrayList<>();

        // 按 menu_id 分组
        Map<Long, List<SysApi>> apiGroupByMenuId = apis.stream()
                .filter(api -> api.getMenuId() != null)
                .collect(Collectors.groupingBy(SysApi::getMenuId));

        // 为每个菜单创建节点
        for (SysMenu menu : menus) {
            if (apiGroupByMenuId.containsKey(menu.getId())) {
                Map<String, Object> node = new HashMap<>();
                node.put("id", menu.getId());
                node.put("name", menu.getName());
                node.put("type", "menu");
                node.put("children", apiGroupByMenuId.get(menu.getId()));
                result.add(node);
            }
        }

        // 添加没有关联菜单的接口
        List<SysApi> apisWithoutMenu = apis.stream()
                .filter(api -> api.getMenuId() == null)
                .collect(Collectors.toList());

        if (!apisWithoutMenu.isEmpty()) {
            Map<String, Object> node = new HashMap<>();
            node.put("id", 0);
            node.put("name", "未关联菜单的接口");
            node.put("type", "menu");
            node.put("children", apisWithoutMenu);
            result.add(node);
        }

        return result;
    }

    private ApiResp convertToResp(SysApi entity) {
        return ApiResp.builder()
                .id(entity.getId())
                .path(entity.getPath())
                .method(entity.getMethod())
                .name(entity.getName())
                .menuId(entity.getMenuId())
                .status(entity.getStatus())
                .remark(entity.getRemark())
                .creator(entity.getCreator())
                .createTime(entity.getCreateTime())
                .updater(entity.getUpdater())
                .updateTime(entity.getUpdateTime())
                .build();
    }
}