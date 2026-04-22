package com.smartadmin.modules.lifestyle.biz;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.smartadmin.common.exception.BusinessException;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.utils.UserContext;
import com.smartadmin.modules.lifestyle.dto.request.BrainstormAddReq;
import com.smartadmin.modules.lifestyle.dto.request.BrainstormPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.request.BrainstormUpdateReq;
import com.smartadmin.modules.lifestyle.dto.response.BrainstormResp;
import com.smartadmin.modules.lifestyle.entity.BrainstormItem;
import com.smartadmin.modules.lifestyle.service.BrainstormItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDate;
import java.util.List;

/**
 * 头脑风暴业务类
 */
@Component
@RequiredArgsConstructor
public class BrainstormBiz {

    private final BrainstormItemService brainstormItemService;

    /**
     * 新增想法
     */
    @Transactional(rollbackFor = Exception.class)
    public Long add(BrainstormAddReq req) {
        BrainstormItem item = new BrainstormItem();
        item.setUserId(UserContext.getUserId());
        item.setContent(req.getContent());
        item.setTags(req.getTags());
        brainstormItemService.save(item);
        return item.getId();
    }

    /**
     * 更新想法
     */
    @Transactional(rollbackFor = Exception.class)
    public void update(BrainstormUpdateReq req) {
        BrainstormItem item = brainstormItemService.getById(req.getId());
        if (item == null) {
            throw new BusinessException("想法不存在");
        }
        if (!item.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        item.setContent(req.getContent());
        item.setTags(req.getTags());
        brainstormItemService.updateById(item);
    }

    /**
     * 删除想法
     */
    @Transactional(rollbackFor = Exception.class)
    public void delete(Long id) {
        BrainstormItem item = brainstormItemService.getById(id);
        if (item == null) {
            throw new BusinessException("想法不存在");
        }
        if (!item.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        brainstormItemService.removeById(id);
    }

    /**
     * 获取想法详情
     */
    public BrainstormResp getById(Long id) {
        BrainstormItem item = brainstormItemService.getById(id);
        if (item == null) {
            throw new BusinessException("想法不存在");
        }
        if (!item.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        return toResp(item);
    }

    /**
     * 分页查询想法
     */
    public PageResp<BrainstormResp> pageQuery(BrainstormPageQueryReq req) {
        Long userId = UserContext.getUserId();

        IPage<BrainstormItem> page = brainstormItemService.lambdaQuery()
                .eq(BrainstormItem::getUserId, userId)
                .like(StringUtils.hasText(req.getKeyword()), BrainstormItem::getContent, req.getKeyword())
                .like(StringUtils.hasText(req.getTag()), BrainstormItem::getTags, req.getTag())
                .ge(StringUtils.hasText(req.getStartDate()), BrainstormItem::getCreateTime, LocalDate.parse(req.getStartDate()).atStartOfDay())
                .le(StringUtils.hasText(req.getEndDate()), BrainstormItem::getCreateTime, LocalDate.parse(req.getEndDate()).atTime(23, 59, 59))
                .orderByDesc(BrainstormItem::getCreateTime)
                .page(new Page<>(req.getPageNum(), req.getPageSize()));

        List<BrainstormResp> list = page.getRecords().stream()
                .map(this::toResp)
                .toList();

        return PageResp.of(list, page.getTotal(), (int) page.getCurrent(), (int) page.getSize());
    }

    private BrainstormResp toResp(BrainstormItem item) {
        return BrainstormResp.builder()
                .id(item.getId())
                .userId(item.getUserId())
                .content(item.getContent())
                .tags(item.getTags())
                .createTime(item.getCreateTime())
                .updateTime(item.getUpdateTime())
                .build();
    }
}
