package com.smartadmin.modules.dev.dto.response;

import lombok.Data;

import java.util.List;

/**
 * 数据库-表树形结构响应
 */
@Data
public class DmTableTreeResp {

    /** 数据库ID */
    private Long id;

    /** 数据库名称 */
    private String name;

    /** 数据库编码 */
    private String code;

    /** 类型：database */
    private String type = "database";

    /** 子节点（表列表） */
    private List<TableNode> children;

    /**
     * 表节点
     */
    @Data
    public static class TableNode {
        /** 表ID */
        private Long id;

        /** 表名称 */
        private String name;

        /** 表编码 */
        private String code;

        /** 类型：table */
        private String type = "table";
    }
}
