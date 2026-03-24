package com.smartadmin.modules.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.smartadmin.modules.system.entity.SysMenu;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Set;

/**
 * 菜单 Mapper
 */
@Mapper
public interface SysMenuMapper extends BaseMapper<SysMenu> {

    /**
     * 根据角色 ID 列表查询菜单
     */
    List<SysMenu> selectMenusByRoleIds(@Param("roleIds") Set<Long> roleIds);

    /**
     * 根据用户 ID 查询菜单权限
     */
    List<SysMenu> selectMenuPermissionsByUserId(@Param("userId") Long userId);
}