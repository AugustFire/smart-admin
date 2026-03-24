package com.smartadmin.modules.system.mapper;

import com.smartadmin.modules.system.entity.SysRole;
import com.smartadmin.modules.system.dto.request.RoleAddReq;
import com.smartadmin.modules.system.dto.request.RoleUpdateReq;
import com.smartadmin.modules.system.dto.response.RoleResp;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

/**
 * 角色 Entity 与 DTO 转换器
 */
@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
public interface RoleConverter {

    RoleConverter INSTANCE = org.mapstruct.factory.Mappers.getMapper(RoleConverter.class);

    /**
     * Entity 转 Response DTO
     */
    @Mapping(source = "id", target = "roleId")
    RoleResp toResp(SysRole entity);

    /**
     * AddReq 转 Entity
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createTime", ignore = true)
    @Mapping(target = "updateTime", ignore = true)
    @Mapping(target = "deleted", ignore = true)
    SysRole toEntity(RoleAddReq req);

    /**
     * UpdateReq 转 Entity（部分更新）
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createTime", ignore = true)
    @Mapping(target = "updateTime", ignore = true)
    @Mapping(target = "deleted", ignore = true)
    void updateEntity(RoleUpdateReq req, @MappingTarget SysRole entity);
}