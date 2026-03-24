package com.smartadmin.modules.profile.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.profile.service.SysProfileService;
import com.smartadmin.modules.system.entity.SysUser;
import com.smartadmin.modules.system.mapper.SysUserMapper;
import org.springframework.stereotype.Service;

/**
 * 用户 Profile 基础服务实现
 */
@Service
public class SysProfileServiceImpl extends BaseServiceImpl<SysUserMapper, SysUser> implements SysProfileService {
}