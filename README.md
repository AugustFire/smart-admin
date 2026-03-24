# Smart Admin

<p align="center">
  <img src="https://img.shields.io/badge/Spring%20Boot-3.2.3-brightgreen?logo=springboot" alt="Spring Boot">
  <img src="https://img.shields.io/badge/Vue-3.4-4FC08D?logo=vue.js" alt="Vue">
  <img src="https://img.shields.io/badge/Element%20Plus-2.6-409EFF?logo=element" alt="Element Plus">
  <img src="https://img.shields.io/badge/TypeScript-5.4-3178C6?logo=typescript" alt="TypeScript">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="License">
</p>

<p align="center">
  <b>基于 Vue 3 + Spring Boot 3.x 的现代化管理后台模板</b>
</p>

<p align="center">
  开箱即用 · 权限完善 · 界面美观 · 代码规范
</p>

---

## ✨ 功能特性

### 核心模块

| 模块 | 功能 |
|:-----|:-----|
| 👤 用户管理 | 用户增删改查、状态管理、角色分配 |
| 🎭 角色管理 | 角色权限配置、菜单分配 |
| 📑 菜单管理 | 目录/菜单/按钮三级管理，支持树形结构 |
| 🔌 API 管理 | 接口资源管理，按菜单分组，支持白名单 |
| 📖 字典管理 | 动态字典配置，前端缓存同步 |
| 📝 日志管理 | 登录日志、操作日志记录与查询 |
| 🙍 个人中心 | 个人信息修改、密码修改、头像上传 |

### 系统特性

- 🔐 **RBAC 权限模型** - 用户 → 角色 → 菜单 → 接口，精细化权限控制
- 🎯 **动态路由** - 基于菜单权限自动生成前端路由
- 🎨 **主题切换** - 浅色/深色模式无缝切换
- 📱 **响应式布局** - 支持桌面端和移动端
- 📊 **操作日志** - AOP 切面自动记录用户操作

---

## 🛠️ 技术栈

<table>
<tr>
<td width="50%" valign="top">

### 后端

| 技术 | 说明 |
|:-----|:-----|
| Spring Boot 3.2 | 核心框架 |
| MyBatis Plus 3.5 | ORM 框架 |
| MySQL 8+ | 数据库 |
| JWT 0.12 | Token 认证 |
| Knife4j 4.4 | API 文档 |
| Hutool 5.8 | 工具库 |

</td>
<td width="50%" valign="top">

### 前端

| 技术 | 说明 |
|:-----|:-----|
| Vue 3.4 | 渐进式框架 |
| Vite 5 | 构建工具 |
| Element Plus 2.6 | UI 组件库 |
| Pinia 2.1 | 状态管理 |
| Vue Router 4.3 | 路由管理 |
| TypeScript 5.4 | 类型系统 |

</td>
</tr>
</table>

---

## 🚀 快速开始

### 环境要求

- Node.js >= 18
- JDK >= 17
- MySQL >= 8.0
- Maven >= 3.8

### 1. 数据库初始化

```bash
# 创建数据库
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS smart_admin DEFAULT CHARACTER SET utf8mb4;"

# 执行初始化脚本
mysql -u root -p smart_admin < sql/smart_admin.sql
```

> 默认管理员账号：`admin` / `admin123`

### 2. 启动后端

```bash
cd smart-admin-server
mvn spring-boot:run
```

- API 文档：http://localhost:8080/doc.html
- 后端地址：http://localhost:8080

### 3. 启动前端

```bash
cd smart-admin-web
pnpm install   # 首次运行安装依赖
pnpm dev
```

- 前端地址：http://localhost:3000

---

## 📁 项目结构

```
smart-admin/
├── smart-admin-server/         # Spring Boot 后端
│   └── src/main/java/com/smartadmin/
│       ├── common/             # 通用模块
│       ├── config/             # 配置类
│       ├── interceptor/        # 拦截器
│       ├── utils/              # 工具类
│       └── modules/            # 业务模块
│           ├── auth/           # 认证授权
│           ├── system/         # 系统管理
│           └── profile/        # 个人中心
│
├── smart-admin-web/            # Vue 3 前端
│   └── src/
│       ├── api/                # API 封装
│       ├── views/              # 页面组件
│       ├── router/             # 路由配置
│       ├── store/              # Pinia 状态管理
│       ├── utils/              # 工具类
│       └── layout/             # 布局组件
│
└── sql/                        # 数据库脚本
    └── smart_admin.sql         # 完整 SQL
```

### 核心数据表

| 表名 | 说明 |
|:-----|:-----|
| sys_user | 用户表 |
| sys_role | 角色表 |
| sys_menu | 菜单表 |
| sys_api | 接口资源表 |
| sys_user_role | 用户角色关联 |
| sys_role_menu | 角色菜单关联 |
| sys_dict_type | 字典类型 |
| sys_dict_data | 字典数据 |
| sys_login_log | 登录日志 |
| sys_oper_log | 操作日志 |

---

## 🔐 权限设计

### RBAC 模型

```
用户 ──▶ 用户角色 ──▶ 角色 ──▶ 角色菜单 ──▶ 菜单
                                               │
                                               ▼
                                            接口资源
                                          (sys_api)
```

### 权限验证流程

```
请求 → JWT验证 → 获取角色 → 获取菜单 → 查询API → Ant匹配 → 放行/拒绝
```

**核心设计：**

1. 接口通过 `menu_id` 关联菜单（按钮类型）
2. 角色选择菜单后自动获得关联接口权限
3. 超级管理员（`super_admin`）拥有所有权限

### 菜单类型

| 类型 | 值 | 说明 |
|:-----|:---|:-----|
| 目录 | 1 | 一级分组，如「系统管理」 |
| 菜单 | 2 | 对应页面，如「用户管理」 |
| 按钮 | 3 | 页面操作，如「新增」「删除」 |

---

## 📖 开发指南

### 新增模块

**后端：**
1. 创建 Entity → Mapper → Service → Controller
2. 创建 Request/Response DTO
3. 添加菜单和接口数据

**前端：**
1. 创建 `src/api/xxx.ts`
2. 创建 `src/views/Xxx/index.vue`
3. 配置路由和权限

### 代码规范

- ✅ 使用 DTO 封装请求/响应，禁止直接返回 Entity
- ✅ Controller → Service → Mapper 分层调用
- ✅ 方法参数超过 5 个时使用 DTO 封装
- ✅ 分页统一使用 `PageReq` / `PageResp`

---

## 📚 相关资源

- [Knife4j API 文档](http://localhost:8080/doc.html)
- [Element Plus](https://element-plus.org/)
- [Vue 3](https://vuejs.org/)
- [Spring Boot](https://spring.io/projects/spring-boot)

---

## 📄 License

[MIT License](LICENSE)

---

<p align="center">
  Made with ❤️ by Smart Admin Team
</p>