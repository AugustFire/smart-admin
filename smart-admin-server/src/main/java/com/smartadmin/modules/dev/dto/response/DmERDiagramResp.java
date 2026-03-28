package com.smartadmin.modules.dev.dto.response;

import lombok.Data;

import java.util.List;

/**
 * E-R 图数据响应
 */
@Data
public class DmERDiagramResp {

    /** 数据库ID */
    private Long databaseId;

    /** 数据库名称 */
    private String databaseName;

    /** 节点列表（表） */
    private List<Node> nodes;

    /** 边列表（关系） */
    private List<Edge> edges;

    /**
     * 表节点
     */
    @Data
    public static class Node {
        /** 节点ID */
        private String id;

        /** 表名称 */
        private String name;

        /** 表编码 */
        private String code;

        /** 表描述 */
        private String description;

        /** 字段列表 */
        private List<ColumnNode> columns;

        /** X坐标 */
        private Double x;

        /** Y坐标 */
        private Double y;
    }

    /**
     * 字段节点
     */
    @Data
    public static class ColumnNode {
        /** 字段ID */
        private Long id;

        /** 字段名称 */
        private String name;

        /** 字段编码 */
        private String code;

        /** 数据类型 */
        private String dataType;

        /** 是否主键 */
        private Integer isPrimary;

        /** 是否外键 */
        private Integer isForeign;

        /** 是否核心字段 */
        private Integer isCore;
    }

    /**
     * 关系边
     */
    @Data
    public static class Edge {
        /** 边ID */
        private String id;

        /** 源节点ID */
        private String source;

        /** 目标节点ID */
        private String target;

        /** 关系类型 */
        private String relationType;

        /** 源字段 */
        private String sourceColumn;

        /** 目标字段 */
        private String targetColumn;

        /** 关系描述 */
        private String description;
    }
}
