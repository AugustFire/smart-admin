package com.smartadmin.modules.lifestyle.dto.request;

import com.smartadmin.common.pojo.PageReq;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 文本收藏分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "文本收藏分页查询请求")
public class TextCollectionPageQueryReq extends PageReq {

    @Schema(description = "关键词搜索")
    private String keyword;

    @Schema(description = "分类ID")
    private Long categoryId;

    @Schema(description = "标签筛选")
    private String tag;
}
