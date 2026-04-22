package com.smartadmin.modules.lifestyle.dto.request;

import com.smartadmin.common.pojo.PageReq;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 头脑风暴分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Schema(description = "头脑风暴分页查询请求")
public class BrainstormPageQueryReq extends PageReq {

    @Schema(description = "关键词搜索")
    private String keyword;

    @Schema(description = "标签筛选")
    private String tag;

    @Schema(description = "开始日期")
    private String startDate;

    @Schema(description = "结束日期")
    private String endDate;
}
