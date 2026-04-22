-- =====================================================
-- 头脑风暴和文本收藏模块数据库脚本
-- 执行前请确保已创建 smart_admin 数据库
-- =====================================================

USE smart_admin;

-- ----------------------------
-- 1. 头脑风暴表
-- ----------------------------
DROP TABLE IF EXISTS `life_brainstorm`;
CREATE TABLE `life_brainstorm` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `content` text NOT NULL COMMENT '想法内容',
  `tags` varchar(200) DEFAULT NULL COMMENT '标签，多个逗号分隔',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user_id`(`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='头脑风暴表';

-- ----------------------------
-- 2. 文本收藏表
-- ----------------------------
DROP TABLE IF EXISTS `life_text_collection`;
CREATE TABLE `life_text_collection` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  `title` varchar(200) DEFAULT NULL COMMENT '标题',
  `content` text DEFAULT NULL COMMENT '内容(Markdown)',
  `tags` varchar(200) DEFAULT NULL COMMENT '标签，多个逗号分隔',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user_id`(`user_id`),
  INDEX `idx_category_id`(`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文本收藏表';

-- ----------------------------
-- 3. 文本收藏分类表
-- ----------------------------
DROP TABLE IF EXISTS `life_text_category`;
CREATE TABLE `life_text_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `parent_id` bigint DEFAULT NULL COMMENT '父分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `sort` int DEFAULT 0 COMMENT '排序',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user_id`(`user_id`),
  INDEX `idx_parent_id`(`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='文本收藏分类表';

-- ----------------------------
-- 4. 菜单数据（参考，无需执行）
-- ----------------------------
-- 菜单已存在于 sys_menu 表中，无需重复插入
-- 路径: /lifestyle/brainstorm -> 头脑风暴
-- 路径: /lifestyle/text-collection -> 文本收集
