-- ============================================
-- Auto Admin 管理后台 - 初始化数据
-- ============================================

USE `auto_admin`;

-- --------------------------------------------
-- 1. 初始化用户 (admin/admin123 BCrypt 加密)
-- --------------------------------------------
-- 密码 admin123 的 BCrypt 哈希 (使用 BCrypt 生成)
-- 可以使用 PasswordUtils.main() 方法生成新的密码
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `sex`, `status`) VALUES
(1, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '管理员', 'admin@example.com', 0, 1);

-- --------------------------------------------
-- 2. 初始化角色
-- --------------------------------------------
INSERT INTO `sys_role` (`id`, `name`, `code`, `sort`, `status`) VALUES
(1, '超级管理员', 'super_admin', 1, 1),
(2, '普通用户', 'common_user', 2, 1);

-- --------------------------------------------
-- 3. 初始化菜单
-- --------------------------------------------

-- === 系统管理 (目录) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(1, 0, '系统管理', 1, '/system', 'Layout', 'Setting', 1, 1, 1);

-- --- 用户管理 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(2, 1, '用户管理', 2, '/system/user', 'system/user/index', 'User', 1, 1, 1);

-- 用户管理 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(3, 2, '新增用户', 3, 'user:add', 1, 1, 1),
(4, 2, '编辑用户', 3, 'user:edit', 2, 1, 1),
(5, 2, '删除用户', 3, 'user:delete', 3, 1, 1),
(6, 2, '重置密码', 3, 'user:resetPwd', 4, 1, 1),
(30, 2, '查看用户', 3, 'user:query', 5, 1, 1);

-- --- 角色管理 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(7, 1, '角色管理', 2, '/system/role', 'system/role/index', 'Peoples', 2, 1, 1);

-- 角色管理 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(8, 7, '新增角色', 3, 'role:add', 1, 1, 1),
(9, 7, '编辑角色', 3, 'role:edit', 2, 1, 1),
(10, 7, '删除角色', 3, 'role:delete', 3, 1, 1),
(11, 7, '分配权限', 3, 'role:assign', 4, 1, 1),
(31, 7, '查看角色', 3, 'role:query', 5, 1, 1);

-- --- 菜单管理 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(12, 1, '菜单管理', 2, '/system/menu', 'system/menu/index', 'Menu', 3, 1, 1);

-- 菜单管理 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(13, 12, '新增菜单', 3, 'menu:add', 1, 1, 1),
(14, 12, '编辑菜单', 3, 'menu:edit', 2, 1, 1),
(15, 12, '删除菜单', 3, 'menu:delete', 3, 1, 1),
(32, 12, '查看菜单', 3, 'menu:query', 4, 1, 1);

-- --- API 管理 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(40, 1, 'API 管理', 2, '/system/api', 'system/api/index', 'Connection', 4, 1, 1);

-- API 管理 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(41, 40, '新增接口', 3, 'api:add', 1, 1, 1),
(42, 40, '编辑接口', 3, 'api:edit', 2, 1, 1),
(43, 40, '删除接口', 3, 'api:delete', 3, 1, 1),
(44, 40, '查看接口', 3, 'api:query', 4, 1, 1);

-- --- 字典管理 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(16, 1, '字典管理', 2, '/system/dict', 'system/dict/index', 'Collection', 5, 1, 1);

-- 字典管理 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(17, 16, '新增字典', 3, 'dict:add', 1, 1, 1),
(18, 16, '编辑字典', 3, 'dict:edit', 2, 1, 1),
(19, 16, '删除字典', 3, 'dict:delete', 3, 1, 1),
(33, 16, '查看字典', 3, 'dict:query', 4, 1, 1),
(34, 16, '查询字典数据', 3, 'dict:data:list', 5, 1, 1);

-- --- 登录日志 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(20, 1, '登录日志', 2, '/system/loginlog', 'system/loginlog/index', 'Document', 6, 1, 1);

-- 登录日志 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(24, 20, '查看日志', 3, 'loginlog:query', 1, 1, 1),
(25, 20, '删除日志', 3, 'loginlog:delete', 2, 1, 1),
(26, 20, '清空日志', 3, 'loginlog:clear', 3, 1, 1);

-- --- 操作日志 (菜单) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(21, 1, '操作日志', 2, '/system/operlog', 'system/operlog/index', 'List', 7, 1, 1);

-- 操作日志 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(27, 21, '查看日志', 3, 'operlog:query', 1, 1, 1),
(28, 21, '删除日志', 3, 'operlog:delete', 2, 1, 1),
(29, 21, '清空日志', 3, 'operlog:clear', 3, 1, 1);

-- --- 个人中心 (菜单，隐藏) ===
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `path`, `component`, `icon`, `sort`, `visible`, `status`) VALUES
(22, 0, '个人中心', 2, '/profile', 'profile/index', 'User', 0, 0, 1);

-- 个人中心 - 按钮
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `type`, `permission`, `sort`, `visible`, `status`) VALUES
(23, 22, '修改密码', 3, 'profile:resetPwd', 1, 1, 1),
(35, 22, '获取个人信息', 3, 'profile:get', 2, 1, 1);

-- --------------------------------------------
-- 4. 初始化接口资源 (sys_api)
-- --------------------------------------------

-- 登录相关接口（不需要关联菜单，公开访问）
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(1, '/auth/login', 'POST', '登录', NULL, 1),
(2, '/auth/logout', 'POST', '登出', NULL, 1),
(3, '/auth/userInfo', 'GET', '获取用户信息', NULL, 1),
(4, '/auth/userMenus', 'GET', '获取用户菜单', NULL, 1);

-- 用户管理接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(10, '/user/page', 'GET', '用户分页查询', 30, 1),
(11, '/user', 'POST', '新增用户', 3, 1),
(12, '/user/*', 'PUT', '编辑用户', 4, 1),
(13, '/user/*', 'DELETE', '删除用户', 5, 1),
(14, '/user/resetPwd', 'PUT', '重置密码', 6, 1);

-- 角色管理接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(20, '/role/list', 'GET', '角色列表', 31, 1),
(21, '/role', 'POST', '新增角色', 8, 1),
(22, '/role', 'PUT', '编辑角色', 9, 1),
(23, '/role/*', 'DELETE', '删除角色', 10, 1),
(24, '/role/assignMenus', 'PUT', '分配菜单权限', 11, 1),
(25, '/role/menuIds/*', 'GET', '获取角色菜单', 11, 1);

-- 菜单管理接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(30, '/menu/tree', 'GET', '菜单树', 32, 1),
(31, '/menu', 'POST', '新增菜单', 13, 1),
(32, '/menu', 'PUT', '编辑菜单', 14, 1),
(33, '/menu/*', 'DELETE', '删除菜单', 15, 1);

-- API 管理接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(40, '/api/page', 'GET', '接口分页查询', 44, 1),
(41, '/api', 'POST', '新增接口', 41, 1),
(42, '/api', 'PUT', '编辑接口', 42, 1),
(43, '/api/*', 'DELETE', '删除接口', 43, 1);

-- 字典管理接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(50, '/dict/type/list', 'GET', '字典类型列表', 33, 1),
(51, '/dict/data/list', 'GET', '字典数据列表', 34, 1),
(52, '/dict/type', 'POST', '新增字典类型', 17, 1),
(53, '/dict/type', 'PUT', '编辑字典类型', 18, 1),
(54, '/dict/type/*', 'DELETE', '删除字典类型', 19, 1);

-- 登录日志接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(60, '/loginlog/page', 'GET', '登录日志分页', 24, 1),
(61, '/loginlog/*', 'DELETE', '删除登录日志', 25, 1),
(62, '/loginlog/clear', 'DELETE', '清空登录日志', 26, 1);

-- 操作日志接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(70, '/operlog/page', 'GET', '操作日志分页', 27, 1),
(71, '/operlog/*', 'DELETE', '删除操作日志', 28, 1),
(72, '/operlog/clear', 'DELETE', '清空操作日志', 29, 1);

-- 个人中心接口
INSERT INTO `sys_api` (`id`, `path`, `method`, `name`, `menu_id`, `status`) VALUES
(80, '/profile', 'GET', '获取个人信息', 35, 1),
(81, '/profile/password', 'PUT', '修改密码', 23, 1);

-- --------------------------------------------
-- 5. 初始化用户 - 角色关联 (admin -> 超级管理员)
-- --------------------------------------------
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1);

-- --------------------------------------------
-- 6. 初始化角色 - 菜单关联 (超级管理员拥有所有权限)
-- --------------------------------------------
-- 将所有菜单分配给超级管理员角色
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`)
SELECT 1, id FROM `sys_menu`;

-- --------------------------------------------
-- 7. 初始化字典数据
-- --------------------------------------------
-- 用户性别字典
INSERT INTO `sys_dict_type` (`id`, `name`, `type`, `status`, `remark`) VALUES
(1, '用户性别', 'sys_user_sex', 1, '用户性别列表');

INSERT INTO `sys_dict_data` (`dict_type`, `label`, `value`, `sort`, `status`, `is_default`) VALUES
('sys_user_sex', '未知', '0', 1, 1, 1),
('sys_user_sex', '男', '1', 2, 1, 0),
('sys_user_sex', '女', '2', 3, 1, 0);

-- 系统开关字典
INSERT INTO `sys_dict_type` (`id`, `name`, `type`, `status`, `remark`) VALUES
(2, '系统开关', 'sys_common_status', 1, '系统开关列表');

INSERT INTO `sys_dict_data` (`dict_type`, `label`, `value`, `sort`, `status`, `is_default`) VALUES
('sys_common_status', '关闭', '0', 1, 1, 0),
('sys_common_status', '开启', '1', 2, 1, 1);

-- 菜单类型字典
INSERT INTO `sys_dict_type` (`id`, `name`, `type`, `status`, `remark`) VALUES
(3, '菜单类型', 'sys_menu_type', 1, '菜单类型列表');

INSERT INTO `sys_dict_data` (`dict_type`, `label`, `value`, `sort`, `status`, `is_default`, `css_class`, `list_class`) VALUES
('sys_menu_type', '目录', '1', 1, 1, 0, '', 'tag-blue'),
('sys_menu_type', '菜单', '2', 2, 1, 0, '', 'tag-green'),
('sys_menu_type', '按钮', '3', 3, 1, 0, '', 'tag-orange');