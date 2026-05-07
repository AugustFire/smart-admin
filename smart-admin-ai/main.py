"""FastAPI 入口"""
import logging
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse

from config import config
from models.schemas import ChatRequest
from chain.chat_chain import get_chat_chain

# 配置日志
logging.basicConfig(
    level=getattr(logging, config.LOG_LEVEL),
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="Smart Admin AI 服务",
    description="AI 聊天助手，支持 Tool Calling",
    version="1.0.0",
)

# CORS 配置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 预热 ChatChain
try:
    get_chat_chain()
    logger.info("ChatChain 初始化成功")
except Exception as e:
    logger.warning(f"ChatChain 初始化失败: {e}")


@app.get("/health")
async def health_check():
    """健康检查"""
    return {"status": "ok"}


@app.post("/chat/stream")
async def chat_stream(request: ChatRequest):
    """
    流式聊天接口

    使用 SSE (Server-Sent Events) 返回流式响应
    """
    try:
        logger.info(f"收到消息: session_id={request.session_id}, message={request.message[:50]}...")

        chat_chain = get_chat_chain()
        history = request.history or []

        async def event_generator():
            full_response = ""

            # 使用流式调用
            try:
                async for chunk in chat_chain.stream_chat(
                    message=request.message,
                    history=history,
                    user_id=request.user_id,
                ):
                    # 处理不同的 chunk 类型
                    if isinstance(chunk, dict):
                        if chunk.get("type") == "content":
                            content = chunk.get("content", "")
                            full_response += content
                            yield f"data: {content}\n\n"
                        elif chunk.get("type") == "tool_call":
                            pass
                        elif chunk.get("type") == "tool_result":
                            yield f"data: [TOOL_RESULT]{chunk.get('result')}[/TOOL_RESULT]\n\n"
                        elif chunk.get("type") == "error":
                            yield f"data: [ERROR]{chunk.get('error')}[/ERROR]\n\n"
                    else:
                        full_response += str(chunk)
                        yield f"data: {str(chunk)}\n\n"

                yield "data: [DONE]\n\n"

            except Exception as e:
                logger.error(f"Stream error: {e}")
                yield f"data: [ERROR]{str(e)}[/ERROR]\n\n"

        return StreamingResponse(
            event_generator(),
            media_type="text/event-stream",
            headers={
                "Cache-Control": "no-cache",
                "Connection": "keep-alive",
                "X-Accel-Buffering": "no",
            }
        )

    except Exception as e:
        logger.error(f"Chat error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/models")
async def get_models():
    """获取可用模型"""
    return [
        {"id": config.OPENAI_MODEL, "name": config.OPENAI_MODEL, "provider": "deepseek"}
    ]


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=config.HOST,
        port=config.PORT,
        reload=True,
    )