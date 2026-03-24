/*
 Navicat Premium Dump SQL

 Source Server         : z-local-docker-mysql
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : auto_admin

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 24/03/2026 09:23:01
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_api`;
CREATE TABLE `sys_api`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '接口路径',
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'GET' COMMENT '请求方法',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '接口名称',
  `menu_id` bigint NULL DEFAULT NULL COMMENT '关联的菜单 ID',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_path`(`path`(100) ASC) USING BTREE,
  INDEX `idx_menu_id`(`menu_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '接口资源表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_api
-- ----------------------------
INSERT INTO `sys_api` VALUES (1, '/auth/login', 'POST', '登录', NULL, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (2, '/auth/logout', 'POST', '登出', NULL, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (3, '/auth/userInfo', 'GET', '获取用户信息', NULL, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (4, '/auth/userMenus', 'GET', '获取用户菜单', NULL, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (10, '/user/page', 'GET', '用户分页查询', 30, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (11, '/user', 'POST', '新增用户', 3, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (12, '/user/*', 'PUT', '编辑用户', 4, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (13, '/user/*', 'DELETE', '删除用户', 5, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (14, '/user/resetPwd', 'PUT', '重置密码', 6, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (20, '/role/list', 'GET', '角色列表', 31, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (21, '/role', 'POST', '新增角色', 8, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (22, '/role', 'PUT', '编辑角色', 9, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (23, '/role/*', 'DELETE', '删除角色', 10, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (24, '/role/assignMenus', 'PUT', '分配菜单权限', 11, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (25, '/role/menuIds/*', 'GET', '获取角色菜单', 11, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (30, '/menu/tree', 'GET', '菜单树', 32, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (31, '/menu', 'POST', '新增菜单', 13, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (32, '/menu', 'PUT', '编辑菜单', 14, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (33, '/menu/*', 'DELETE', '删除菜单', 15, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (40, '/api/list', 'GET', '接口列表', 44, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (41, '/api', 'POST', '新增接口', 41, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (42, '/api', 'PUT', '编辑接口', 42, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (43, '/api/*', 'DELETE', '删除接口', 43, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (50, '/dict/type/list', 'GET', '字典类型列表', 33, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (51, '/dict/data/list', 'GET', '字典数据列表', 34, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (52, '/dict/type', 'POST', '新增字典类型', 17, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (53, '/dict/type', 'PUT', '编辑字典类型', 18, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (54, '/dict/type/*', 'DELETE', '删除字典类型', 19, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (60, '/loginlog/page', 'GET', '登录日志分页', 24, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (61, '/loginlog/*', 'DELETE', '删除登录日志', 25, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (62, '/loginlog/clear', 'DELETE', '清空登录日志', 26, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (70, '/operlog/page', 'GET', '操作日志分页', 27, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (71, '/operlog/*', 'DELETE', '删除操作日志', 28, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (72, '/operlog/clear', 'DELETE', '清空操作日志', 29, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (80, '/profile', 'GET', '获取个人信息', 35, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (81, '/profile/password', 'PUT', '修改密码', 23, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', 1, '用户性别列表', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_type` VALUES (2, '系统开关', 'sys_common_status', 1, '系统开关列表', '2026-03-18 12:03:48', '2026-03-18 12:03:48');
INSERT INTO `sys_dict_type` VALUES (3, '菜单类型', 'sys_menu_type', 1, '菜单类型列表', '2026-03-18 12:03:48', '2026-03-18 12:03:48');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '登录日志表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 45 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

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
INSERT INTO `sys_menu` VALUES (24, 20, '查看日志', 3, '', '', 'loginlog:query', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (25, 20, '删除日志', 3, '', '', 'loginlog:delete', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (26, 20, '清空日志', 3, '', '', 'loginlog:clear', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (27, 21, '查看日志', 3, '', '', 'operlog:query', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (28, 21, '删除日志', 3, '', '', 'operlog:delete', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (29, 21, '清空日志', 3, '', '', 'operlog:clear', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (30, 2, '查看用户', 3, '', '', 'user:query', '', 5, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (31, 7, '查看角色', 3, '', '', 'role:query', '', 5, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (32, 12, '查看菜单', 3, '', '', 'menu:query', '', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (33, 16, '查看字典', 3, '', '', 'dict:query', '', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (34, 16, '查询字典数据', 3, '', '', 'dict:data:list', '', 5, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (35, 22, '获取个人信息', 3, '', '', 'profile:get', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (40, 1, 'API 管理', 2, '/system/api', 'system/api/index', '', 'Connection', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (41, 40, '新增接口', 3, '', '', 'api:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (42, 40, '编辑接口', 3, '', '', 'api:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (43, 40, '删除接口', 3, '', '', 'api:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (44, 40, '查看接口', 3, '', '', 'api:query', '', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');

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
) ENGINE = InnoDB AUTO_INCREMENT = 167 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (1, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773807101676}', 1, '', NULL, 286);
INSERT INTO `sys_oper_log` VALUES (2, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgwNzIxOCwiZXhwIjoxNzczODE0NDE4fQ.EJmsH4557XCNQzvQ0gA5fGHSu2Haepb9a6A8cdC5FhP6zY21Ai3A6BPd1VekE63j\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773807218927}', 1, '', NULL, 120);
INSERT INTO `sys_oper_log` VALUES (3, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773810268627}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (4, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxMDI3MSwiZXhwIjoxNzczODE3NDcxfQ.2MCixyXx3FX7itqgYZmrwrQ5UYfkITyS0HSDFtN_YXiyBTvPbnRVSMFVWJ7dVv6G\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773810271864}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (5, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773810549380}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (6, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxMDU1MSwiZXhwIjoxNzczODE3NzUxfQ.C6pJ3FO5GYYNM_kyGRK2cjmj2uxS7p-G0_zJSuiJXsHm9WtUQWarHKi85Tkp8gu3\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773810551310}', 1, '', NULL, 72);
INSERT INTO `sys_oper_log` VALUES (7, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773812996191}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (8, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxMjk5OCwiZXhwIjoxNzczODIwMTk4fQ.88Z-Zosx3AZ9WQVRFe_YRbVGxm-YWSnKswyYuEBzL6yi4J6tEbIqRamzYcsqUw4g\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773812998858}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (9, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773813069439}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (10, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxMzA3NiwiZXhwIjoxNzczODIwMjc2fQ.u5DWJ_vicVY6GVe5iK4KaWzyTv_IecB6t86wMMRB83zl97PrR3yug-fe-RZubXF7\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773813076568}', 1, '', NULL, 70);
INSERT INTO `sys_oper_log` VALUES (11, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773813296764}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (12, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxMzI5OCwiZXhwIjoxNzczODIwNDk4fQ.yFF7nW9tBKUx_OKzbIeIWhG75SbEpNtbR6LsRxKXmkErNS2ZJHoa0HjdZXTTSCaS\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773813298142}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (13, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773813668535}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (14, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxMzY2OSwiZXhwIjoxNzczODIwODY5fQ.NmTmfWEBarNEIYEawr7aT8220IfGZglwmZNTNjwkegDxHt1Do_J4BzDToVgA2cqV\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773813669477}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (15, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773814325070}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (16, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNDMyNywiZXhwIjoxNzczODIxNTI3fQ.QP2VI3e7mSDloFwG8cVHUlEYPha1NN4bRR7Vfs8T-e3O6pHFI3FccyngGU5quGhU\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773814327353}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (17, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773815173584}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (18, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNTE4NiwiZXhwIjoxNzczODIyMzg2fQ.BKJO4xcQej8pTTL0c3dZWJgF-bUS_h-O4qMAQQg26GA13C3v360s0-IEZ9uknwQg\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773815186025}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (19, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773815361828}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (20, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNTM2MywiZXhwIjoxNzczODIyNTYzfQ.t7EPcSEKYIV84h9Xqn9VEExmYUuVFKu3IkkWlbNB9JeDMlJpPa9lUag2qnScGuh4\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773815363971}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (21, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773815437449}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (22, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNTQzOSwiZXhwIjoxNzczODIyNjM5fQ.H2DjTtD2_fnmq7kF7BeqNQIQemcdvBBKdGsSO8866lLng9xshCEAEoX-68quinYs\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773815439425}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (23, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773815719245}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (24, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNTcyMywiZXhwIjoxNzczODIyOTIzfQ.EMtQ77makLrbd0Ui3PTvcpLKHbal25g70ry1FGAyQ0uRHUWnoyz0bjVr1x1nif_C\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773815723359}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (25, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773816081673}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (26, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1234\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773816096133}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (27, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNjEwMSwiZXhwIjoxNzczODIzMzAxfQ.cGTDWkwAuzhizU-gXfaU9qwRAQ5tttNJSJ3a2Zme_Z48DSFpFqHilY1K-RXeAnFI\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773816101457}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (28, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773816182477}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (29, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNjIzMCwiZXhwIjoxNzczODIzNDMwfQ.HT71p01RRQKL9N97YpsfzVBKu5j0aT1MQjLlAG-Bkk3uvMer0QWQZJ0bPeHP4ewh\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773816230586}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (30, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773816587516}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (31, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNjY0MywiZXhwIjoxNzczODIzODQzfQ.z88CG58YI7Qcp4DmV59IZ_TgFKYVQ0M1gshdIkTIKqOPMTpRDMMcfsaP5e5XyUKx\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773816643301}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (32, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773816655291}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (33, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNjY1NiwiZXhwIjoxNzczODIzODU2fQ.TivITbkGqtSyR9L2EcyQkeGLI6Xn5w-JPQcOAHiGQpIqCoJxBMYEYVSckFHwzld8\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773816656303}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (34, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773817083659}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (35, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNzA4NCwiZXhwIjoxNzczODI0Mjg0fQ.hMtL-VlK6aXY9au9bEsm38stlAmaG7q8vGtSg7dwCAKm_DZ5Rt0-NRmqorWtrsuj\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773817084747}', 1, '', NULL, 78);
INSERT INTO `sys_oper_log` VALUES (36, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773817387237}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (37, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1233\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773817395707}', 1, '', NULL, 80);
INSERT INTO `sys_oper_log` VALUES (38, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNzM5NywiZXhwIjoxNzczODI0NTk3fQ.hI5saOsNKbTK_NbAtwrY5rpVW25ASdpAv4hWfJ5Eh7hU1gO-p7MC40sqZvTgeGRE\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773817397899}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (39, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773817454480}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (40, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgxNzQ1NSwiZXhwIjoxNzczODI0NjU1fQ.p7EXi0x9ptehv5DVGRG-IstFrt5uR_01DseQQ18yJJPli9n6-7KtSn4hfvVB7xx2\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773817455755}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (41, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773821931864}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (42, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyMTk0OCwiZXhwIjoxNzczODI5MTQ4fQ.PDXyaE5aq1wiLEQvkm4V0KYst4q2SyQmjFI-3Ccnr102H7kNPX2XmgMwW3OeQbLj\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773821948021}', 1, '', NULL, 83);
INSERT INTO `sys_oper_log` VALUES (43, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773821948055}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (44, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"操作成功\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyMjI5MiwiZXhwIjoxNzczODI5NDkyfQ.vGheEwNTxmPSmsFyHhECWABPhCLI7IT8NewCZ6yqHhXenvtNXmfAolJkJ1ts53c_\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773822292458}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (45, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"操作成功\",\"timestamp\":1773822292491}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (46, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyMjkwOSwiZXhwIjoxNzczODMwMTA5fQ.1LRcQBgMHt0S3l9mNRKZ6Fs3aCCz7mSJ5UU6Uy9XrpObv-FT8PDxGcL2Gx3Repdg\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773822910027}', 1, '', NULL, 344);
INSERT INTO `sys_oper_log` VALUES (47, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773822910132}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (48, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyMzMyMiwiZXhwIjoxNzczODMwNTIyfQ.BByhIZ67myYwTUQv-nsRmBbMjvdeLwue7SAmYYKvczGraRjH3SZnAgco2_fV3zZH\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773823322019}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (49, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773823322053}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (50, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyMzMyNiwiZXhwIjoxNzczODMwNTI2fQ.iDm2mue-oJuZISBCJqQu26kIq90iaDBMYkjL6pakC6IAtYhlyPAeJNVVPD3AJjnW\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773823326757}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (51, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773823326795}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (52, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyMzQxNCwiZXhwIjoxNzczODMwNjE0fQ.llgtCe4sxezEoHtH1U_vDpz_PFXOhkUUQLNx0K1ufABuPjy3Tlmfzzetb6z6ne2H\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773823414744}', 1, '', NULL, 331);
INSERT INTO `sys_oper_log` VALUES (53, '用户管理', 1, 'com.autoadmin.controller.UserController.add()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/user', '{\"username\":\"zhangsan\",\"nickname\":\"张三\",\"email\":\"123@qq.com\",\"phone\":\"\",\"sex\":1,\"status\":1};', '', 0, 'rawPassword cannot be null', NULL, 38);
INSERT INTO `sys_oper_log` VALUES (54, '用户管理', 1, 'com.autoadmin.controller.UserController.add()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/user', '{\"username\":\"zhangsan\",\"nickname\":\"张三\",\"email\":\"123@qq.com\",\"phone\":\"\",\"sex\":1,\"status\":1};', '', 0, 'rawPassword cannot be null', NULL, 3);
INSERT INTO `sys_oper_log` VALUES (55, '用户管理', 1, 'com.autoadmin.controller.UserController.add()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/user', '{\"username\":\"zhangsan\",\"nickname\":\"张三\",\"email\":\"1232@qq.com\",\"phone\":\"\",\"sex\":1,\"status\":1};', '', 0, 'rawPassword cannot be null', NULL, 40);
INSERT INTO `sys_oper_log` VALUES (56, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773825366923}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (57, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyNTM3MCwiZXhwIjoxNzczODMyNTcwfQ.QN6TOvlj6t7YdqjIfhbESwNg_QcAgjQOVHpqH6QKT8n06EB5wQzq22CRmSgap6u2\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773825370392}', 1, '', NULL, 87);
INSERT INTO `sys_oper_log` VALUES (58, '用户管理', 1, 'com.autoadmin.controller.UserController.add()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/user', '{\"username\":\"zhangsan\",\"password\":\"123456\",\"nickname\":\"张三\",\"email\":\"123@qq.com\",\"phone\":\"\",\"sex\":0,\"status\":1};', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773825730260}', 1, '', NULL, 79);
INSERT INTO `sys_oper_log` VALUES (59, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773827705622}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (60, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyNzcxMywiZXhwIjoxNzczODM0OTEzfQ.WekVshNpUrmIo3EOg2TUtGOIrRmKsWFlHMSZ3ny7ACL0ZiP_5Q8Fh7oqrfBsDWGz\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773827713426}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (61, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773827804317}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (62, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3MzgyNzgxNCwiZXhwIjoxNzczODM1MDE0fQ.cLMMnkw0ZsMnqwjNV9mKoSjnU6OsryhBCjw_MFneKeZQlkdQo8HZwYdjnUPFVG0U\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773827814577}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (63, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773827845627}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (64, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzgyNzg1MCwiZXhwIjoxNzczODM1MDUwfQ.wrexfHTozjQlePLcq8HajlxeTBiskch12FLYZLXbg-NHkHCVG3UcOXcHb1k4TAbG\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773827850052}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (65, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773827853124}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (66, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3MzgyNzg4MiwiZXhwIjoxNzczODM1MDgyfQ.KJfTTwxkl3l63w158og-CJ7q7AUufis9ZtJuRSH72FctJKzeyGgGO8qGc4Nwsxlm\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773827882441}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (67, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773880762015}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (68, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4MDc2NCwiZXhwIjoxNzczODg3OTY0fQ.RyNhoM0u5ZMTN3m-EokAp5WZHmPnq9fuvy-Kb9qP7dzbd9YFtelVl6e6Y0nsrKgY\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773880764691}', 1, '', NULL, 83);
INSERT INTO `sys_oper_log` VALUES (69, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773881550579}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (70, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1235\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773881555958}', 1, '', NULL, 72);
INSERT INTO `sys_oper_log` VALUES (71, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4MTU2MSwiZXhwIjoxNzczODg4NzYxfQ.TI4cN6S3Pj7xuo5CotXUIDGWUzFxcJeoRMPWQdufEv8HpsiLa_jJBuqNBDjT1Oew\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773881561155}', 1, '', NULL, 72);
INSERT INTO `sys_oper_log` VALUES (72, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773881564678}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (73, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4MTU3NiwiZXhwIjoxNzczODg4Nzc2fQ.VPC0x_tbDEEdSPoUBiPK9p2LYVfqQPkhM4swmb7s0_MQUFC9S_lZRU5yffSPUkjq\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773881576903}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (74, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773881579838}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (75, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1231\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773881583560}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (76, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1231\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773881642565}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (77, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4MTY0NiwiZXhwIjoxNzczODg4ODQ2fQ.66q17dKQy0g51_c8VPzsPU2gmdqzgjHOZNLucpdLLhCtZ4UlhQZJ0l4uGV3ls5nT\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773881646320}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (78, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773882429314}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (79, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4MjQzMCwiZXhwIjoxNzczODg5NjMwfQ.avYQSLN6pUx4YtTzARl-dhVQ7b789SoHAwVoSia0EMYmXFW3LbSe0b9LYi--Ly7Y\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773882430687}', 1, '', NULL, 79);
INSERT INTO `sys_oper_log` VALUES (80, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773882434276}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (81, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin12312\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773882436760}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (82, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin12312\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773882437918}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (83, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin12312\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773882438752}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (84, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin12312\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773882442502}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (85, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin12312\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773882445338}', 1, '', NULL, 78);
INSERT INTO `sys_oper_log` VALUES (86, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1232\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773888749806}', 1, '', NULL, 95);
INSERT INTO `sys_oper_log` VALUES (87, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1232\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773888750608}', 1, '', NULL, 82);
INSERT INTO `sys_oper_log` VALUES (88, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4OTM0NiwiZXhwIjoxNzczODk2NTQ2fQ.sLYk9dc37aHQ11KJXJKcLv3htsPc4n9p70rPogPzrhcdnU1LK7Kls3g50X6llKEi\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773889346196}', 1, '', NULL, 378);
INSERT INTO `sys_oper_log` VALUES (89, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg4OTM0NiwiZXhwIjoxNzczODk2NTQ2fQ.sLYk9dc37aHQ11KJXJKcLv3htsPc4n9p70rPogPzrhcdnU1LK7Kls3g50X6llKEi\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773889346951}', 1, '', NULL, 86);
INSERT INTO `sys_oper_log` VALUES (90, '用户登出', 9, 'com.autoadmin.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773889350086}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (91, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1231\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773889354278}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (92, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1231\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773889386327}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (93, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1231\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773890232129}', 1, '', NULL, 78);
INSERT INTO `sys_oper_log` VALUES (94, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123121\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773890234602}', 1, '', NULL, 71);
INSERT INTO `sys_oper_log` VALUES (95, '用户登录', 8, 'com.autoadmin.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzg5MDI0MywiZXhwIjoxNzczODk3NDQzfQ.E-atp1v7prNzxUuVTKuK0RegaHt2JQfFS65Jxq5N6kceZrorf1LnKuRdPlBC4jQS\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773890243828}', 1, '', NULL, 73);
INSERT INTO `sys_oper_log` VALUES (96, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxMzM3NCwiZXhwIjoxNzczOTIwNTc0fQ.NWoMMH99KRcX_9p5XXIff8b_xAXvdcUh3sD1JRLZuQ2Rn_xi2rQ_tg2WLGgVsd2_\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773913374336}', 1, '', NULL, 508);
INSERT INTO `sys_oper_log` VALUES (97, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxMzcxNSwiZXhwIjoxNzczOTIwOTE1fQ.avOWe59gAVAZaqHGByd1Qs-OCj0oln-rgnHM81KMPEu3hzcuYZT_vLIeOUsywPaQ\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773913715263}', 1, '', NULL, 83);
INSERT INTO `sys_oper_log` VALUES (98, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxMzk0NCwiZXhwIjoxNzczOTIxMTQ0fQ.kfrqMyCokzltWM-Mvn2XcfNvNY-lV_iHV-erunkFSSF4qBDfVdV12gB3LRMVAOSF\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773913944230}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (99, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773913944727}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (100, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxMzk0NiwiZXhwIjoxNzczOTIxMTQ2fQ.U16QHsBqh9W3oTk4WkEoN0d_R6MyRFeHI3_cVN54SZKBLbe5Sy8PHnMtiKvhWx8p\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773913946996}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (101, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773913961117}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (102, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin1233\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773913964508}', 1, '', NULL, 84);
INSERT INTO `sys_oper_log` VALUES (103, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxMzk2OSwiZXhwIjoxNzczOTIxMTY5fQ.uagBS_zcSFrAEkQFEwBtNSZdzs_jQwwgm5fdiFEhTYFwoWTuosDTnjbAqySK-q5p\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773913969020}', 1, '', NULL, 78);
INSERT INTO `sys_oper_log` VALUES (104, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxNDE5MSwiZXhwIjoxNzczOTIxMzkxfQ.m0TUDSs-9sxPcPWRNiCVjjr6y_KWBmIZdClX3YtC6LbAtrdU8HkeK8B08i8bK7nz\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773914191419}', 1, '', NULL, 81);
INSERT INTO `sys_oper_log` VALUES (105, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 37);
INSERT INTO `sys_oper_log` VALUES (106, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773914493871}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (107, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (108, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (109, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (110, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (111, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 39);
INSERT INTO `sys_oper_log` VALUES (112, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 43);
INSERT INTO `sys_oper_log` VALUES (113, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '', 0, 'Invalid bound statement (not found): com.autoadmin.modules.auth.service.AuthService.login', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (114, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxNDc1OCwiZXhwIjoxNzczOTIxOTU4fQ.zscZuQPVm2wg4zw1oQil4qiQ2cAk9Cg2xmq4Z8vVKBJfjrEZvM0fQ0GVjE5kSttN\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773914758361}', 1, '', NULL, 338);
INSERT INTO `sys_oper_log` VALUES (115, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3MzkxNDc2MiwiZXhwIjoxNzczOTIxOTYyfQ.O_-fLvy_0MKIxnFzY0ZqoldQ_6oLAP3SOjANQKZfKwCF1xxWVrj8aXOCudJRr50X\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773914762914}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (116, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773966878153}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (117, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk2Njg3OSwiZXhwIjoxNzczOTc0MDc5fQ.Uez65Nh8jQcW8nx6jDEBShkjModDgCYFlXR7eX4uwZP7_-ovsmN75x0mneforHFC\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773966879678}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (118, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk2NzU3OSwiZXhwIjoxNzczOTc0Nzc5fQ.bO2F5vYAFcgA-sN4KGR2xLHYSawA8NSoIhEVnnwHgogApp8AWN1suQjol_Z3UqJD\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773967579696}', 1, '', NULL, 357);
INSERT INTO `sys_oper_log` VALUES (119, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk2NzU5NSwiZXhwIjoxNzczOTc0Nzk1fQ.23sgheJ3hkDYH64Dz9vOVq8PHSuKPHOu0CXGCqu9XZZxn9aU_6fweKF_TBZWHOW5\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773967595721}', 1, '', NULL, 79);
INSERT INTO `sys_oper_log` VALUES (120, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773974308349}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (121, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3NDMwOSwiZXhwIjoxNzczOTgxNTA5fQ.Axl6dWxxNBovz-YyB29goSMwGD7-Sla61BDm_MSpfJILdk16JNTVD2oG-lN_tTbQ\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773974309689}', 1, '', NULL, 81);
INSERT INTO `sys_oper_log` VALUES (122, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773976047182}', 1, '', NULL, 5);
INSERT INTO `sys_oper_log` VALUES (123, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3NjA0OSwiZXhwIjoxNzczOTgzMjQ5fQ.23rvBp2d5nQuyc41d3-tot618izzmTAfwti4SKHyFUuoT8lGii5N-Q7IrifPSlW2\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773976049549}', 1, '', NULL, 101);
INSERT INTO `sys_oper_log` VALUES (124, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773976899926}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (125, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3NjkwMSwiZXhwIjoxNzczOTg0MTAxfQ.SEjzAA9Yqts6b3zem5dZuQ6kXq11aEGHlraGGPu_w1AYpDAjCnbe41u-HP5wy3BW\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773976901037}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (126, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773977890763}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (127, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3Nzg5MiwiZXhwIjoxNzczOTg1MDkyfQ.P3smwTmbRNxNUpFGdIwbIO67lzZrYOAoyd8k2SG6AOFsGFQw-UZwdqX-jlHGa4jP\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773977892781}', 1, '', NULL, 80);
INSERT INTO `sys_oper_log` VALUES (128, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773978114247}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (129, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3ODE0NiwiZXhwIjoxNzczOTg1MzQ2fQ.64mWOOYk5_JfYW8NjU7gCTDgXJRq4KGN5LNI8J9WbkvARvyT9vzLAzE7Ngp6Vryb\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773978146682}', 1, '', NULL, 72);
INSERT INTO `sys_oper_log` VALUES (130, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773978296312}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (131, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3ODI5NywiZXhwIjoxNzczOTg1NDk3fQ.TPlKU_V_3NwC_QZs3CjBNDkyXVQHYdgHXThPBnCbyrO-bFucGNEn7dEH-vfRC-PW\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773978297347}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (132, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773978302383}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (133, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3ODMwNSwiZXhwIjoxNzczOTg1NTA1fQ.UJUJJcS8i6jS2SA-I4kXIrBzGFyGLL_ebrDhQk0DoN9AgqCn9og6p--UooFzWef6\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773978305503}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (134, '用户管理', 7, 'com.autoadmin.modules.system.controller.UserController.assignRoles()', 'PUT', '', '0:0:0:0:0:0:0:1', '', '', '/user/assignRoles', '{};[2];', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773978486235}', 1, '', NULL, 3);
INSERT INTO `sys_oper_log` VALUES (135, '用户管理', 7, 'com.autoadmin.modules.system.controller.UserController.assignRoles()', 'PUT', '', '0:0:0:0:0:0:0:1', '', '', '/user/assignRoles', '{};[2];', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773978557884}', 1, '', NULL, 2);
INSERT INTO `sys_oper_log` VALUES (136, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3ODk1MiwiZXhwIjoxNzczOTg2MTUyfQ.aoVF48rRae_bzg-IwLxhFg_hD_UFpWWnik1nTZ7eOXZ-bmA7X5b3YpkIc2ssljzB\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773978952990}', 1, '', NULL, 381);
INSERT INTO `sys_oper_log` VALUES (137, '用户管理', 7, 'com.autoadmin.modules.system.controller.UserController.assignRoles()', 'PUT', '', '0:0:0:0:0:0:0:1', '', '', '/user/assignRoles', '{};[2];', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773978975469}', 1, '', NULL, 28);
INSERT INTO `sys_oper_log` VALUES (138, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773979028508}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (139, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk3OTAzNCwiZXhwIjoxNzczOTg2MjM0fQ.Os1KfAFtfeHdwERuxyf1CTzet8L4ffp02ytNW8kR-3NdaKDDyNgCXDuRzjIQun8U\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773979034653}', 1, '', NULL, 77);
INSERT INTO `sys_oper_log` VALUES (140, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk3OTA0MiwiZXhwIjoxNzczOTg2MjQyfQ.nwpNDQ7pV-3L-z15MOTuadfsqLEMd660WEVQcg6mTA4ivAvqukWZDcyuqra9Re1b\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773979042653}', 1, '', NULL, 70);
INSERT INTO `sys_oper_log` VALUES (141, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773979067656}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (142, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3OTA2OCwiZXhwIjoxNzczOTg2MjY4fQ.MFv-a5Vo_lENF4gmLoSorOwuR5Pyw2eM4grCYRgGO92bIp_YUDCQMNNIoAbjd-0S\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773979068486}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (143, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773979135237}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (144, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin12311\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773979136996}', 1, '', NULL, 81);
INSERT INTO `sys_oper_log` VALUES (145, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3OTI2MiwiZXhwIjoxNzczOTg2NDYyfQ.dMAejrbhgQ4HonZyct5yFMSUAJ2sE-I3LGwH4DyNg3tdva7mwamG18kzabXI3nXS\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773979262681}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (146, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773979313099}', 1, '', NULL, 1);
INSERT INTO `sys_oper_log` VALUES (147, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk3OTMxNSwiZXhwIjoxNzczOTg2NTE1fQ.NlpGD0aN6tSJsioUGEtB714xQUqHUPD6ipKTQZ2s3c6znl8Xci4sRcSwhLtxSOzz\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773979315120}', 1, '', NULL, 80);
INSERT INTO `sys_oper_log` VALUES (148, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773982678187}', 1, '', NULL, 8);
INSERT INTO `sys_oper_log` VALUES (149, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk4MjY3OSwiZXhwIjoxNzczOTg5ODc5fQ.nyxxtUYgaT-z8f6OExJ49O9aq7nWd0aopfLyZPMHPEIjDc3ob20HKkuSTm26nHtD\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773982679289}', 1, '', NULL, 89);
INSERT INTO `sys_oper_log` VALUES (150, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773982783015}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (151, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk4Mjc4OCwiZXhwIjoxNzczOTg5OTg4fQ.wrTkNI60e2s8oIOw5Q3nidEeFBuz8SSG9kL6r85cPt-XmS-njbuniy-fVqBHPIrz\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773982788638}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (152, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk4Mjg4MSwiZXhwIjoxNzczOTkwMDgxfQ.7NdWLOfcvubYJ9wsI6j8FhADH1AkYqn0vs7arJQNC5LHf5AJwd7WB4drQWYVGBrM\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773982881235}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (153, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773982900363}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (154, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk4MjkwMSwiZXhwIjoxNzczOTkwMTAxfQ.J9R7PWEeOYMLrYol01SAYbW6IrqpejhR2ed4QwbrD2r99BT-N_f6MgnccIRHLryZ\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773982901216}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (155, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773985772655}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (156, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123333\"};', '{\"code\":500,\"message\":\"用户名或密码错误\",\"timestamp\":1773985783375}', 1, '', NULL, 75);
INSERT INTO `sys_oper_log` VALUES (157, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk4NTc4OCwiZXhwIjoxNzczOTkyOTg4fQ.6gjGOf0GosEVZO_QEE4NMa95OPzWv-AP3g_IXeMzsgYgTDGxXYx135Pp0AbPpFdf\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773985788246}', 1, '', NULL, 82);
INSERT INTO `sys_oper_log` VALUES (158, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk4NTc5MywiZXhwIjoxNzczOTkyOTkzfQ.WX8x-Y4H7UZDcQo7ybudPcZLsyt2-xOE6gDMOa9UR09oQ93YNS5ddjwhSaqkNkQ0\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773985793907}', 1, '', NULL, 74);
INSERT INTO `sys_oper_log` VALUES (159, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773985841331}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (160, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3Mzk4NTg0MiwiZXhwIjoxNzczOTkzMDQyfQ.bkKALEeiFIgan3r70Rah0_SZME7Bzja-yncUL980P9R6360U-iXqG89DX0K4gY0Q\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1773985842080}', 1, '', NULL, 70);
INSERT INTO `sys_oper_log` VALUES (161, '角色管理', 7, 'com.autoadmin.modules.system.controller.RoleController.assignMenus()', 'PUT', '', '0:0:0:0:0:0:0:1', '', '', '/role/assignMenus', '{\"roleId\":2,\"menuIds\":[22,23,35]};', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773988782317}', 1, '', NULL, 81);
INSERT INTO `sys_oper_log` VALUES (162, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1773988863890}', 1, '', NULL, 0);
INSERT INTO `sys_oper_log` VALUES (163, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk4ODg2OSwiZXhwIjoxNzczOTk2MDY5fQ.W56wHZiYOERF7gJbU2dNa_mjqvz_11jPQLJfhcqapEWz9ZceBnU0w5P2DIGP-llA\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773988869077}', 1, '', NULL, 106);
INSERT INTO `sys_oper_log` VALUES (164, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"zhangsan\",\"password\":\"123456\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjIsInVzZXJuYW1lIjoiemhhbmdzYW4iLCJzdWIiOiJ6aGFuZ3NhbiIsImlhdCI6MTc3Mzk4ODg3NCwiZXhwIjoxNzczOTk2MDc0fQ.S3gcGBx0KuNXYbWKLGDOIk9zOyfJCGYoAKr9OhVf5jlQLIJ7CPeOW5q9SQ4_uMlB\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":2,\"username\":\"zhangsan\",\"nickname\":\"张三\",\"avatar\":\"\"},\"timestamp\":1773988874977}', 1, '', NULL, 76);
INSERT INTO `sys_oper_log` VALUES (165, '用户登出', 9, 'com.autoadmin.modules.auth.controller.AuthController.logout()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/logout', '', '{\"code\":200,\"message\":\"success\",\"timestamp\":1774314398432}', 1, '', NULL, 6);
INSERT INTO `sys_oper_log` VALUES (166, '用户登录', 8, 'com.autoadmin.modules.auth.controller.AuthController.login()', 'POST', '', '0:0:0:0:0:0:0:1', '', '', '/auth/login', '{\"username\":\"admin\",\"password\":\"admin123\"};', '{\"code\":200,\"message\":\"success\",\"data\":{\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiYWRtaW4iLCJzdWIiOiJhZG1pbiIsImlhdCI6MTc3NDMxNDQwMywiZXhwIjoxNzc0MzIxNjAzfQ.6TKACjl0R4rpj_wIo_z8mdirf3FjCuQWXPCa_KIT2_eL3X5v4C-D17jB2618fTwT\",\"tokenType\":\"Bearer\",\"expiresIn\":7200,\"userId\":1,\"username\":\"admin\",\"nickname\":\"管理员\",\"avatar\":\"\"},\"timestamp\":1774314404011}', 1, '', NULL, 133);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'super_admin', 1, 1, '2026-03-18 12:03:48', '2026-03-18 12:03:48', 0);
INSERT INTO `sys_role` VALUES (2, '普通用户', 'common_user', 2, 1, '2026-03-18 12:03:48', '2026-03-18 12:03:48', 0);

-- ----------------------------
-- Table structure for sys_role_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_api`;
CREATE TABLE `sys_role_api`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `role_id` bigint NOT NULL COMMENT '角色 ID',
  `api_id` bigint NOT NULL COMMENT '接口 ID',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` tinyint NULL DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_api`(`role_id` ASC, `api_id` ASC) USING BTREE,
  INDEX `idx_api_id`(`api_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色接口关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_api
-- ----------------------------
INSERT INTO `sys_role_api` VALUES (1, 1, 1, '', '2026-03-18 15:48:33', 0);
INSERT INTO `sys_role_api` VALUES (2, 1, 2, '', '2026-03-18 15:48:33', 0);
INSERT INTO `sys_role_api` VALUES (3, 1, 3, '', '2026-03-18 15:48:33', 0);
INSERT INTO `sys_role_api` VALUES (4, 1, 4, '', '2026-03-18 15:48:33', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '角色菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (1, 2, 22, '2026-03-20 14:39:42', 0);
INSERT INTO `sys_role_menu` VALUES (2, 2, 23, '2026-03-20 14:39:42', 0);
INSERT INTO `sys_role_menu` VALUES (3, 2, 35, '2026-03-20 14:39:42', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, 1, '2026-03-18 12:03:48');
INSERT INTO `sys_user_role` VALUES (2, 2, 2, '2026-03-20 11:56:15');

SET FOREIGN_KEY_CHECKS = 1;
