package com.smartadmin.modules.dev.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartadmin.modules.dev.entity.DevDmDatabase;
import com.smartadmin.modules.dev.mapper.DevDmDatabaseMapper;
import com.smartadmin.modules.dev.service.DevDmDatabaseService;
import org.springframework.stereotype.Service;

/**
 * 数据模型-数据库信息服务实现
 */
@Service
public class DevDmDatabaseServiceImpl extends ServiceImpl<DevDmDatabaseMapper, DevDmDatabase>
        implements DevDmDatabaseService {
}
