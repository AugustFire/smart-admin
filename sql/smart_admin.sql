/*
 Navicat Premium Dump SQL

 Source Server         : z-mysql
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : smart_admin

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 22/04/2026 09:09:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dev_dm_column
-- ----------------------------
DROP TABLE IF EXISTS `dev_dm_column`;
CREATE TABLE `dev_dm_column`  (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                  `table_id` bigint NOT NULL COMMENT '所属表ID',
                                  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字段显示名称',
                                  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字段编码',
                                  `data_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据类型（varchar、bigint等）',
                                  `length` int NULL DEFAULT NULL COMMENT '长度',
                                  `is_primary` tinyint NULL DEFAULT 0 COMMENT '是否主键 0=否 1=是',
                                  `is_foreign` tinyint NULL DEFAULT 0 COMMENT '是否外键 0=否 1=是',
                                  `is_nullable` tinyint NULL DEFAULT 1 COMMENT '是否可空 0=否 1=是',
                                  `is_core` tinyint NULL DEFAULT 0 COMMENT '是否核心字段 0=否 1=是',
                                  `is_auto_increment` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否自增 0=否 1=是',
                                  `is_unique` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否唯一 0=否 1=是',
                                  `index_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'none' COMMENT '索引类型: none=无索引, normal=普通索引, unique=唯一索引, fulltext=全文索引',
                                  `default_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '默认值',
                                  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段描述',
                                  `sort` int NULL DEFAULT 0 COMMENT '排序',
                                  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                  `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  UNIQUE INDEX `uk_dev_dm_column_table_code`(`table_id` ASC, `code` ASC, `deleted` ASC) USING BTREE,
                                  INDEX `idx_table_id`(`table_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 60 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据模型-表字段信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dev_dm_column
-- ----------------------------
INSERT INTO `dev_dm_column` VALUES (1, 1, '用户ID', 'id', 'bigint', 20, 1, 0, 0, 1, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (2, 1, '用户名', 'username', 'varchar', 50, 0, 0, 0, 1, 0, 0, 'none', NULL, '登录用户名，唯一', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (3, 1, '密码', 'password', 'varchar', 255, 0, 0, 0, 0, 0, 0, 'none', NULL, 'BCrypt加密后的密码', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (4, 1, '昵称', 'nickname', 'varchar', 50, 0, 0, 1, 1, 0, 0, 'none', NULL, '显示名称', 4, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (5, 1, '状态', 'status', 'tinyint', 1, 0, 0, 0, 1, 0, 0, 'none', NULL, '0=禁用 1=正常', 5, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (6, 2, '角色ID', 'id', 'bigint', 20, 1, 0, 0, 1, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (7, 2, '角色名称', 'name', 'varchar', 50, 0, 0, 0, 1, 0, 0, 'none', NULL, '角色显示名称', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (8, 2, '角色编码', 'code', 'varchar', 50, 0, 0, 0, 1, 0, 0, 'none', NULL, '角色唯一标识，如super_admin', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (9, 2, '状态', 'status', 'tinyint', 1, 0, 0, 0, 0, 0, 0, 'none', NULL, '0=禁用 1=正常', 4, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (10, 3, '菜单ID', 'id', 'bigint', 20, 1, 0, 0, 1, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (11, 3, '父菜单ID', 'parent_id', 'bigint', 20, 0, 0, 1, 1, 0, 0, 'none', NULL, '0=顶级菜单', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (12, 3, '菜单名称', 'name', 'varchar', 50, 0, 0, 0, 1, 0, 0, 'none', NULL, '显示名称', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (13, 3, '菜单类型', 'type', 'tinyint', 1, 0, 0, 0, 1, 0, 0, 'none', NULL, '1=目录 2=菜单 3=按钮', 4, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (14, 4, '接口ID', 'id', 'bigint', 20, 1, 0, 0, 1, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (15, 4, '接口路径', 'path', 'varchar', 255, 0, 0, 0, 1, 0, 0, 'none', NULL, 'API路径，如/user/page', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (16, 4, '请求方法', 'method', 'varchar', 10, 0, 0, 0, 1, 0, 0, 'none', NULL, 'GET/POST/PUT/DELETE', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (17, 4, '是否公开', 'is_public', 'tinyint', 1, 0, 0, 0, 0, 0, 0, 'none', NULL, '0=需权限 1=公开', 4, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (18, 5, '关联ID', 'id', 'bigint', 20, 1, 0, 0, 0, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (19, 5, '用户ID', 'user_id', 'bigint', 20, 0, 1, 0, 1, 0, 0, 'none', NULL, '外键->sys_user.id', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (20, 5, '角色ID', 'role_id', 'bigint', 20, 0, 1, 0, 1, 0, 0, 'none', NULL, '外键->sys_role.id', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (21, 6, '关联ID', 'id', 'bigint', 20, 1, 0, 0, 0, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (22, 6, '角色ID', 'role_id', 'bigint', 20, 0, 1, 0, 1, 0, 0, 'none', NULL, '外键->sys_role.id', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (23, 6, '菜单ID', 'menu_id', 'bigint', 20, 0, 1, 0, 1, 0, 0, 'none', NULL, '外键->sys_menu.id', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (24, 7, '关联ID', 'id', 'bigint', 20, 1, 0, 0, 0, 0, 0, 'none', NULL, '主键，自增', 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (25, 7, '菜单ID', 'menu_id', 'bigint', 20, 0, 1, 0, 1, 0, 0, 'none', NULL, '外键->sys_menu.id', 2, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (26, 7, '接口ID', 'api_id', 'bigint', 20, 0, 1, 0, 1, 0, 0, 'none', NULL, '外键->sys_api.id', 3, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_column` VALUES (27, 8, '主键ID', 'ID', 'bigint', NULL, 1, 0, 0, 0, 0, 0, 'none', NULL, '', 0, '2026-03-28 14:08:32', '2026-03-28 14:08:32', 0);
INSERT INTO `dev_dm_column` VALUES (28, 8, 'Org', 'Org', 'bigint', NULL, 0, 1, 1, 0, 0, 0, 'none', NULL, '组织id', 0, '2026-03-28 14:11:03', '2026-03-28 14:11:03', 0);
INSERT INTO `dev_dm_column` VALUES (29, 8, '订单编号', 'DocNo', 'varchar', 50, 0, 0, 1, 1, 0, 0, 'none', NULL, '', 3, '2026-03-28 14:11:49', '2026-03-28 14:12:35', 0);
INSERT INTO `dev_dm_column` VALUES (30, 8, '是否取消', 'Cancel_Canceled', 'tinyint', NULL, 0, 0, 1, 0, 0, 0, 'none', NULL, '', 4, '2026-03-28 14:15:39', '2026-03-28 14:15:47', 0);
INSERT INTO `dev_dm_column` VALUES (35, 9, 'ID', 'id', 'bigint', NULL, 1, 0, 0, 0, 0, 0, 'none', '', '', 1, '2026-03-30 11:06:20', '2026-03-30 11:57:47', 0);
INSERT INTO `dev_dm_column` VALUES (36, 9, '销售单SO', 'SO', 'bigint', NULL, 0, 0, 0, 1, 0, 0, 'none', '', '', 2, '2026-03-30 11:06:20', '2026-03-30 11:57:47', 0);
INSERT INTO `dev_dm_column` VALUES (37, 9, '品号Id', 'iteminfo_itemid', 'varchar', NULL, 0, 0, 0, 1, 0, 0, 'none', '', 'CBO_ItemMaster表主键id', 3, '2026-03-30 11:06:20', '2026-03-30 11:57:47', 0);
INSERT INTO `dev_dm_column` VALUES (59, 9, '产品备注', 'DescFlexField_PubDescSeg12', 'varchar', NULL, 0, 0, 0, 1, 0, 0, 'none', '', '产品要求（备注）', 4, '2026-03-30 11:25:32', '2026-03-30 11:57:47', 0);

-- ----------------------------
-- Table structure for dev_dm_database
-- ----------------------------
DROP TABLE IF EXISTS `dev_dm_database`;
CREATE TABLE `dev_dm_database`  (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                    `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据库显示名称',
                                    `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据库编码（唯一标识）',
                                    `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'mysql' COMMENT '数据库类型: mysql, sqlserver, postgresql',
                                    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
                                    `sort` int NULL DEFAULT 0 COMMENT '排序',
                                    `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                                    `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                    `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                    `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    UNIQUE INDEX `uk_dev_dm_database_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据模型-数据库信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dev_dm_database
-- ----------------------------
INSERT INTO `dev_dm_database` VALUES (1, 'SmartAdmin系统', 'smart_admin', 'mysql', 'SmartAdmin 后台管理系统的数据库表结构演示', 1, 1, '2026-03-28 08:50:53', '2026-03-28 14:52:19', 0);
INSERT INTO `dev_dm_database` VALUES (2, '基础mysql-业务库1', 'base-mysql-group1', 'mysql', '', 2, 1, '2026-03-28 14:01:49', '2026-03-28 15:50:26', 1);
INSERT INTO `dev_dm_database` VALUES (3, '用友数据库', 'u9-erp', 'sqlserver', '', 2, 1, '2026-03-28 14:05:39', '2026-03-30 10:58:54', 0);

-- ----------------------------
-- Table structure for dev_dm_relation
-- ----------------------------
DROP TABLE IF EXISTS `dev_dm_relation`;
CREATE TABLE `dev_dm_relation`  (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                    `source_table_id` bigint NOT NULL COMMENT '源表ID',
                                    `source_column_id` bigint NOT NULL COMMENT '源字段ID',
                                    `target_table_id` bigint NOT NULL COMMENT '目标表ID',
                                    `target_column_id` bigint NOT NULL COMMENT '目标字段ID',
                                    `relation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关系类型：ONE_TO_ONE、ONE_TO_MANY、MANY_TO_ONE、MANY_TO_MANY',
                                    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关系描述',
                                    `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                    `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                    `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    UNIQUE INDEX `uk_dev_dm_relation`(`source_table_id` ASC, `source_column_id` ASC, `target_table_id` ASC, `target_column_id` ASC) USING BTREE,
                                    INDEX `idx_source_table`(`source_table_id` ASC) USING BTREE,
                                    INDEX `idx_target_table`(`target_table_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据模型-表关系信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dev_dm_relation
-- ----------------------------
INSERT INTO `dev_dm_relation` VALUES (1, 1, 1, 5, 19, 'ONE_TO_MANY', '一个用户对应多条用户角色记录', '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_relation` VALUES (2, 2, 6, 5, 20, 'ONE_TO_MANY', '一个角色对应多条用户角色记录', '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_relation` VALUES (3, 2, 6, 6, 22, 'ONE_TO_MANY', '一个角色对应多条角色菜单记录', '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_relation` VALUES (4, 3, 10, 6, 23, 'ONE_TO_MANY', '一个菜单对应多条角色菜单记录', '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_relation` VALUES (5, 3, 10, 7, 25, 'ONE_TO_MANY', '一个菜单对应多条菜单接口记录', '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_relation` VALUES (6, 4, 14, 7, 26, 'ONE_TO_MANY', '一个接口对应多条菜单接口记录', '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);

-- ----------------------------
-- Table structure for dev_dm_table
-- ----------------------------
DROP TABLE IF EXISTS `dev_dm_table`;
CREATE TABLE `dev_dm_table`  (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                 `database_id` bigint NOT NULL COMMENT '所属数据库ID',
                                 `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表显示名称',
                                 `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表编码（如 sys_user）',
                                 `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表描述',
                                 `sort` int NULL DEFAULT 0 COMMENT '排序',
                                 `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                                 `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
                                 PRIMARY KEY (`id`) USING BTREE,
                                 UNIQUE INDEX `uk_dev_dm_table_database_code`(`database_id` ASC, `code` ASC) USING BTREE,
                                 INDEX `idx_database_id`(`database_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据模型-数据表信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of dev_dm_table
-- ----------------------------
INSERT INTO `dev_dm_table` VALUES (1, 1, '用户表', 'sys_user', '系统用户基本信息', 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (2, 1, '角色表', 'sys_role', '系统角色定义', 2, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (3, 1, '菜单表', 'sys_menu', '系统菜单和权限点', 3, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (4, 1, '接口表', 'sys_api', '系统API接口资源', 4, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (5, 1, '用户角色关联', 'sys_user_role', '用户与角色的多对多关联', 5, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (6, 1, '角色菜单关联', 'sys_role_menu', '角色与菜单的多对多关联', 6, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (7, 1, '菜单接口关联', 'sys_menu_api', '菜单与API的多对多关联', 7, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53', 0);
INSERT INTO `dev_dm_table` VALUES (8, 3, '销售单', 'SM_SO', '', 0, 1, '2026-03-28 14:07:46', '2026-03-28 14:07:46', 0);
INSERT INTO `dev_dm_table` VALUES (9, 3, '销售单行', 'SM_SOLine', '', 1, 1, '2026-03-30 11:04:05', '2026-03-30 11:04:05', 0);

-- ----------------------------
-- Table structure for life_diet_record
-- ----------------------------
DROP TABLE IF EXISTS `life_diet_record`;
CREATE TABLE `life_diet_record`  (
                                     `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                     `user_id` bigint NOT NULL COMMENT '用户ID',
                                     `record_date` date NOT NULL COMMENT '记录日期',
                                     `meal_time` time NULL DEFAULT NULL COMMENT '用餐时间',
                                     `meal_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '餐食类型: breakfast/lunch/dinner/snack/drink',
                                     `food_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '食物名称',
                                     `portion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '份量，如: 1份、2碗、半碗',
                                     `tags` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签，多个逗号分隔: 健康、轻食、高糖、油炸、辣、清淡',
                                     `mood` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '心情: happy/good/so-so/binge/skip',
                                     `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '描述/备注',
                                     `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                     `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                     PRIMARY KEY (`id`) USING BTREE,
                                     INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
                                     INDEX `idx_record_date`(`record_date` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '饮食记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of life_diet_record
-- ----------------------------
INSERT INTO `life_diet_record` VALUES (1, 1, '2026-04-20', '07:45:00', 'breakfast', '饼干', '4 pics', 'light', 'happy', '吃的少', '2026-04-20 17:10:39', '2026-04-20 17:10:39');
INSERT INTO `life_diet_record` VALUES (2, 1, '2026-04-20', '12:15:00', 'lunch', '食堂四菜米饭', '1份', 'healthy', 'skip', '', '2026-04-20 17:11:31', '2026-04-20 17:13:24');
INSERT INTO `life_diet_record` VALUES (3, 1, '2026-04-20', '07:30:00', 'dinner', '蒸面，牛腩', '2碗', 'high-sugar,healthy', 'so-so', '2碗是不是有点多', '2026-04-21 08:45:31', '2026-04-21 08:45:31');
INSERT INTO `life_diet_record` VALUES (4, 1, '2026-04-21', '12:15:00', 'lunch', '食堂四菜米饭', '1份', 'healthy', 'so-so', '', '2026-04-21 14:38:50', '2026-04-21 15:33:48');
INSERT INTO `life_diet_record` VALUES (5, 1, '2026-04-22', '08:48:00', 'breakfast', '香蕉', '一根', 'healthy,bland', 'happy', '', '2026-04-22 08:48:26', '2026-04-22 08:51:47');

-- ----------------------------
-- Table structure for sys_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_api`;
CREATE TABLE `sys_api`  (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                            `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '接口路径',
                            `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GET' COMMENT '请求方法',
                            `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '接口名称',
                            `is_public` tinyint NULL DEFAULT 0 COMMENT '是否公开接口：0=否，1=是（无需权限即可访问）',
                            `status` tinyint NULL DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
                            `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
                            `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
                            `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
                            `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除',
                            PRIMARY KEY (`id`) USING BTREE,
                            INDEX `idx_path`(`path`(100) ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 103 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '接口资源表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_api
-- ----------------------------
INSERT INTO `sys_api` VALUES (1, '/auth/login', 'POST', '登录', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (2, '/auth/logout', 'POST', '登出', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (3, '/auth/userInfo', 'GET', '获取用户信息', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (4, '/auth/userMenus', 'GET', '获取用户菜单', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (10, '/user/page', 'GET', '用户分页查询', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (11, '/user', 'POST', '新增用户', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (12, '/user/*', 'PUT', '编辑用户', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (13, '/user/*', 'DELETE', '删除用户', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (14, '/user/resetPwd', 'PUT', '重置密码', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (15, '/user/assignRoles', 'PUT', '分配用户角色', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (16, '/user/roleIds/*', 'GET', '获取用户角色', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (20, '/role/list', 'GET', '角色列表', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (21, '/role', 'POST', '新增角色', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (22, '/role', 'PUT', '编辑角色', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (23, '/role/*', 'DELETE', '删除角色', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (24, '/role/assignMenus', 'PUT', '分配菜单权限', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (25, '/role/menuIds/*', 'GET', '获取角色菜单', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (30, '/menu/tree', 'GET', '菜单树', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (31, '/menu', 'POST', '新增菜单', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (32, '/menu', 'PUT', '编辑菜单', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (33, '/menu/*', 'DELETE', '删除菜单', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (40, '/api/list', 'GET', '接口列表', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (41, '/api', 'POST', '新增接口', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (42, '/api', 'PUT', '编辑接口', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (43, '/api/*', 'DELETE', '删除接口', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (50, '/dict/type/list', 'GET', '字典类型列表', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (51, '/dict/data/list', 'GET', '字典数据列表', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (52, '/dict/type', 'POST', '新增字典类型', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (53, '/dict/type', 'PUT', '编辑字典类型', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (54, '/dict/type/*', 'DELETE', '删除字典类型', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (60, '/loginlog/page', 'GET', '登录日志分页', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (61, '/loginlog/*', 'DELETE', '删除登录日志', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (62, '/loginlog/clear', 'DELETE', '清空登录日志', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (70, '/operlog/page', 'GET', '操作日志分页', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (71, '/operlog/*', 'DELETE', '删除操作日志', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (72, '/operlog/clear', 'DELETE', '清空操作日志', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (80, '/profile', 'GET', '获取个人信息', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (81, '/profile/password', 'PUT', '修改密码', 0, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (82, '/datamodel/database/page', 'GET', '数据库分页查询', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (83, '/datamodel/database/list', 'GET', '数据库列表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (84, '/datamodel/database', 'POST', '新增数据库', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (85, '/datamodel/database', 'PUT', '编辑数据库', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (86, '/datamodel/database/*', 'DELETE', '删除数据库', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (87, '/datamodel/table/page', 'GET', '数据表分页查询', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (88, '/datamodel/table/list/*', 'GET', '某数据库下表列表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (89, '/datamodel/table/tree', 'GET', '数据库-表树形结构', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (90, '/datamodel/table', 'POST', '新增数据表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (91, '/datamodel/table', 'PUT', '编辑数据表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (92, '/datamodel/table/*', 'DELETE', '删除数据表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (93, '/datamodel/column/list/*', 'GET', '字段列表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (94, '/datamodel/column', 'POST', '新增字段', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (95, '/datamodel/column', 'PUT', '编辑字段', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (96, '/datamodel/column/*', 'DELETE', '删除字段', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (97, '/datamodel/relation/list', 'GET', '关系列表', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (98, '/datamodel/relation', 'POST', '新增关系', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (99, '/datamodel/relation', 'PUT', '编辑关系', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (100, '/datamodel/relation/*', 'DELETE', '删除关系', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (101, '/datamodel/er-diagram/*', 'GET', 'E-R图数据', 0, 1, NULL, '', '2026-03-28 08:50:53', '', '2026-03-28 08:50:53', 0);
INSERT INTO `sys_api` VALUES (102, '/datamodel/column/batch', 'POST', '批量保存字段', 0, 1, '数据模型字段批量新增和更新', '', '2026-03-30 09:00:08', '', '2026-03-30 09:39:31', 0);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
                                  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典类型',
                                  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典标签',
                                  `value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典键值',
                                  `sort` int NULL DEFAULT 0 COMMENT '排序',
                                  `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                                  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '样式属性',
                                  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '表格回显样式',
                                  `is_default` tinyint NULL DEFAULT 0 COMMENT '是否默认 0=否 1=是',
                                  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
                                  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  INDEX `idx_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 'sys_user_sex', '未知', '0', 1, 1, '', '', 1, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (2, 'sys_user_sex', '男', '1', 2, 1, '', '', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (3, 'sys_user_sex', '女', '2', 3, 1, '', '', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (4, 'sys_common_status', '关闭', '0', 1, 1, '', '', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (5, 'sys_common_status', '开启', '1', 2, 1, '', '', 1, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (6, 'sys_menu_type', '目录', '1', 1, 1, '', 'tag-blue', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (7, 'sys_menu_type', '菜单', '2', 2, 1, '', 'tag-green', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (8, 'sys_menu_type', '按钮', '3', 3, 1, '', 'tag-orange', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (9, 'sys_menu_type', '接口', '4', 4, 1, '', 'tag-red', 0, '', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_data` VALUES (10, 'dm_relation_type', '一对一', 'ONE_TO_ONE', 1, 1, '', 'tag-blue', 1, '', '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_dict_data` VALUES (11, 'dm_relation_type', '一对多', 'ONE_TO_MANY', 2, 1, '', 'tag-green', 0, '', '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_dict_data` VALUES (12, 'dm_relation_type', '多对一', 'MANY_TO_ONE', 3, 1, '', 'tag-orange', 0, '', '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_dict_data` VALUES (13, 'dm_relation_type', '多对多', 'MANY_TO_MANY', 4, 1, '', 'tag-red', 0, '', '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_dict_data` VALUES (14, 'dm_column_type', '核心字段', '1', 1, 1, '', 'tag-primary', 1, '', '2026-03-28 08:50:53', '2026-03-28 08:50:53');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
                                  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '字典名称',
                                  `type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典类型',
                                  `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                                  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '备注',
                                  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  UNIQUE INDEX `uk_type`(`type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', 1, '用户性别列表', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_type` VALUES (2, '系统开关', 'sys_common_status', 1, '系统开关列表', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_type` VALUES (3, '菜单类型', 'sys_menu_type', 1, '菜单类型列表', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_type` VALUES (4, '关系类型', 'dm_relation_type', 1, '数据表关系类型', '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_dict_type` VALUES (5, '字段类型', 'dm_column_type', 1, '数据模型字段类型标记', '2026-03-28 08:50:53', '2026-03-28 08:50:53');

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log`  (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                  `user_id` bigint NULL DEFAULT NULL COMMENT '用户 ID',
                                  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '用户名',
                                  `login_status` tinyint NULL DEFAULT 1 COMMENT '登录状态 0=失败 1=成功',
                                  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录 IP',
                                  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '登录地点',
                                  `browser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '浏览器',
                                  `os` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作系统',
                                  `msg` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '提示信息',
                                  `login_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
                                  INDEX `idx_login_time`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 77 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '登录日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------


-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
                             `id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单 ID',
                             `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单 ID 0=顶级',
                             `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
                             `type` tinyint NOT NULL DEFAULT 1 COMMENT '类型：1=目录，2=菜单，3=按钮',
                             `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '路由路径',
                             `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '组件路径',
                             `permission` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '权限标识 (如 user:add)',
                             `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '图标',
                             `sort` int NULL DEFAULT 0 COMMENT '排序',
                             `visible` tinyint NULL DEFAULT 1 COMMENT '是否可见 0=隐藏 1=显示',
                             `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                             `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                             `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                             PRIMARY KEY (`id`) USING BTREE,
                             INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
                             INDEX `idx_type`(`type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '系统管理', 1, '/system', 'Layout', '', 'Setting', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (2, 1, '用户管理', 2, '/system/user', 'system/user/index', '', 'User', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (3, 2, '新增用户', 3, '', '', 'user:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (4, 2, '编辑用户', 3, '', '', 'user:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (5, 2, '删除用户', 3, '', '', 'user:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (6, 2, '重置密码', 3, '', '', 'user:resetPwd', '', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (7, 1, '角色管理', 2, '/system/role', 'system/role/index', '', 'UserFilled', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:19:37');
INSERT INTO `sys_menu` VALUES (8, 7, '新增角色', 3, '', '', 'role:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (9, 7, '编辑角色', 3, '', '', 'role:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (10, 7, '删除角色', 3, '', '', 'role:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (11, 7, '分配权限', 3, '', '', 'role:assign', '', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (12, 1, '菜单管理', 2, '/system/menu', 'system/menu/index', '', 'Menu', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (13, 12, '新增菜单', 3, '', '', 'menu:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (14, 12, '编辑菜单', 3, '', '', 'menu:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (15, 12, '删除菜单', 3, '', '', 'menu:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (16, 1, '字典管理', 2, '/system/dict', 'system/dict/index', '', 'Collection', 5, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (17, 16, '新增字典', 3, '', '', 'dict:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (18, 16, '编辑字典', 3, '', '', 'dict:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (19, 16, '删除字典', 3, '', '', 'dict:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (20, 1, '登录日志', 2, '/system/loginlog', 'system/loginlog/index', '', 'Document', 6, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (21, 1, '操作日志', 2, '/system/operlog', 'system/operlog/index', '', 'List', 7, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (22, 0, '个人中心', 2, '/profile', 'profile/index', '', 'User', 0, 0, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (23, 22, '修改密码', 3, '', '', 'profile:resetPwd', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (25, 20, '删除日志', 3, '', '', 'loginlog:delete', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (26, 20, '清空日志', 3, '', '', 'loginlog:clear', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (28, 21, '删除日志', 3, '', '', 'operlog:delete', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (29, 21, '清空日志', 3, '', '', 'operlog:clear', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (40, 1, 'API 管理', 2, '/system/api', 'system/api/index', '', 'Connection', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (41, 40, '新增接口', 3, '', '', 'api:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (42, 40, '编辑接口', 3, '', '', 'api:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (43, 40, '删除接口', 3, '', '', 'api:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (44, 2, '分配角色', 3, '', '', 'user:assignRole', '', 5, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (50, 0, '开发工具', 1, '/devtools', 'Layout', '', 'Tools', 2, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (51, 50, '数据模型', 2, '/devtools/datamodel', 'devtools/datamodel/index', '', 'DataAnalysis', 1, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (52, 51, '新增数据库', 3, '', '', 'datamodel:database:add', '', 1, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (53, 51, '编辑数据库', 3, '', '', 'datamodel:database:edit', '', 2, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (54, 51, '删除数据库', 3, '', '', 'datamodel:database:delete', '', 3, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (55, 51, '新增数据表', 3, '', '', 'datamodel:table:add', '', 4, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (56, 51, '编辑数据表', 3, '', '', 'datamodel:table:edit', '', 5, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (57, 51, '删除数据表', 3, '', '', 'datamodel:table:delete', '', 6, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (58, 51, '新增关系', 3, '', '', 'datamodel:relation:add', '', 7, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (59, 51, '编辑关系', 3, '', '', 'datamodel:relation:edit', '', 8, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (60, 51, '删除关系', 3, '', '', 'datamodel:relation:delete', '', 9, 1, 1, '2026-03-28 08:50:53', '2026-03-28 08:50:53');
INSERT INTO `sys_menu` VALUES (61, 51, '批量编辑字段', 3, '', '', 'datamodel:column:batch', '', 10, 1, 1, '2026-03-30 09:00:08', '2026-03-30 09:00:08');
INSERT INTO `sys_menu` VALUES (62, 0, '本地生活', 1, '/lifestyle', 'Layout', '', 'Grid', 3, 1, 1, '2026-04-20 16:18:09', '2026-04-20 16:18:09');
INSERT INTO `sys_menu` VALUES (63, 62, '饮食管理', 2, '/lifestyle/diet', 'lifestyle/diet/index', '', 'Food', 1, 1, 1, '2026-04-20 16:18:09', '2026-04-20 16:21:56');
INSERT INTO `sys_menu` VALUES (64, 62, '头脑风暴', 2, '/lifestyle/brainstorm', 'lifestyle/brainstorm/index', '', 'Monitor', 2, 1, 1, '2026-04-21 08:43:29', '2026-04-21 08:43:29');
INSERT INTO `sys_menu` VALUES (65, 62, '文本收集', 2, '/lifestyle/text-collection', 'lifestyle/text-collection/index', '', 'Document', 3, 1, 1, '2026-04-21 08:43:29', '2026-04-21 08:43:29');
INSERT INTO `sys_menu` VALUES (66, 62, '任务记录', 2, '/lifestyle/task-record', 'lifestyle/task-record/index', '', 'List', 4, 1, 1, '2026-04-21 08:43:29', '2026-04-21 08:43:29');

-- ----------------------------
-- Table structure for sys_menu_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_api`;
CREATE TABLE `sys_menu_api`  (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                 `menu_id` bigint NOT NULL COMMENT '菜单ID',
                                 `api_id` bigint NOT NULL COMMENT '接口ID',
                                 `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 PRIMARY KEY (`id`) USING BTREE,
                                 UNIQUE INDEX `uk_menu_api`(`menu_id` ASC, `api_id` ASC) USING BTREE,
                                 INDEX `idx_api_id`(`api_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 58 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单接口关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu_api
-- ----------------------------
INSERT INTO `sys_menu_api` VALUES (1, 2, 10, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (2, 3, 11, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (3, 4, 12, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (4, 5, 13, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (5, 6, 14, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (6, 7, 20, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (7, 8, 21, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (8, 9, 22, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (9, 10, 23, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (10, 11, 24, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (11, 11, 25, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (12, 12, 30, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (13, 13, 31, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (14, 14, 32, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (15, 15, 33, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (16, 40, 40, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (17, 41, 41, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (18, 42, 42, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (19, 43, 43, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (20, 16, 50, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (21, 16, 51, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (22, 17, 52, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (23, 18, 53, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (24, 19, 54, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (25, 20, 60, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (26, 25, 61, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (27, 26, 62, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (28, 21, 70, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (29, 28, 71, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (30, 29, 72, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (31, 22, 80, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (32, 23, 81, '2026-03-24 17:01:51');
INSERT INTO `sys_menu_api` VALUES (33, 44, 15, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (34, 44, 16, '2026-03-24 17:01:50');
INSERT INTO `sys_menu_api` VALUES (35, 51, 83, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (36, 51, 82, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (38, 52, 84, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (39, 53, 85, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (40, 54, 86, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (41, 51, 88, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (42, 51, 87, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (43, 51, 89, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (44, 55, 90, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (45, 56, 91, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (46, 57, 92, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (47, 51, 96, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (48, 51, 93, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (50, 51, 97, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (51, 58, 98, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (52, 59, 99, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (53, 60, 100, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (54, 51, 101, '2026-03-28 08:50:53');
INSERT INTO `sys_menu_api` VALUES (57, 61, 102, '2026-03-30 09:39:31');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                 `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '模块标题',
                                 `business_type` tinyint NULL DEFAULT 0 COMMENT '业务类型 0=其它 1=新增 2=修改 3=删除',
                                 `method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '方法名称',
                                 `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求方式',
                                 `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作人员',
                                 `oper_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '主机地址',
                                 `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '操作地点',
                                 `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '部门名称',
                                 `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求 URL',
                                 `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '请求参数',
                                 `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '返回参数',
                                 `status` tinyint NULL DEFAULT 1 COMMENT '操作状态 0=失败 1=成功',
                                 `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '错误消息',
                                 `oper_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
                                 `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间 (毫秒)',
                                 PRIMARY KEY (`id`) USING BTREE,
                                 INDEX `idx_oper_time`(`oper_time` ASC) USING BTREE,
                                 INDEX `idx_business_type`(`business_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 371 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
                             `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色 ID',
                             `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色名称',
                             `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '角色编码',
                             `sort` int NULL DEFAULT 0 COMMENT '排序',
                             `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                             `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                             `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                             `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
                             PRIMARY KEY (`id`) USING BTREE,
                             UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'super_admin', 1, 1, '2026-03-18 12:03:48', '2026-03-18 12:03:48', 0);
INSERT INTO `sys_role` VALUES (2, '普通用户', 'common_user', 2, 1, '2026-03-18 12:03:48', '2026-03-18 12:03:48', 0);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                  `role_id` bigint NOT NULL COMMENT '角色 ID',
                                  `menu_id` bigint NOT NULL COMMENT '菜单 ID',
                                  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  UNIQUE INDEX `uk_role_menu`(`role_id` ASC, `menu_id` ASC) USING BTREE,
                                  INDEX `idx_menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (4, 2, 1, '2026-03-27 10:11:43', 0);
INSERT INTO `sys_role_menu` VALUES (5, 2, 20, '2026-03-27 10:11:43', 0);
INSERT INTO `sys_role_menu` VALUES (6, 2, 21, '2026-03-27 10:11:43', 0);
INSERT INTO `sys_role_menu` VALUES (7, 2, 22, '2026-03-27 10:11:43', 0);
INSERT INTO `sys_role_menu` VALUES (8, 2, 23, '2026-03-27 10:11:43', 0);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
                             `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
                             `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
                             `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码 (BCrypt 加密)',
                             `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称',
                             `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '头像 URL',
                             `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '邮箱',
                             `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '手机号',
                             `sex` tinyint NULL DEFAULT 0 COMMENT '性别 0=未知 1=男 2=女',
                             `status` tinyint NULL DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
                             `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                             `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                             `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
                             PRIMARY KEY (`id`) USING BTREE,
                             UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$BrX3F2G.AuVhdk76W1tzDuLX61XOrrVLC.kRUxuZ/wO8b/B1uPWby', '管理员', '', 'admin@example.com', '', 0, 1, '2026-03-18 12:03:48', '2026-03-18 12:12:23', 0);
INSERT INTO `sys_user` VALUES (2, 'zhangsan', '$2a$10$ZPH61oc.ejlCCd/2w0ddL./vI1v7A6gjXWbD9kQCaIdle2JWehWga', '张三', '', '123@qq.com', '', 0, 1, '2026-03-18 17:22:10', '2026-03-18 17:22:10', 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
                                  `user_id` bigint NOT NULL COMMENT '用户 ID',
                                  `role_id` bigint NOT NULL COMMENT '角色 ID',
                                  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  PRIMARY KEY (`id`) USING BTREE,
                                  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
                                  INDEX `idx_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, 1, '2026-03-18 12:03:48');
INSERT INTO `sys_user_role` VALUES (2, 2, 2, '2026-03-20 11:56:15');

SET FOREIGN_KEY_CHECKS = 1;
