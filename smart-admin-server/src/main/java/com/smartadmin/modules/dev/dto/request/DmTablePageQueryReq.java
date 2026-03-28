package com.smartadmin.modules.dev.dto.request;

import com.smartadmin.common.pojo.PageReq;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 数据表分页查询请求
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class DmTablePageQueryReq extends PageReq {

    /** 数据库ID */
    private Long databaseId;

    /** 表名称（模糊查询） */
    private String name;

    /** 表编码（模糊查询） */
    private String code;
}
