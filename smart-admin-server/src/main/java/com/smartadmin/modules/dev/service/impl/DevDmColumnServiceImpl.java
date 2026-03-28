package com.smartadmin.modules.dev.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartadmin.modules.dev.entity.DevDmColumn;
import com.smartadmin.modules.dev.mapper.DevDmColumnMapper;
import com.smartadmin.modules.dev.service.DevDmColumnService;
import org.springframework.stereotype.Service;

/**
 * 数据模型-表字段信息服务实现
 */
@Service
public class DevDmColumnServiceImpl extends ServiceImpl<DevDmColumnMapper, DevDmColumn>
        implements DevDmColumnService {
}
