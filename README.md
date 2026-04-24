# Smart Admin

<p align="center">
  <img src="https://img.shields.io/badge/Spring%20Boot-3.2-brightgreen?logo=springboot" alt="Spring Boot">
  <img src="https://img.shields.io/badge/Vue-3.4-4FC08D?logo=vue.js" alt="Vue">
  <img src="https://img.shields.io/badge/Element%20Plus-2.6-409EFF?logo=element" alt="Element Plus">
  <img src="https://img.shields.io/badge/TypeScript-5.4-3178C6?logo=typescript" alt="TypeScript">
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="License">
</p>

<p align="center">
  <b>基于 Vue 3 + Spring Boot 3.x 的现代化管理后台模板</b>
</p>

<p align="center">
  开箱即用 · 安全易用 · 界面美观 · 快速上手
</p>

---

## 功能特性

| 模块 | 说明 |
|:-----|:-----|
| 用户管理 | 用户增删改查、角色分配 |
| 角色权限 | RBAC 权限模型，菜单/按钮级别控制 |
| 菜单管理 | 目录/菜单/按钮三级管理 |
| 字典管理 | 动态字典配置 |
| 操作日志 | AOP 自动记录用户操作 |
| 饮食记录 | 饮食日志，卡片/日历多视图 |
| 脑暴笔记 | 灵感收集，快捷键快速添加 |
| 任务记录 | 甘特图展示，拖拽进度管理 |
| 文本收藏 | Markdown 收藏，编辑/预览分离 |

**系统特性：** 动态路由 · 浅色/深色主题 · 响应式布局 · JWT 认证 · 操作日志审计

---

## 技术栈

| 后端 | 前端 |
|:-----|:-----|
| Spring Boot | Vue 3 |
| MyBatis Plus | Vite |
| MySQL | Element Plus |
| JWT | Pinia |
| Knife4j | TypeScript |

---

## 3分钟快速开始

**环境：** JDK 17+ · Node.js 18+ · MySQL 8+

```bash
# 1. 初始化数据库
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS smart_admin DEFAULT CHARACTER SET utf8mb4;"
mysql -u root -p smart_admin < sql/smart_admin.sql

# 2. 启动后端
cd smart-admin-server && mvn spring-boot:run

# 3. 启动前端
cd smart-admin-web && pnpm install && pnpm dev
```

> 默认账号：`admin` / `admin123`

**访问地址：**
- 前端：http://localhost:3000
- 后端：http://localhost:8080

---

## 项目结构

```
smart-admin/
├── smart-admin-server/    # Spring Boot 后端
├── smart-admin-web/        # Vue 3 前端
└── sql/                   # 数据库脚本
```

---

## 预览截图

![Dashboard Preview](./preview.png)

---

## License

[MIT License](LICENSE)
