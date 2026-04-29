# 后端开发规范

## 代码规范

### 不使用 Serializable

**禁止在 Java 类中实现 `Serializable` 接口或声明 `serialVersionUID`。**

原因：
- 项目使用 Spring Boot + JSON (Jackson) 序列化，不需要 Java 原生序列化
- 没有分布式 Session、RMI 等需要序列化的场景
- 减少冗余代码，保持简洁

```java
// ❌ 错误示例
public class UserResp implements Serializable {
    private static final long serialVersionUID = 1L;
}

// ✅ 正确示例
public class UserResp {
    // ...
}
```

### DTO 分层规范

**禁止直接返回 Entity 给前端**，必须使用 DTO：

| 类型 | 位置 | 命名规范 | 说明 |
|------|------|----------|------|
| Request DTO | `dto/request/` | `XxxReq` | 请求参数对象 |
| Response DTO | `dto/response/` | `XxxResp` | 响应结果对象 |
| Entity | `entity/` | `SysXxx` / `DevXxx` | 数据库实体（仅内部使用） |

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

## 模块结构规范

### 标准模块结构

```
modules/xxx/                    # 业务模块
├── controller/                 # 控制器
│   └── XxxController.java
├── biz/                        # 业务逻辑层
│   └── XxxBiz.java
├── service/                    # 数据服务层
│   ├── XxxService.java
│   └── impl/
│       └── XxxServiceImpl.java
├── entity/                     # 实体类
│   └── XxxEntity.java
├── mapper/                     # Mapper 接口
│   └── XxxMapper.java
└── dto/
    ├── request/                # 请求 DTO
    │   ├── XxxAddReq.java
    │   ├── XxxUpdateReq.java
    │   └── XxxQueryReq.java
    └── response/               # 响应 DTO
        └── XxxResp.java
```

### Dev 数据模型模块

位于 `modules/dev/`，包含数据模型管理功能：

| 实体 | 说明 | 对应表 |
|------|------|--------|
| DevDmDatabase | 数据库定义 | dev_dm_database |
| DevDmTable | 数据表定义 | dev_dm_table |
| DevDmColumn | 字段定义 | dev_dm_column |
| DevDmRelation | 表关系定义 | dev_dm_relation |

**核心 Biz：** `DataModelBiz.java` - 处理数据库逆向生成、E-R 图数据组装等复杂业务

### Lifestyle 生活管理模块

位于 `modules/lifestyle/`，包含生活记录管理功能：

| 实体 | 说明 | 对应表 |
|------|------|--------|
| DietRecord | 饮食记录 | lifestyle_diet_record |
| BrainstormIdea | 脑暴想法 | lifestyle_brainstorm |
| TaskRecord | 任务记录 | lifestyle_task_record |
| TextCollection | 文本收藏 | lifestyle_text_collection |

### AI 聊天模块

位于 `modules/ai/`，AI 聊天助手功能，调用 Python 微服务：

| 实体 | 说明 | 对应表 |
|------|------|--------|
| AiChatSession | 聊天会话 | ai_chat_session |
| AiChatMessage | 聊天消息 | ai_chat_message |

**核心接口：**

| 接口 | 方法 | 说明 |
|------|------|------|
| `/ai/chat` | POST | 发送消息 |
| `/ai/chat/stream` | POST | 流式发送消息（SSE） |
| `/ai/history/{sessionKey}` | GET | 获取历史消息 |
| `/ai/sessions` | GET | 获取会话列表 |
| `/ai/sessions/{sessionKey}` | DELETE | 删除会话 |

**架构：** Java 后端负责 Session 管理和消息持久化，Python AI 服务（`smart-admin-ai/`）负责 LLM 调用和 Tool Calling。

## 数据库规范

### 命名约定

- **表名**：`sys_xxx`（系统表）、`dev_xxx`（开发工具表）
- **字段**：蛇形命名 `create_time`
- **索引**：`idx_表名_字段名`
- **外键**：`fk_表名_字段名`

### 通用字段

所有表必须包含：

```sql
id              BIGINT PRIMARY KEY AUTO_INCREMENT
update_time     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
create_time     DATETIME DEFAULT CURRENT_TIMESTAMP
```

### 数据库操作

推荐使用 `mysqlsh` 工具：

```bash
# 执行 SQL 脚本
mysqlsh -u root -p123456 --sql -D smart_admin < your-script.sql

# 执行单条命令
mysqlsh -u root -p123456 --sql -D smart_admin -e "SHOW TABLES;"
```

## 接口规范

### 统一响应格式

```java
Result.success(data)          // 成功
Result.error(message)         // 错误
Result.page(pageResp)         // 分页
```

### 常用注解

```java
@RestController
@RequestMapping("/api/xxx")
public class XxxController {

    @OperLog(title = "用户管理", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public Result<Void> add(@Valid @RequestBody XxxAddReq req) { }

    @OperLog(title = "用户管理", businessType = BusinessType.UPDATE)
    @PostMapping("/update")
    public Result<Void> update(@Valid @RequestBody XxxUpdateReq req) { }

    @OperLog(title = "用户管理", businessType = BusinessType.DELETE)
    @PostMapping("/delete/{id}")
    public Result<Void> delete(@PathVariable Long id) { }

    @GetMapping("/page")
    public Result<PageResp<XxxResp>> page(@Valid XxxPageQueryReq req) { }

    @GetMapping("/detail/{id}")
    public Result<XxxResp> detail(@PathVariable Long id) { }
}
```

## 关键配置

### 端口配置

```yaml
server:
  port: 8080
```

### 数据库配置

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/smart_admin
    username: root
    password: 123456
```

### JWT 配置

```yaml
jwt:
  secret: your-secret-key
  expiration: 7200  # 2小时
```
