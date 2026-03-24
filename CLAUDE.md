# CLAUDE.md

Smart Admin 项目开发指南。本文档为 Claude Code 提供项目开发规范和指导。

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

```bash
cd smart-admin-web && npm run dev    # 启动开发服务器
npm run build                        # 构建生产版本
npm run preview                      # 预览构建结果
npm run lint                         # 代码检查
```

### 数据库

```bash
mysql -u root -p smart_admin < sql/smart_admin.sql    # 执行初始化脚本
```



## 项目架构

### 技术栈

| 层级 | 技术 | 版本 |
|------|------|------|
| 后端 | Spring Boot + MyBatis Plus + MySQL | 3.2.3 + 3.5.5 + 8+ |
| 前端 | Vue 3 + Vite + Element Plus + Pinia | 3.4 + 5 + 2.6 + 2.1 |
| 类型 | TypeScript | 5.4 |
| 认证 | JWT + BCrypt | 0.12.5 + spring-security-crypto |
| 文档 | Knife4j (Swagger) | 4.4.0 |
| 日志 | AOP + AspectJ | - |

### 开发环境

| 服务 | 地址 | 备注 |
|------|------|------|
| 前端 | http://localhost:3000 | Vite 开发服务器 |
| 后端 | http://localhost:8080 | Spring Boot |
| API 文档 | http://localhost:8080/doc.html | Knife4j |
| 数据库 | localhost:3306 | MySQL 8+ |

### 目录结构

```
smart-admin/
├── smart-admin-server/               # Spring Boot 后端
│   └── src/main/java/com/smartadmin/
│       ├── common/                   # 通用模块
│       │   ├── annotation/           # @OperLog 操作日志注解
│       │   ├── aspect/               # OperLogAspect AOP 切面
│       │   ├── base/                 # BaseService、BaseServiceImpl 基类
│       │   ├── enums/                # BusinessType 等枚举
│       │   ├── exception/            # BusinessException 等异常类
│       │   ├── handler/              # GlobalExceptionHandler
│       │   ├── pojo/                 # PageReq、PageResp 通用分页 DTO
│       │   └── Result.java           # 统一响应格式
│       ├── config/                   # 配置类 (JwtProperties、SwaggerConfig、MybatisPlusConfig)
│       ├── interceptor/              # JWT 拦截器、权限拦截器
│       ├── utils/                    # 工具类 (JwtUtils、PasswordUtils、ServletUtils)
│       └── modules/                  # 业务模块
│           ├── auth/                 # 认证授权模块
│           │   ├── controller/       # AuthController
│           │   ├── biz/              # AuthBiz
│           │   └── dto/              # request/、response/
│           ├── profile/              # 个人中心模块
│           │   ├── controller/       # ProfileController
│           │   ├── biz/              # ProfileBiz
│           │   ├── service/          # SysProfileService
│           │   └── dto/              # request/、response/
│           └── system/               # 系统管理模块（核心业务，扁平化结构）
│               ├── controller/       # UserController、RoleController、MenuController 等
│               ├── biz/              # UserBiz、RoleBiz、MenuBiz、ApiBiz、DictBiz、LogBiz
│               ├── service/          # Service 接口和实现 (impl/)
│               ├── entity/           # SysUser、SysRole、SysMenu 等实体
│               ├── mapper/           # Mapper 和 Converter (UserConverter、RoleConverter 等)
│               └── dto/              # 扁平化结构：request/、response/
│
├── smart-admin-web/                  # Vue 3 前端
│   ├── src/
│   │   ├── api/                      # API 封装
│   │   ├── components/               # 公共组件
│   │   ├── views/                    # 页面组件
│   │   ├── router/                   # 路由配置 (index.ts、guard.ts)
│   │   ├── store/                    # Pinia (user、permission 模块)
│   │   ├── utils/                    # 工具 (request.ts Axios 封装)
│   │   ├── styles/                   # 全局样式、主题变量
│   │   ├── types/                    # TypeScript 类型定义
│   │   └── layout/                   # 布局组件
│   └── package.json
│
└── sql/                              # 数据库脚本
    └── smart_admin.sql               # 完整 SQL
```

### 核心模块说明

**认证授权流程：**
1. 用户登录 → `/auth/login` → 验证通过生成 JWT Token
2. 后续请求携带 `Authorization: Bearer <token>`
3. `JwtInterceptor` 验证 Token 有效性
4. `PermissionInterceptor` 检查接口权限 (Ant 风格匹配)

**权限模型：**
```
用户 → 角色 → 菜单 → 接口

sys_user → sys_user_role → sys_role → sys_role_menu → sys_menu
                                                              ↓
                                                          sys_api(menuId)
```

**重要说明：**
- `sys_menu` 表不存储 API 信息，只存储菜单/按钮定义
- `sys_api` 表通过 `menuId` 字段关联菜单
- 角色 选择菜单后，自动获得该菜单关联的所有接口权限

**接口权限验证流程：**
1. 用户请求携带 JWT Token
2. `JwtInterceptor` 解析 Token 获取 `userId`
3. `PermissionInterceptor` 按链路验证权限：
   - 超级管理员（`super_admin`）直接放行
   - 获取用户角色 ID → 获取菜单 ID → 获取可访问的 API（通过 `sys_api.menuId` 筛选）
   - 匹配请求 URL 和 Method（Ant 风格）

**超级管理员特权：**
- 角色编码为 `super_admin` 的角色自动拥有所有接口权限
- 超级管理员访问任何接口时不进行权限检查，直接放行

**菜单类型：** 1=目录、2=菜单、3=按钮

**API 管理：**
- 通过"API 管理"菜单维护接口资源
- 每个接口通过 `menuId` 关联到按钮类型的菜单
- 角色选择菜单后自动获得关联的接口权限

**数据库表：**

| 表名 | 说明 |
|------|------|
| sys_user | 用户表 |
| sys_role | 角色表 |
| sys_menu | 菜单表（目录、菜单、按钮） |
| sys_api | 接口资源表（通过 menuId 关联菜单） |
| sys_user_role | 用户角色关联表 |
| sys_role_menu | 角色菜单关联表 |
| sys_dict_type | 字典类型表 |
| sys_dict_data | 字典数据表 |
| sys_login_log | 登录日志表 |
| sys_oper_log | 操作日志表 |

**关键文件：**
- `interceptor/JwtInterceptor.java` - JWT 验证
- `interceptor/PermissionInterceptor.java` - 接口权限检查
- `config/WebConfig.java` - 拦截器配置
- `router/guard.ts` - 前端路由守卫
- `store/modules/permission.ts` - 动态路由生成

## 开发惯例

- 统一响应格式：`Result<T>`
- 全局异常处理：`@RestControllerAdvice`
- 操作日志：`@OperLog` 注解 + AOP
- 密码加密：BCrypt
- Token 有效期：7200 秒（2 小时）

---

## 后端代码规范

### DTO 分层规范

**禁止直接返回 Entity 给前端**，必须使用 DTO：

| 类型 | 位置 | 命名规范 | 说明 |
|------|------|----------|------|
| Request DTO | `dto/request/` | `XxxReq` | 请求参数对象 |
| Response DTO | `dto/response/` | `XxxResp` | 响应结果对象 |
| Entity | `entity/` | `SysXxx` | 数据库实体（仅内部使用） |

### 三层架构规范

```
Controller → Biz(业务层) → Service(数据服务层) → Mapper(数据访问层)
```

- **Controller 层**：接收请求、参数校验、调用业务层、返回结果
- **Biz 层**：处理复杂业务逻辑、事务控制、DTO 与 Entity 转换
- **Service 层**：CRUD 数据访问封装，不包含复杂业务逻辑
- **Mapper 层**：MyBatis 数据访问

**禁止 Controller 直接调用 Mapper，必须通过 Biz 层！**

### 参数封装规范

方法参数超过 5 个时，必须使用对象封装：

```java
// ✅ 正确：使用 Request DTO 封装
public Result<PageResp<UserResp>> pageUsers(@Valid UserPageQueryReq req) { ... }
```

### 通用分页 DTO

```java
// 请求基类
@Data
public class PageReq {
    @Min(value = 1)
    private Integer pageNum = 1;
    @Min(value = 1) @Max(value = 100)
    private Integer pageSize = 10;
    private String sortBy;
    private String sortOrder;
}

// 响应基类
@Data
public class PageResp<T> {
    private List<T> list;
    private Long total;
    private Integer pageNum;
    private Integer pageSize;
    private Integer pages;
}
```

## 默认配置

| 配置项 | 值 |
|--------|-----|
| 数据库地址 | localhost:3306 |
| 数据库名 | smart_admin |
| 默认账号 | admin / admin123 |
| 前端端口 | 3000 |
| 后端端口 | 8080 |

## 数据库操作

推荐使用 `mysqlsh` 工具：

```bash
mysqlsh -u root -p123456 --sql -D smart_admin < your-script.sql
mysqlsh -u root -p123456 --sql -D smart_admin -e "SHOW TABLES;"
mysqlsh -u root -p123456 --sql -D smart_admin -e "SELECT * FROM sys_api;"
```