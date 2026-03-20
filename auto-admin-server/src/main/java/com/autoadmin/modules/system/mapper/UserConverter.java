package com.autoadmin.modules.system.mapper;

import com.autoadmin.modules.system.entity.SysUser;
import com.autoadmin.modules.system.dto.request.UserAddReq;
import com.autoadmin.modules.system.dto.request.UserUpdateReq;
import com.autoadmin.modules.system.dto.response.UserResp;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

/**
 * 用户 Entity 与 DTO 转换器
 */
@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
public interface UserConverter {

    UserConverter INSTANCE = org.mapstruct.factory.Mappers.getMapper(UserConverter.class);

    /**
     * Entity 转 Response DTO
     */
    @Mapping(source = "id", target = "userId")
    UserResp toResp(SysUser entity);

    /**
     * AddReq 转 Entity
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createTime", ignore = true)
    @Mapping(target = "updateTime", ignore = true)
    @Mapping(target = "deleted", ignore = true)
    SysUser toEntity(UserAddReq req);

    /**
     * UpdateReq 转 Entity（部分更新）
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    @Mapping(target = "createTime", ignore = true)
    @Mapping(target = "updateTime", ignore = true)
    @Mapping(target = "deleted", ignore = true)
    void updateEntity(UserUpdateReq req, @MappingTarget SysUser entity);
}