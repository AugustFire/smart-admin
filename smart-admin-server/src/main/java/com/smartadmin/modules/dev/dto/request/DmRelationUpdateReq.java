package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 关系修改请求
 */
@Data
public class DmRelationUpdateReq {

    /** 主键 ID */
    @NotNull(message = "ID不能为空")
    private Long id;

    /** 关系类型：ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE、MANY_TO_MANY */
    private String relationType;

    /** 关系描述 */
    private String description;
}
