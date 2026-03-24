package com.smartadmin;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Smart Admin 管理后台启动类
 */
@SpringBootApplication
@MapperScan(basePackages = "com.smartadmin.modules", annotationClass = Mapper.class)
public class SmartAdminApplication {

    public static void main(String[] args) {
        SpringApplication.run(SmartAdminApplication.class, args);
        System.out.println("=====================================");
        System.out.println("    Smart Admin 启动成功!");
        System.out.println("    Swagger: http://localhost:8080/doc.html");
        System.out.println("=====================================");
    }
}
