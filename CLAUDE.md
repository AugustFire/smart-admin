# CLAUDE.md

Smart Admin 项目开发指南。本文档为 Claude Code 提供项目开发规范和指导。

> **⚠️ 重要提示**：本文档已拆分，执行具体任务前请先读取相应规范文档：
> - 后端开发任务 → 读取 `.claude/docs/backend.md`
> - 前端开发任务 → 读取 `.claude/docs/frontend.md`

## 项目名称

**Smart Admin** - 基于 Vue 3 + Spring Boot 3.x 的现代化管理后台模板

---

## 常用命令

### 后端 (smart-admin-server)

```bash
cd smart-admin-server && mvn spring-boot:run    # 启动后端
mvn clean package                               # 编译打包
mvn test                                        # 运行测试
mvn clean package -DskipTests                   # 跳过测试打包
```

### 前端 (smart-admin-web)
记住前端保证在3000端口启动，不要换其他端口，另外，vite hmr能热更新的不要重启!
```bash
cd smart-admin-web && npm run dev    # 启动开发服务器
npm run build                        # 构建生产版本
npm run preview                      # 预览构建结果
npm run lint                         # 代码检查
```

### 数据库

数据库操作命令详见后端规范文档。

---

## 项目架构

### 技术栈概览

- **后端**: Spring Boot + MyBatis Plus + MySQL
- **前端**: Vue 3 + Vite + Element Plus + Pinia
- **语言**: TypeScript
- **认证**: JWT + BCrypt

详细技术栈和配置请参考后端/前端规范文档。

### 开发环境

| 服务 | 地址 | 备注 |
|------|------|------|
| 前端 | http://localhost:3000 | Vite 开发服务器 |
| 后端 | http://localhost:8080 | Spring Boot |
| Python AI | http://localhost:8000 | FastAPI（Tool Calling） |
| API 文档 | http://localhost:8080/doc.html | Knife4j |

详细配置（端口、数据库、JWT等）见后端/前端规范文档。

### 目录结构

```
smart-admin/
├── smart-admin-server/               # Spring Boot 后端
│   └── src/main/java/com/smartadmin/
│       ├── common/                   # 通用模块（注解、AOP、异常处理等）
│       ├── config/                   # 配置类
│       ├── interceptor/              # JWT、权限拦截器
│       ├── utils/                    # 工具类
│       └── modules/                  # 业务模块
│           ├── auth/                 # 认证授权
│           ├── system/               # 系统管理（用户、角色、菜单、API、字典、日志）
│           ├── dev/                  # 开发工具（数据模型）
│           ├── lifestyle/            # 生活管理（饮食记录、脑暴笔记、任务记录、文本收藏）
│           └── ai/                    # AI 聊天助手（调用 Python 微服务）
│
├── smart-admin-ai/                   # Python AI 服务（独立运行）
│   ├── main.py                       # FastAPI 入口
│   ├── chain/                        # LangChain 对话链
│   └── config.py                     # 配置管理
│
├── smart-admin-web/                  # Vue 3 前端
│   └── src/
│       ├── api/                      # API 封装
│       ├── views/                    # 页面组件
│       │   ├── System/               # 系统管理
│       │   ├── DevTools/             # 开发工具
│       │   │   └── DataModel/        # 数据模型（数据库、表、字段、关系、E-R图）
│       │   └── Lifestyle/             # 生活管理
│       │       ├── Diet/             # 饮食记录
│       │       ├── brainstorm/        # 脑暴笔记
│       │       ├── task-record/      # 任务记录
│       │       └── text-collection/  # 文本收藏
│       ├── router/                   # 路由配置
│       ├── store/                    # Pinia 状态
│       ├── styles/                   # 全局样式
│       ├── components/               # 公共组件
│       │   └── AiChat/              # AI 聊天助手组件
│       └── utils/                    # 工具函数
│
└── sql/                              # 数据库脚本
```

### 核心架构说明

**认证授权流程：**
1. 用户登录 → `/auth/login` → 生成 JWT Token
2. 后续请求携带 `Authorization: Bearer <token>`
3. `JwtInterceptor` 验证 Token
4. `PermissionInterceptor` 检查接口权限

**权限模型：**
```
用户 → 角色 → 菜单 → 接口
sys_user → sys_user_role → sys_role → sys_role_menu → sys_menu → sys_api
```

**超级管理员：** 角色编码 `super_admin` 自动拥有所有权限

---

## 规范文档索引

| 文档 | 说明 |
|------|------|
| [后端开发规范](./.claude/docs/backend.md) | Java 代码规范、三层架构、DTO 分层、数据库配置、JWT 配置 |
| [前端开发规范](./.claude/docs/frontend.md) | Vue 组件规范、API 封装、样式规范、开发环境配置 |

---

## 开发惯例

- 统一响应格式：`Result<T>`
- 全局异常处理：`@RestControllerAdvice`
- 操作日志：`@OperLog` 注解 + AOP
- 密码加密：BCrypt
- 后端**不使用** `Serializable`

---

## ⚠️ 重要提醒

**未经用户明确允许，不得自行提交代码（git commit + git push）。注意不要提交密钥等敏感信息**

只有在用户明确说"提交代码"或"可以提交"时才可执行提交操作。
