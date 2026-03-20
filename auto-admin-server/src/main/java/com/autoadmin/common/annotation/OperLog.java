package com.autoadmin.common.annotation;

import com.autoadmin.common.enums.BusinessType;

import java.lang.annotation.*;

/**
 * 操作日志注解
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface OperLog {

    /**
     * 模块标题
     */
    String title() default "";

    /**
     * 业务类型
     */
    BusinessType businessType() default BusinessType.OTHER;
}
