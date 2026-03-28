package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 关系新增请求
 */
@Data
public class DmRelationAddReq {

    /** 源表ID */
    @NotNull(message = "源表ID不能为空")
    private Long sourceTableId;

    /** 源字段ID */
    @NotNull(message = "源字段ID不能为空")
    private Long sourceColumnId;

    /** 目标表ID */
    @NotNull(message = "目标表ID不能为空")
    private Long targetTableId;

    /** 目标字段ID */
    @NotNull(message = "目标字段ID不能为空")
    private Long targetColumnId;

    /** 关系类型：ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE、MANY_TO_MANY */
    @NotBlank(message = "关系类型不能为空")
    private String relationType;

    /** 关系描述 */
    private String description;
}
