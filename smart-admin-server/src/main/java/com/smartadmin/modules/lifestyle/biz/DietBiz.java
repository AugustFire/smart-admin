package com.smartadmin.modules.lifestyle.biz;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.smartadmin.common.exception.BusinessException;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.utils.UserContext;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordAddReq;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.request.DietRecordUpdateReq;
import com.smartadmin.modules.lifestyle.dto.response.DietRecordResp;
import com.smartadmin.modules.lifestyle.entity.DietRecord;
import com.smartadmin.modules.lifestyle.service.DietRecordService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

/**
 * 饮食记录业务类
 */
@Component
@RequiredArgsConstructor
public class DietBiz {

    private final DietRecordService dietRecordService;

    private static final Map<String, String> MEAL_TYPE_MAP = new LinkedHashMap<>();
    private static final Map<String, String> MOOD_MAP = new LinkedHashMap<>();
    private static final Map<String, String> TAG_MAP = new LinkedHashMap<>();

    static {
        MEAL_TYPE_MAP.put("breakfast", "早餐");
        MEAL_TYPE_MAP.put("lunch", "午餐");
        MEAL_TYPE_MAP.put("dinner", "晚餐");
        MEAL_TYPE_MAP.put("snack", "宵夜");
        MEAL_TYPE_MAP.put("drink", "饮料");

        MOOD_MAP.put("happy", "😄");
        MOOD_MAP.put("good", "🙂");
        MOOD_MAP.put("so-so", "😐");
        MOOD_MAP.put("binge", "😣");
        MOOD_MAP.put("skip", "🤢");

        TAG_MAP.put("healthy", "健康");
        TAG_MAP.put("light", "轻食");
        TAG_MAP.put("high-sugar", "高糖");
        TAG_MAP.put("oily", "油炸");
        TAG_MAP.put("spicy", "辣");
        TAG_MAP.put("bland", "清淡");
    }

    /**
     * 新增饮食记录
     */
    @Transactional(rollbackFor = Exception.class)
    public Long add(DietRecordAddReq req) {
        DietRecord record = new DietRecord();
        record.setUserId(UserContext.getUserId());
        record.setRecordDate(req.getRecordDate());
        record.setMealTime(req.getMealTime() != null ? req.getMealTime() : LocalTime.now());
        record.setMealType(req.getMealType());
        record.setFoodName(req.getFoodName());
        record.setPortion(req.getPortion());
        record.setTags(req.getTags());
        record.setMood(req.getMood());
        record.setDescription(req.getDescription());
        record.setCreateTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());
        dietRecordService.save(record);
        return record.getId();
    }

    /**
     * 更新饮食记录
     */
    @Transactional(rollbackFor = Exception.class)
    public void update(DietRecordUpdateReq req) {
        DietRecord record = dietRecordService.getById(req.getId());
        if (record == null) {
            throw new BusinessException("记录不存在");
        }
        record.setRecordDate(req.getRecordDate());
        record.setMealTime(req.getMealTime());
        record.setMealType(req.getMealType());
        record.setFoodName(req.getFoodName());
        record.setPortion(req.getPortion());
        record.setTags(req.getTags());
        record.setMood(req.getMood());
        record.setDescription(req.getDescription());
        record.setUpdateTime(LocalDateTime.now());
        dietRecordService.updateById(record);
    }

    /**
     * 删除饮食记录
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        dietRecordService.removeById(id);
    }

    /**
     * 获取饮食记录详情
     */
    public DietRecordResp getById(Long id) {
        DietRecord record = dietRecordService.getById(id);
        if (record == null) {
            throw new BusinessException("记录不存在");
        }
        return toResp(record);
    }

    /**
     * 分页查询饮食记录
     */
    public PageResp<DietRecordResp> pageQuery(DietRecordPageQueryReq req) {
        Long userId = UserContext.getUserId();

        IPage<DietRecord> page = dietRecordService.lambdaQuery()
                .eq(DietRecord::getUserId, userId)
                .eq(req.getRecordDate() != null, DietRecord::getRecordDate, req.getRecordDate())
                .ge(req.getStartDate() != null, DietRecord::getRecordDate, req.getStartDate())
                .le(req.getEndDate() != null, DietRecord::getRecordDate, req.getEndDate())
                .eq(req.getMealType() != null && !req.getMealType().isEmpty(), DietRecord::getMealType, req.getMealType())
                .orderByDesc(DietRecord::getRecordDate)
                .orderByDesc(DietRecord::getMealTime)
                .page(new Page<>(req.getPageNum(), req.getPageSize()));

        List<DietRecordResp> list = page.getRecords().stream()
                .map(this::toResp)
                .toList();

        return PageResp.of(list, page.getTotal(), (int) page.getCurrent(), (int) page.getSize());
    }

    /**
     * 获取常用食物名称列表（用于联想）
     */
    public List<String> getFoodHistory() {
        Long userId = UserContext.getUserId();
        return dietRecordService.lambdaQuery()
                .eq(DietRecord::getUserId, userId)
                .select(DietRecord::getFoodName)
                .groupBy(DietRecord::getFoodName)
                .list()
                .stream()
                .map(DietRecord::getFoodName)
                .toList();
    }

    /**
     * 根据食物名称获取最近一条记录的标签和份量（用于自动填充）
     */
    public DietRecordResp getLatestByFoodName(String foodName) {
        Long userId = UserContext.getUserId();
        List<DietRecord> records = dietRecordService.lambdaQuery()
                .eq(DietRecord::getUserId, userId)
                .eq(DietRecord::getFoodName, foodName)
                .orderByDesc(DietRecord::getCreateTime)
                .last("LIMIT 1")
                .list();
        return !records.isEmpty() ? toResp(records.get(0)) : null;
    }

    /**
     * 根据餐食类型获取最近一条记录（用于选择餐食类型后自动填充）
     */
    public DietRecordResp getLatestByMealType(String mealType) {
        Long userId = UserContext.getUserId();
        List<DietRecord> records = dietRecordService.lambdaQuery()
                .eq(DietRecord::getUserId, userId)
                .eq(DietRecord::getMealType, mealType)
                .orderByDesc(DietRecord::getCreateTime)
                .last("LIMIT 1")
                .list();
        return !records.isEmpty() ? toResp(records.get(0)) : null;
    }

    private DietRecordResp toResp(DietRecord record) {
        DietRecordResp resp = new DietRecordResp();
        resp.setId(record.getId());
        resp.setUserId(record.getUserId());
        resp.setRecordDate(record.getRecordDate());
        resp.setMealTime(record.getMealTime());
        resp.setMealType(record.getMealType());
        resp.setMealTypeName(MEAL_TYPE_MAP.getOrDefault(record.getMealType(), record.getMealType()));
        resp.setFoodName(record.getFoodName());
        resp.setPortion(record.getPortion());
        resp.setTags(record.getTags());
        resp.setTagNames(convertTagsToNames(record.getTags()));
        resp.setMood(record.getMood());
        resp.setMoodName(MOOD_MAP.getOrDefault(record.getMood(), ""));
        resp.setDescription(record.getDescription());
        resp.setCreateTime(record.getCreateTime());
        return resp;
    }

    private String convertTagsToNames(String tags) {
        if (!StringUtils.hasText(tags)) return "";
        StringBuilder sb = new StringBuilder();
        for (String tag : tags.split(",")) {
            String name = TAG_MAP.get(tag.trim());
            if (name != null) {
                if (sb.length() > 0) sb.append("、");
                sb.append(name);
            }
        }
        return sb.toString();
    }
}
