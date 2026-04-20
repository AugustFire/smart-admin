-- ================================================================
-- 本地生活 - 饮食管理菜单及数据表
-- 执行方式: mysql -u root -p smart_admin < sql/lifestyle_diet_menu.sql
-- ================================================================

-- ------------------------------------------------
-- 1. 菜单数据
-- ------------------------------------------------
-- 父菜单：本地生活 (目录)
INSERT INTO `sys_menu` VALUES (62, 0, '本地生活', 1, '/lifestyle', 'Layout', '', 'Grid', 3, 1, 1, NOW(), NOW());

-- 子菜单：饮食管理 (菜单)
INSERT INTO `sys_menu` VALUES (63, 62, '饮食管理', 2, '/lifestyle/diet', 'lifestyle/diet/index', '', 'Food', 1, 1, 1, NOW(), NOW());

-- ------------------------------------------------
-- 2. 饮食记录表
-- ------------------------------------------------
DROP TABLE IF EXISTS `diet_record`;

CREATE TABLE `diet_record` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` bigint NOT NULL COMMENT '用户ID',
    `record_date` date NOT NULL COMMENT '记录日期',
    `meal_time` time DEFAULT NULL COMMENT '用餐时间',
    `meal_type` varchar(20) NOT NULL COMMENT '餐食类型: breakfast/lunch/dinner/snack/drink',
    `food_name` varchar(100) NOT NULL COMMENT '食物名称',
    `portion` varchar(50) DEFAULT NULL COMMENT '份量，如: 1份、2碗、半碗',
    `tags` varchar(200) DEFAULT NULL COMMENT '标签，多个逗号分隔: 健康、轻食、高糖、油炸、辣、清淡',
    `mood` varchar(20) DEFAULT NULL COMMENT '心情: happy/good/so-so/binge/skip',
    `description` varchar(500) DEFAULT NULL COMMENT '描述/备注',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    KEY `idx_record_date` (`record_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='饮食记录表';
