package com.smartadmin.modules.lifestyle.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * 饮食记录实体
 */
@Data
@TableName("life_diet_record")
public class DietRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户ID */
    private Long userId;

    /** 记录日期 */
    private LocalDate recordDate;

    /** 用餐时间 */
    private LocalTime mealTime;

    /** 餐食类型: breakfast/lunch/dinner/snack/drink */
    private String mealType;

    /** 食物名称 */
    private String foodName;

    /** 份量，如: 1份、2碗、半碗 */
    private String portion;

    /** 标签，多个逗号分隔 */
    private String tags;

    /** 心情: happy/good/so-so/binge/skip */
    private String mood;

    /** 描述/备注 */
    private String description;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
