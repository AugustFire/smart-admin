package com.autoadmin.common.pojo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Data;

import java.io.Serializable;

/**
 * 通用分页请求基类
 */
@Data
@Schema(description = "分页请求")
public class PageReq implements Serializable {

    private static final long serialVersionUID = 1L;

    @Min(value = 1, message = "页码不能小于 1")
    @Schema(description = "页码", example = "1")
    private Integer pageNum = 1;

    @Min(value = 1)
    @Max(value = 100, message = "每页数量不能超过 100")
    @Schema(description = "每页数量", example = "10")
    private Integer pageSize = 10;

    @Schema(description = "排序字段", example = "createTime")
    private String sortBy;

    @Schema(description = "排序方式 asc/desc", example = "desc")
    private String sortOrder;
}
