package com.smartadmin.modules.dev.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartadmin.modules.dev.entity.DevDmTable;
import com.smartadmin.modules.dev.mapper.DevDmTableMapper;
import com.smartadmin.modules.dev.service.DevDmTableService;
import org.springframework.stereotype.Service;

/**
 * 数据模型-数据表信息服务实现
 */
@Service
public class DevDmTableServiceImpl extends ServiceImpl<DevDmTableMapper, DevDmTable>
        implements DevDmTableService {
}
