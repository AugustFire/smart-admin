# Smart Admin AI 服务

基于 LangChain 的 AI 聊天服务，支持 Tool Calling。

## 快速开始

### 1. 安装依赖

```bash
cd smart-admin-ai
pip install -r requirements.txt
```

### 2. 配置

复制 `.env.example` 为 `.env`，填入 API Key：

```bash
cp .env.example .env
```

编辑 `.env`：
```env
DEEPSEEK_API_KEY=your-actual-api-key
DEEPSEEK_BASE_URL=https://api.deepseek.com
DEEPSEEK_MODEL=deepseek-chat
```

### 3. 启动服务

```bash
python main.py
```

或使用 uvicorn：

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### 4. 测试

访问 API 文档：http://localhost:8000/docs

## API 接口

| 接口 | 方法 | 说明 |
|------|------|------|
| `/health` | GET | 健康检查 |
| `/chat` | POST | 发送消息 |
| `/history/{session_id}` | GET | 获取历史 |
| `/history/{session_id}` | DELETE | 删除会话 |
| `/models` | GET | 可用模型 |

## 可用 Tools

- `get_user_info`: 查询用户信息
- `search_data`: 搜索系统数据
- `get_weather`: 查询天气
- `calculate`: 数学计算

## 与 Java 后端集成

Java 后端通过 HTTP 调用此服务：

```java
// 示例
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
headers.set("Authorization", "Bearer " + token);

Map<String, Object> body = Map.of(
    "session_id", sessionKey,
    "message", userMessage
);

restTemplate.postForObject("http://localhost:8000/chat", body, Map.class);
```
