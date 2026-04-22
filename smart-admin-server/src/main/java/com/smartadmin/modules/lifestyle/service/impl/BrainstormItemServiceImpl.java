package com.smartadmin.modules.lifestyle.service.impl;

import com.smartadmin.modules.lifestyle.entity.BrainstormItem;
import com.smartadmin.modules.lifestyle.mapper.BrainstormItemMapper;
import com.smartadmin.modules.lifestyle.service.BrainstormItemService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * 头脑风暴 服务实现
 */
@Service
public class BrainstormItemServiceImpl extends ServiceImpl<BrainstormItemMapper, BrainstormItem>
        implements BrainstormItemService {
}
