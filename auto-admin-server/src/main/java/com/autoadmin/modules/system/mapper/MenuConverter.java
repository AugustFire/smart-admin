package com.autoadmin.modules.system.mapper;

import com.autoadmin.modules.system.entity.SysMenu;
import com.autoadmin.modules.system.dto.request.MenuAddReq;
import com.autoadmin.modules.system.dto.request.MenuUpdateReq;
import com.autoadmin.modules.system.dto.response.MenuResp;
import com.autoadmin.modules.system.dto.response.MenuTreeResp;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

/**
 * 菜单 Entity 与 DTO 转换器
 */
@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
public interface MenuConverter {

    MenuConverter INSTANCE = org.mapstruct.factory.Mappers.getMapper(MenuConverter.class);

    /**
     * Entity 转 Response DTO
     */
    MenuResp toResp(SysMenu entity);

    /**
     * Entity 列表转 Response 列表
     */
    List<MenuResp> toRespList(List<SysMenu> entities);

    /**
     * Entity 转树形 Response DTO
     */
    MenuTreeResp toTreeResp(SysMenu entity);

    /**
     * AddReq 转 Entity
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createTime", ignore = true)
    @Mapping(target = "updateTime", ignore = true)
    @Mapping(target = "children", ignore = true)
    SysMenu toEntity(MenuAddReq req);

    /**
     * UpdateReq 转 Entity（部分更新）
     */
    @Mapping(target = "createTime", ignore = true)
    @Mapping(target = "updateTime", ignore = true)
    @Mapping(target = "children", ignore = true)
    void updateEntity(MenuUpdateReq req, @MappingTarget SysMenu entity);
}