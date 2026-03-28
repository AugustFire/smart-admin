package com.smartadmin.modules.dev.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.smartadmin.modules.dev.entity.DevDmRelation;
import com.smartadmin.modules.dev.mapper.DevDmRelationMapper;
import com.smartadmin.modules.dev.service.DevDmRelationService;
import org.springframework.stereotype.Service;

/**
 * 数据模型-表关系信息服务实现
 */
@Service
public class DevDmRelationServiceImpl extends ServiceImpl<DevDmRelationMapper, DevDmRelation>
        implements DevDmRelationService {
}
