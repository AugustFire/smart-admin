package com.smartadmin.modules.lifestyle.service.impl;

import com.smartadmin.common.base.BaseServiceImpl;
import com.smartadmin.modules.lifestyle.entity.DietRecord;
import com.smartadmin.modules.lifestyle.mapper.DietRecordMapper;
import com.smartadmin.modules.lifestyle.service.DietRecordService;
import org.springframework.stereotype.Service;

/**
 * 饮食记录服务实现
 */
@Service
public class DietRecordServiceImpl extends BaseServiceImpl<DietRecordMapper, DietRecord> implements DietRecordService {
}
