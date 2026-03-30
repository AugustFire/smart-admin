package com.smartadmin.modules.dev.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

/**
 * 字段批量保存请求
 */
@Data
public class DmColumnBatchSaveReq {

    /** 所属表ID */
    @NotNull(message = "表ID不能为空")
    private Long tableId;

    /** 字段列表 */
    @Valid
    private List<DmColumnAddReq> columns;

    /** 要删除的字段ID列表 */
    private List<Long> deleteIds;
}
