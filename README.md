# Smart Admin 管理后台模板

基于 Vue 3 + Spring Boot 3.x 的现代化管理后台模板，支持可复用的商业级快速开发。

> 🎯 开箱即用的中后台解决方案 | 🎨 科技感十足的 UI 设计 | ⚡ 高效开发体验

## 技术栈

### 后端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Spring Boot | 3.2.3 | 核心框架 |
| MyBatis Plus | 3.5.5 | ORM 框架 |
| MySQL | 8+ | 数据库 |
| JWT | 0.12.5 | Token 认证 |
| Knife4j | 4.4.0 | API 文档 |
| Hutool | 5.8.25 | 工具库 |

### 前端技术栈

| 技术 | 版本 | 说明 |
|------|------|------|
| Vue | 3.4 | 渐进式框架 |
| Vite | 5 | 构建工具 |
| Element Plus | 2.6 | UI 组件库 |
| Pinia | 2.1 | 状态管理 |
| Vue Router | 4.3 | 路由管理 |
| Axios | 1.6 | HTTP 客户端 |
| TypeScript | 5.4 | 类型系统 |

## 功能特性

### 核心功能

| 模块 | 说明 |
|------|------|
| 用户管理 | 用户 CRUD、状态管理、角色分配 |
| 角色管理 | 角色 CRUD、菜单权限分配、接口权限分配 |
| 菜单管理 | 目录/菜单/按钮三级管理 |
| 接口资源 | 接口 CRUD、按菜单分组管理 |
| 字典管理 | 动态字典配置、前端缓存同步 |
| 日志管理 | 登录日志、操作日志记录与查询 |
| 个人中心 | 个人信息修改、密码修改、头像上传 |

### 系统特性

- 🎨 **主题切换**: 浅色/深色模式无缝切换
- 📱 **响应式布局**: 支持桌面端和移动端
- 🔐 **权限控制**: RBAC 模型 + 接口级权限
- 🎯 **动态路由**: 基于菜单权限动态生成路由
- 📊 **操作日志**: AOP 切面自动记录操作

## 快速开始

### 环境要求

- Node.js >= 18
- JDK >= 17
- MySQL >= 8.0
- Maven >= 3.8

### 1. 数据库初始化

```bash
# 创建数据库
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS auto_admin DEFAULT CHARACTER SET utf8mb4;"

# 执行初始化脚本
mysql -u root -p auto_admin < sql/schema.sql
mysql -u root -p auto_admin < sql/data.sql
```

**默认管理员账号：**
| 用户名 | 密码 |
|--------|------|
| `admin` | `admin123` |

### 2. 启动后端

```bash
cd auto-admin-server

# 方式一：Maven 启动
mvn spring-boot:run

# 方式二：打包后运行
mvn clean package -DskipTests
java -jar target/auto-admin-server-1.0.0.jar
```

启动成功后访问：
- **API 文档**: http://localhost:8080/doc.html
- **后端地址**: http://localhost:8080

### 3. 启动前端

```bash
cd auto-admin-web

# 安装依赖（首次运行）
pnpm install

# 启动开发服务器
pnpm dev

# 生产构建
pnpm build
```

启动成功后访问：
- **前端地址**: http://localhost:3000

## 项目结构

```
auto-admin/
├── auto-admin-server/        # Spring Boot 后端
│   ├── src/main/java/com/autoadmin/
│   │   ├── common/           # 通用模块（Result 响应、异常处理、分页 DTO）
│   │   │   ├── annotation/   # @OperLog 操作日志注解
│   │   │   ├── aspect/       # 操作日志 AOP 切面
│   │   │   ├── enums/        # BusinessType 等枚举
│   │   │   ├── exception/    # BusinessException 等异常类
│   │   │   ├── handler/      # GlobalExceptionHandler 全局异常处理
│   │   │   ├── pojo/         # PageReq、PageResp 通用分页 DTO
│   │   │   └── Result.java   # 统一响应格式
│   │   ├── config/           # 配置类 (JwtProperties、SwaggerConfig、MybatisPlusConfig)
│   │   ├── interceptor/      # JWT 拦截器、权限拦截器
│   │   ├── utils/            # 工具类 (JwtUtils、PasswordUtils、ServletUtils)
│   │   ├── mapper/           # MyBatis Mapper (数据访问层)
│   │   ├── entity/           # 数据库实体 (SysUser、SysRole 等)
│   │   ├── auth/             # 认证授权模块
│   │   ├── system/           # 系统管理模块（核心业务）
│   │   │   ├── user/         # 用户管理
│   │   │   ├── role/         # 角色管理
│   │   │   ├── menu/         # 菜单管理
│   │   │   ├── api/          # 接口资源管理
│   │   │   ├── dict/         # 字典管理
│   │   │   └── log/          # 日志管理
│   │   └── profile/          # 个人中心模块
│   └── src/main/resources/
│       ├── mapper/           # MyBatis XML
│       └── application.yml   # 应用配置
│
├── auto-admin-web/           # Vue 3 前端
│   ├── src/
│   │   ├── api/              # API 封装
│   │   ├── components/       # 公共组件
│   │   ├── views/            # 页面组件
│   │   ├── router/           # 路由配置
│   │   ├── store/            # Pinia 状态管理
│   │   ├── utils/            # 工具类（Axios 封装）
│   │   ├── styles/           # 全局样式、主题变量
│   │   ├── types/            # TypeScript 类型定义
│   │   └── layout/           # 布局组件
│   └── package.json
│
└── sql/                      # 数据库脚本
    ├── schema.sql            # 表结构（10 张核心表）
    └── data.sql              # 初始化数据
```

### 核心数据库表

| 表名 | 说明 |
|------|------|
| sys_user | 用户表 |
| sys_role | 角色表 |
| sys_menu | 菜单表（目录、菜单、按钮） |
| sys_api | 接口资源表 |
| sys_user_role | 用户角色关联表 |
| sys_role_menu | 角色菜单关联表 |
| sys_dict_type | 字典类型表 |
| sys_dict_data | 字典数据表 |
| sys_login_log | 登录日志表 |
| sys_oper_log | 操作日志表 |

## 权限设计

### RBAC 模型

```
┌──────────┐     ┌──────────────┐     ┌──────────┐     ┌──────────────┐     ┌──────────┐
│  用户    │────▶│  用户角色    │────▶│  角色    │────▶│  角色菜单    │────▶│  菜单    │
│ sys_user │     │ sys_user_role│     │ sys_role │     │ sys_role_menu│     │ sys_menu │
└──────────┘     └──────────────┘     └──────────┘     └──────────────┘     └──────────┘
                                                                    │
                                                                    ▼
                                                             ┌──────────┐
                                                             │  接口    │
                                                             │ sys_api  │
                                                             │(menu_id) │
                                                             └──────────┘
```

### 权限验证流程

```
用户请求 → JWT 验证 → 获取用户角色 → 获取角色菜单 ID → 查询 sys_api(menuId) → Ant 匹配 → 放行/403
```

**核心逻辑：**
1. 接口通过 `menu_id` 关联到菜单（按钮类型）
2. 角色选择菜单后，自动获得该菜单关联的所有接口权限
3. 无需单独配置角色-接口关联表

### 超级管理员

- 角色编码为 `super_admin` 的角色自动拥有所有接口权限
- 超级管理员访问任何接口时直接放行，不进行权限检查

### 菜单类型

| 类型 | 值 | 说明 | 示例 |
|------|-----|------|------|
| 目录 | 1 | 一级分组 | 系统管理 |
| 菜单 | 2 | 对应页面 | 用户管理 |
| 按钮 | 3 | 页面操作按钮 | 新增、删除 |

### 权限配置流程

1. **配置菜单**：在"菜单管理"中维护目录、菜单、按钮
2. **配置接口**：在"API 管理"中维护接口，通过 `menuId` 关联到按钮
3. **分配权限**：在"角色管理"中为角色勾选菜单，自动获得关联的接口权限

## API 文档

启动后端后访问：http://localhost:8080/doc.html

## 开发指南

## 开发指南

### 新增模块

#### 后端步骤

1. 在 `entity/` 创建 Entity 实体类
2. 在 `mapper/` 创建 Mapper 接口和 XML
3. 在 `system/xxx/` 创建业务模块目录（如 system/user）
4. 创建 DTO：
   - `dto/request/XxxReq.java` - 请求 DTO
   - `dto/response/XxxResp.java` - 响应 DTO
5. 创建 Service 业务层接口和实现
6. 创建 Controller 控制器
7. 在 `sys_menu` 表添加菜单数据
8. 在 `sys_api` 表添加接口数据（可选关联菜单）

#### 前端步骤

1. 创建 API 文件：`src/api/xxx.ts`
2. 创建页面组件：`src/views/Xxx/index.vue`
3. 后端菜单管理中添加路由配置
4. 后端接口资源中添加接口权限

### 代码规范

- **禁止 Controller 直接返回 Entity**：必须使用 Response DTO
- **禁止 Controller 调用 Mapper**：必须通过 Service 层
- **方法参数超过 5 个必须封装**：使用 Request DTO
- **分页统一使用 PageReq/PageResp**：位于 `common/pojo/`
- **使用 MapStruct 进行 Bean 转换**：Converter 接口放在 `mapper/` 子包

### 主题定制

修改以下文件来自定义主题：

| 文件 | 说明 |
|------|------|
| `src/styles/variables.scss` | SCSS 变量 |
| `src/styles/index.scss` | CSS 变量（支持主题切换） |

### 常用命令

**后端**
```bash
mvn spring-boot:run      # 启动
mvn clean package        # 打包
mvn test                 # 测试
```

**前端**
```bash
pnpm dev                 # 开发
pnpm build               # 构建
pnpm lint                # 检查
```

## 相关资源

- [API 文档](http://localhost:8080/doc.html) - Knife4j Swagger 文档
- [Element Plus](https://element-plus.org/) - UI 组件库
- [Vue 3](https://vuejs.org/) - Vue 3 官方文档
- [Spring Boot](https://spring.io/projects/spring-boot) - Spring Boot 官方文档

## License

MIT License

---

<p align="center">Made with ❤️ by Smart Admin Team</p>
