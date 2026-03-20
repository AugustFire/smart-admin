package com.autoadmin.modules.profile.service.impl;

import com.autoadmin.common.base.BaseServiceImpl;
import com.autoadmin.modules.profile.service.SysProfileService;
import com.autoadmin.modules.system.entity.SysUser;
import com.autoadmin.modules.system.mapper.SysUserMapper;
import org.springframework.stereotype.Service;

/**
 * 用户 Profile 基础服务实现
 */
@Service
public class SysProfileServiceImpl extends BaseServiceImpl<SysUserMapper, SysUser> implements SysProfileService {
}