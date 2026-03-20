-- ============================================
-- Auto Admin 管理后台 - 数据库表结构
-- Database: auto_admin
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `auto_admin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE `auto_admin`;

-- --------------------------------------------
-- 1. 用户表 sys_user
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户 ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码 (BCrypt 加密)',
  `nickname` VARCHAR(50) DEFAULT '' COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT '' COMMENT '头像 URL',
  `email` VARCHAR(100) DEFAULT '' COMMENT '邮箱',
  `phone` VARCHAR(20) DEFAULT '' COMMENT '手机号',
  `sex` TINYINT DEFAULT 0 COMMENT '性别 0=未知 1=男 2=女',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户表';

-- --------------------------------------------
-- 2. 角色表 sys_role
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色 ID',
  `name` VARCHAR(50) NOT NULL COMMENT '角色名称',
  `code` VARCHAR(50) NOT NULL COMMENT '角色编码',
  `sort` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT DEFAULT 0 COMMENT '删除标志 0=未删除 1=已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色表';

-- --------------------------------------------
-- 3. 菜单表 sys_menu (目录、菜单页面、按钮、接口)
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '菜单 ID',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单 ID 0=顶级',
  `name` VARCHAR(50) NOT NULL COMMENT '菜单名称',
  `type` TINYINT NOT NULL COMMENT '类型：1=目录，2=菜单，3=按钮',
  `path` VARCHAR(255) DEFAULT '' COMMENT '路由路径',
  `component` VARCHAR(255) DEFAULT '' COMMENT '组件路径',
  `permission` VARCHAR(100) DEFAULT '' COMMENT '权限标识 (如 user:add)',
  `icon` VARCHAR(100) DEFAULT '' COMMENT '图标',
  `sort` INT DEFAULT 0 COMMENT '排序',
  `visible` TINYINT DEFAULT 1 COMMENT '是否可见 0=隐藏 1=显示',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='菜单表';

-- --------------------------------------------
-- 4. 接口资源表 sys_api
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_api`;
CREATE TABLE `sys_api` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `path` VARCHAR(255) NOT NULL COMMENT '接口路径',
  `method` VARCHAR(10) NOT NULL DEFAULT 'GET' COMMENT '请求方法',
  `name` VARCHAR(100) DEFAULT NULL COMMENT '接口名称',
  `menu_id` BIGINT DEFAULT NULL COMMENT '关联的菜单 ID',
  `status` TINYINT DEFAULT 1 COMMENT '状态：1=启用，0=禁用',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `creator` VARCHAR(64) DEFAULT '' COMMENT '创建人',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updater` VARCHAR(64) DEFAULT '' COMMENT '更新人',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` TINYINT DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除',
  PRIMARY KEY (`id`),
  KEY `idx_path` (`path`(100)),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='接口资源表';

-- --------------------------------------------
-- 5. 用户 - 角色关联表 sys_user_role
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` BIGINT NOT NULL COMMENT '用户 ID',
  `role_id` BIGINT NOT NULL COMMENT '角色 ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户角色关联表';

-- --------------------------------------------
-- 6. 角色 - 菜单关联表 sys_role_menu
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `role_id` BIGINT NOT NULL COMMENT '角色 ID',
  `menu_id` BIGINT NOT NULL COMMENT '菜单 ID',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` TINYINT DEFAULT 0 COMMENT '删除标志：0=未删除，1=已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`),
  KEY `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='角色菜单关联表';

-- --------------------------------------------
-- 7. 登录日志表 sys_login_log
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `user_id` BIGINT DEFAULT NULL COMMENT '用户 ID',
  `username` VARCHAR(50) DEFAULT '' COMMENT '用户名',
  `login_status` TINYINT DEFAULT 1 COMMENT '登录状态 0=失败 1=成功',
  `ip` VARCHAR(50) DEFAULT '' COMMENT '登录 IP',
  `address` VARCHAR(255) DEFAULT '' COMMENT '登录地点',
  `browser` VARCHAR(100) DEFAULT '' COMMENT '浏览器',
  `os` VARCHAR(100) DEFAULT '' COMMENT '操作系统',
  `msg` VARCHAR(500) DEFAULT '' COMMENT '提示信息',
  `login_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_login_time` (`login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='登录日志表';

-- --------------------------------------------
-- 8. 操作日志表 sys_oper_log
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键 ID',
  `title` VARCHAR(50) DEFAULT '' COMMENT '模块标题',
  `business_type` TINYINT DEFAULT 0 COMMENT '业务类型 0=其它 1=新增 2=修改 3=删除',
  `method` VARCHAR(255) DEFAULT '' COMMENT '方法名称',
  `request_method` VARCHAR(10) DEFAULT '' COMMENT '请求方式',
  `oper_name` VARCHAR(50) DEFAULT '' COMMENT '操作人员',
  `oper_ip` VARCHAR(50) DEFAULT '' COMMENT '主机地址',
  `oper_location` VARCHAR(255) DEFAULT '' COMMENT '操作地点',
  `dept_name` VARCHAR(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` VARCHAR(255) DEFAULT '' COMMENT '请求 URL',
  `oper_param` VARCHAR(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` VARCHAR(2000) DEFAULT '' COMMENT '返回参数',
  `status` TINYINT DEFAULT 1 COMMENT '操作状态 0=失败 1=成功',
  `error_msg` VARCHAR(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `cost_time` BIGINT DEFAULT 0 COMMENT '消耗时间 (毫秒)',
  PRIMARY KEY (`id`),
  KEY `idx_oper_time` (`oper_time`),
  KEY `idx_business_type` (`business_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='操作日志表';

-- --------------------------------------------
-- 9. 字典类型表 sys_dict_type
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `name` VARCHAR(100) DEFAULT '' COMMENT '字典名称',
  `type` VARCHAR(100) NOT NULL COMMENT '字典类型',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典类型表';

-- --------------------------------------------
-- 10. 字典数据表 sys_dict_data
-- --------------------------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_type` VARCHAR(100) DEFAULT '' COMMENT '字典类型',
  `label` VARCHAR(100) DEFAULT '' COMMENT '字典标签',
  `value` VARCHAR(100) DEFAULT '' COMMENT '字典键值',
  `sort` INT DEFAULT 0 COMMENT '排序',
  `status` TINYINT DEFAULT 1 COMMENT '状态 0=禁用 1=正常',
  `css_class` VARCHAR(100) DEFAULT '' COMMENT '样式属性',
  `list_class` VARCHAR(100) DEFAULT '' COMMENT '表格回显样式',
  `is_default` TINYINT DEFAULT 0 COMMENT '是否默认 0=否 1=是',
  `remark` VARCHAR(500) DEFAULT '' COMMENT '备注',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_dict_type` (`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='字典数据表';
