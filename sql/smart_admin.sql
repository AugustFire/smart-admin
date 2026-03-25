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
) ENGINE = InnoDB AUTO_INCREMENT = 82 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '接口资源表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_api
-- ----------------------------
-- 公开接口（is_public=1）：无需权限即可访问
INSERT INTO `sys_api` VALUES (1, '/auth/login', 'POST', '登录', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (2, '/auth/logout', 'POST', '登出', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (3, '/auth/userInfo', 'GET', '获取用户信息', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
INSERT INTO `sys_api` VALUES (4, '/auth/userMenus', 'GET', '获取用户菜单', 1, 1, NULL, '', '2026-03-20 14:17:34', '', '2026-03-20 14:17:34', 0);
-- 业务接口（is_public=0）：需要权限验证
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
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, 0, '系统管理', 1, '/system', 'Layout', '', 'Setting', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (2, 1, '用户管理', 2, '/system/user', 'system/user/index', '', 'User', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (3, 2, '新增用户', 3, '', '', 'user:add', '', 1, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (4, 2, '编辑用户', 3, '', '', 'user:edit', '', 2, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (5, 2, '删除用户', 3, '', '', 'user:delete', '', 3, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (6, 2, '重置密码', 3, '', '', 'user:resetPwd', '', 4, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
INSERT INTO `sys_menu` VALUES (44, 2, '分配角色', 3, '', '', 'user:assignRole', '', 5, 1, 1, '2026-03-20 14:16:19', '2026-03-20 14:16:19');
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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '菜单接口关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu_api
-- ----------------------------
-- 用户管理菜单(id=2)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (1, 2, 10, NOW());   -- 用户管理菜单 -> 用户列表查询
INSERT INTO `sys_menu_api` VALUES (2, 3, 11, NOW());   -- 新增用户按钮 -> 新增用户接口
INSERT INTO `sys_menu_api` VALUES (3, 4, 12, NOW());   -- 编辑用户按钮 -> 编辑用户接口
INSERT INTO `sys_menu_api` VALUES (4, 5, 13, NOW());   -- 删除用户按钮 -> 删除用户接口
INSERT INTO `sys_menu_api` VALUES (5, 6, 14, NOW());   -- 重置密码按钮 -> 重置密码接口
INSERT INTO `sys_menu_api` VALUES (33, 44, 15, NOW()); -- 分配角色按钮 -> 分配用户角色接口
INSERT INTO `sys_menu_api` VALUES (34, 44, 16, NOW()); -- 分配角色按钮 -> 获取用户角色接口
-- 角色管理菜单(id=7)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (6, 7, 20, NOW());   -- 角色管理菜单 -> 角色列表接口
INSERT INTO `sys_menu_api` VALUES (7, 8, 21, NOW());   -- 新增角色按钮 -> 新增角色接口
INSERT INTO `sys_menu_api` VALUES (8, 9, 22, NOW());   -- 编辑角色按钮 -> 编辑角色接口
INSERT INTO `sys_menu_api` VALUES (9, 10, 23, NOW());  -- 删除角色按钮 -> 删除角色接口
INSERT INTO `sys_menu_api` VALUES (10, 11, 24, NOW()); -- 分配权限按钮 -> 分配菜单权限接口
INSERT INTO `sys_menu_api` VALUES (11, 11, 25, NOW()); -- 分配权限按钮 -> 获取角色菜单接口
-- 菜单管理菜单(id=12)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (12, 12, 30, NOW()); -- 菜单管理菜单 -> 菜单树接口
INSERT INTO `sys_menu_api` VALUES (13, 13, 31, NOW()); -- 新增菜单按钮 -> 新增菜单接口
INSERT INTO `sys_menu_api` VALUES (14, 14, 32, NOW()); -- 编辑菜单按钮 -> 编辑菜单接口
INSERT INTO `sys_menu_api` VALUES (15, 15, 33, NOW()); -- 删除菜单按钮 -> 删除菜单接口
-- API管理菜单(id=40)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (16, 40, 40, NOW()); -- API管理菜单 -> 接口列表接口
INSERT INTO `sys_menu_api` VALUES (17, 41, 41, NOW()); -- 新增接口按钮 -> 新增接口接口
INSERT INTO `sys_menu_api` VALUES (18, 42, 42, NOW()); -- 编辑接口按钮 -> 编辑接口接口
INSERT INTO `sys_menu_api` VALUES (19, 43, 43, NOW()); -- 删除接口按钮 -> 删除接口接口
-- 字典管理菜单(id=16)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (20, 16, 50, NOW()); -- 字典管理菜单 -> 字典类型列表
INSERT INTO `sys_menu_api` VALUES (21, 16, 51, NOW()); -- 字典管理菜单 -> 字典数据列表
INSERT INTO `sys_menu_api` VALUES (22, 17, 52, NOW()); -- 新增字典按钮 -> 新增字典类型接口
INSERT INTO `sys_menu_api` VALUES (23, 18, 53, NOW()); -- 编辑字典按钮 -> 编辑字典类型接口
INSERT INTO `sys_menu_api` VALUES (24, 19, 54, NOW()); -- 删除字典按钮 -> 删除字典类型接口
-- 登录日志菜单(id=20)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (25, 20, 60, NOW()); -- 登录日志菜单 -> 登录日志分页接口
INSERT INTO `sys_menu_api` VALUES (26, 25, 61, NOW()); -- 删除日志按钮 -> 删除登录日志接口
INSERT INTO `sys_menu_api` VALUES (27, 26, 62, NOW()); -- 清空日志按钮 -> 清空登录日志接口
-- 操作日志菜单(id=21)绑定查询接口，按钮绑定操作接口
INSERT INTO `sys_menu_api` VALUES (28, 21, 70, NOW()); -- 操作日志菜单 -> 操作日志分页接口
INSERT INTO `sys_menu_api` VALUES (29, 28, 71, NOW()); -- 删除日志按钮 -> 删除操作日志接口
INSERT INTO `sys_menu_api` VALUES (30, 29, 72, NOW()); -- 清空日志按钮 -> 清空操作日志接口
-- 个人中心菜单(id=22)绑定接口
INSERT INTO `sys_menu_api` VALUES (31, 22, 80, NOW()); -- 个人中心菜单 -> 获取个人信息接口
INSERT INTO `sys_menu_api` VALUES (32, 23, 81, NOW()); -- 修改密码按钮 -> 修改密码接口

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
