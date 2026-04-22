package com.smartadmin.modules.lifestyle.biz;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.smartadmin.common.exception.BusinessException;
import com.smartadmin.common.pojo.PageResp;
import com.smartadmin.utils.UserContext;
import com.smartadmin.modules.lifestyle.dto.request.TextCollectionAddReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCollectionPageQueryReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCollectionUpdateReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCategoryAddReq;
import com.smartadmin.modules.lifestyle.dto.request.TextCategoryUpdateReq;
import com.smartadmin.modules.lifestyle.dto.response.TextCollectionResp;
import com.smartadmin.modules.lifestyle.dto.response.TextCategoryResp;
import com.smartadmin.modules.lifestyle.entity.TextCollection;
import com.smartadmin.modules.lifestyle.entity.TextCategory;
import com.smartadmin.modules.lifestyle.service.TextCollectionService;
import com.smartadmin.modules.lifestyle.service.TextCategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 文本收藏业务类
 */
@Component
@RequiredArgsConstructor
public class TextCollectionBiz {

    private final TextCollectionService textCollectionService;
    private final TextCategoryService textCategoryService;

    // ==================== 文本收藏 ====================

    /**
     * 新增文本
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addText(TextCollectionAddReq req) {
        TextCollection text = new TextCollection();
        text.setUserId(UserContext.getUserId());
        text.setCategoryId(req.getCategoryId());
        text.setTitle(req.getTitle());
        text.setContent(req.getContent());
        text.setTags(req.getTags());
        textCollectionService.save(text);
        return text.getId();
    }

    /**
     * 更新文本
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateText(TextCollectionUpdateReq req) {
        TextCollection text = textCollectionService.getById(req.getId());
        if (text == null) {
            throw new BusinessException("文本不存在");
        }
        if (!text.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        text.setCategoryId(req.getCategoryId());
        text.setTitle(req.getTitle());
        text.setContent(req.getContent());
        text.setTags(req.getTags());
        textCollectionService.updateById(text);
    }

    /**
     * 删除文本
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteText(Long id) {
        TextCollection text = textCollectionService.getById(id);
        if (text == null) {
            throw new BusinessException("文本不存在");
        }
        if (!text.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        textCollectionService.removeById(id);
    }

    /**
     * 获取文本详情
     */
    public TextCollectionResp getTextById(Long id) {
        TextCollection text = textCollectionService.getById(id);
        if (text == null) {
            throw new BusinessException("文本不存在");
        }
        if (!text.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        TextCollectionResp resp = toTextResp(text);
        if (text.getCategoryId() != null) {
            TextCategory category = textCategoryService.getById(text.getCategoryId());
            if (category != null) {
                resp.setCategoryName(category.getName());
            }
        }
        return resp;
    }

    /**
     * 分页查询文本
     */
    public PageResp<TextCollectionResp> pageQueryText(TextCollectionPageQueryReq req) {
        Long userId = UserContext.getUserId();

        IPage<TextCollection> page = textCollectionService.lambdaQuery()
                .eq(TextCollection::getUserId, userId)
                .eq(req.getCategoryId() != null, TextCollection::getCategoryId, req.getCategoryId())
                .and(StringUtils.hasText(req.getKeyword()), w -> w
                    .like(TextCollection::getTitle, req.getKeyword())
                    .or()
                    .like(TextCollection::getContent, req.getKeyword()))
                .like(StringUtils.hasText(req.getTag()), TextCollection::getTags, req.getTag())
                .orderByDesc(TextCollection::getUpdateTime)
                .page(new Page<>(req.getPageNum(), req.getPageSize()));

        List<TextCollectionResp> list = page.getRecords().stream()
                .map(this::toTextResp)
                .toList();

        return PageResp.of(list, page.getTotal(), (int) page.getCurrent(), (int) page.getSize());
    }

    // ==================== 文本分类 ====================

    /**
     * 新增分类
     */
    @Transactional(rollbackFor = Exception.class)
    public Long addCategory(TextCategoryAddReq req) {
        TextCategory category = new TextCategory();
        category.setUserId(UserContext.getUserId());
        category.setParentId(req.getParentId());
        category.setName(req.getName());
        category.setSort(req.getSort() != null ? req.getSort() : 0);
        textCategoryService.save(category);
        return category.getId();
    }

    /**
     * 更新分类
     */
    @Transactional(rollbackFor = Exception.class)
    public void updateCategory(TextCategoryUpdateReq req) {
        TextCategory category = textCategoryService.getById(req.getId());
        if (category == null) {
            throw new BusinessException("分类不存在");
        }
        if (!category.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        category.setParentId(req.getParentId());
        category.setName(req.getName());
        category.setSort(req.getSort() != null ? req.getSort() : 0);
        textCategoryService.updateById(category);
    }

    /**
     * 删除分类
     */
    @Transactional(rollbackFor = Exception.class)
    public void deleteCategory(Long id) {
        TextCategory category = textCategoryService.getById(id);
        if (category == null) {
            throw new BusinessException("分类不存在");
        }
        if (!category.getUserId().equals(UserContext.getUserId())) {
            throw new BusinessException("无权操作");
        }
        // 检查是否有子分类
        long childCount = textCategoryService.lambdaQuery()
                .eq(TextCategory::getParentId, id)
                .count();
        if (childCount > 0) {
            throw new BusinessException("请先删除子分类");
        }
        // 检查是否有文本关联
        long textCount = textCollectionService.lambdaQuery()
                .eq(TextCollection::getCategoryId, id)
                .count();
        if (textCount > 0) {
            throw new BusinessException("请先移除该分类下的文本");
        }
        textCategoryService.removeById(id);
    }

    /**
     * 获取分类列表（树形结构）
     */
    public List<TextCategoryResp> getCategoryTree() {
        Long userId = UserContext.getUserId();
        List<TextCategory> allCategories = textCategoryService.lambdaQuery()
                .eq(TextCategory::getUserId, userId)
                .orderByAsc(TextCategory::getSort)
                .orderByDesc(TextCategory::getCreateTime)
                .list();

        return buildTree(allCategories);
    }

    /**
     * 获取分类列表（扁平）
     */
    public List<TextCategoryResp> getCategoryList() {
        Long userId = UserContext.getUserId();
        List<TextCategory> categories = textCategoryService.lambdaQuery()
                .eq(TextCategory::getUserId, userId)
                .orderByAsc(TextCategory::getSort)
                .orderByDesc(TextCategory::getCreateTime)
                .list();

        return categories.stream()
                .map(this::toCategoryResp)
                .toList();
    }

    // ==================== 私有方法 ====================

    private TextCollectionResp toTextResp(TextCollection text) {
        return TextCollectionResp.builder()
                .id(text.getId())
                .userId(text.getUserId())
                .categoryId(text.getCategoryId())
                .title(text.getTitle())
                .content(text.getContent())
                .tags(text.getTags())
                .createTime(text.getCreateTime())
                .updateTime(text.getUpdateTime())
                .build();
    }

    private TextCategoryResp toCategoryResp(TextCategory category) {
        return TextCategoryResp.builder()
                .id(category.getId())
                .parentId(category.getParentId())
                .name(category.getName())
                .sort(category.getSort())
                .createTime(category.getCreateTime())
                .updateTime(category.getUpdateTime())
                .build();
    }

    private List<TextCategoryResp> buildTree(List<TextCategory> categories) {
        Map<Long, List<TextCategory>> childrenMap = categories.stream()
                .filter(c -> c.getParentId() != null)
                .collect(Collectors.groupingBy(TextCategory::getParentId));

        List<TextCategoryResp> roots = new ArrayList<>();
        for (TextCategory category : categories) {
            if (category.getParentId() == null) {
                TextCategoryResp resp = toCategoryResp(category);
                resp.setChildren(buildChildren(category.getId(), childrenMap));
                roots.add(resp);
            }
        }
        return roots;
    }

    private List<TextCategoryResp> buildChildren(Long parentId, Map<Long, List<TextCategory>> childrenMap) {
        List<TextCategory> children = childrenMap.get(parentId);
        if (children == null || children.isEmpty()) {
            return new ArrayList<>();
        }
        List<TextCategoryResp> result = new ArrayList<>();
        for (TextCategory child : children) {
            TextCategoryResp resp = toCategoryResp(child);
            resp.setChildren(buildChildren(child.getId(), childrenMap));
            result.add(resp);
        }
        return result;
    }
}
