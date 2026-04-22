package com.smartadmin.modules.lifestyle.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 文本收藏实体
 */
@Data
@TableName("life_text_collection")
public class TextCollection {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 分类ID */
    private Long categoryId;

    /** 标题 */
    private String title;

    /** 内容(Markdown) */
    private String content;

    /** 标签，多个逗号分隔 */
    private String tags;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
