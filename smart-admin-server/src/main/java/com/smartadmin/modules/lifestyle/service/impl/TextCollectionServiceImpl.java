package com.smartadmin.modules.lifestyle.service.impl;

import com.smartadmin.modules.lifestyle.entity.TextCollection;
import com.smartadmin.modules.lifestyle.mapper.TextCollectionMapper;
import com.smartadmin.modules.lifestyle.service.TextCollectionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * 文本收藏 服务实现
 */
@Service
public class TextCollectionServiceImpl extends ServiceImpl<TextCollectionMapper, TextCollection>
        implements TextCollectionService {
}
