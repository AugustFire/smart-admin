package com.smartadmin.modules.lifestyle.service.impl;

import com.smartadmin.modules.lifestyle.entity.TextCategory;
import com.smartadmin.modules.lifestyle.mapper.TextCategoryMapper;
import com.smartadmin.modules.lifestyle.service.TextCategoryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * 文本收藏分类 服务实现
 */
@Service
public class TextCategoryServiceImpl extends ServiceImpl<TextCategoryMapper, TextCategory>
        implements TextCategoryService {
}
