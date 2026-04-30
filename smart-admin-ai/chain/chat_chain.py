"""LangChain 对话链 - 使用 OpenAI Tools 模式"""
import logging
import asyncio
from typing import List, Optional, AsyncGenerator
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, AIMessage, BaseMessage, ToolMessage, SystemMessage
from langchain_core.tools import tool

from config import config
from models.schemas import Message
from chain.tools import SYSTEM_TOOLS, set_user_id

logger = logging.getLogger(__name__)


SYSTEM_PROMPT = """你是一个健康助手。当用户询问以下内容时，**必须**使用对应工具：

1. 用户询问天气 → 使用 get_weather
2. 用户询问饮食记录、饮食习惯、健康分析 → 使用 get_diet_records
3. 用户询问数学计算 → 使用 calculate
4. 用户询问个人信息（姓名、部门等）→ 使用 get_user_info
5. 其他问题 → 直接回答，**不要**调用工具

注意：不要在不需要时调用工具，特别是分析饮食时不要查询天气。"""


class ChatChain:
    """对话链 - 使用 OpenAI Function Calling"""

    def __init__(self):
        self.llm = ChatOpenAI(
            model=config.OPENAI_MODEL,
            api_key=config.OPENAI_API_KEY,
            base_url=config.OPENAI_BASE_URL,
            temperature=0.7,
        )
        # 绑定工具到 LLM
        self.llm_with_tools = self.llm.bind_tools(SYSTEM_TOOLS)
        self.user_id: Optional[int] = None

    def set_user_id(self, user_id: int):
        self.user_id = user_id

    async def stream_chat(self, message: str, history: List[Message] = None, user_id: int = None) -> AsyncGenerator[dict, None]:
        """
        流式对话

        Args:
            message: 用户消息
            history: 历史消息
            user_id: 用户ID

        Yields:
            dict: 包含 type 和 content/error 的字典
        """
        if user_id is not None:
            self.set_user_id(user_id)
        try:
            # 转换历史消息
            chat_history: List[BaseMessage] = []
            if history:
                for msg in history:
                    if msg.role == "user":
                        chat_history.append(HumanMessage(content=msg.content))
                    else:
                        chat_history.append(AIMessage(content=msg.content))

            # 构建初始消息列表
            messages = [SystemMessage(content=SYSTEM_PROMPT)] + chat_history + [HumanMessage(content=message)]

            # 循环处理工具调用
            max_iterations = 10
            iteration = 0

            while iteration < max_iterations:
                iteration += 1

                # 调用 LLM（非流式，获取完整响应）
                response = self.llm_with_tools.invoke(messages)

                # 如果没有 tool_calls，流式返回内容
                if not response.tool_calls:
                    content = response.content or ""
                    # 按行流式返回，保留 markdown 格式
                    for line in content.split('\n'):
                        # 空行发空字符串（Java 会写 data:\n\n），非空行发原内容（Java 加 \n\n）
                        yield {"type": "content", "content": line}
                        await asyncio.sleep(0.05)  # 打字速度
                    messages.append(response)
                    return

                # 处理工具调用
                messages.append(response)

                # 设置用户ID到全局上下文
                if self.user_id is not None:
                    set_user_id(self.user_id)

                # 为每个 tool_call 执行工具
                for tc in response.tool_calls:
                    tool_name = tc["name"]
                    tool_args = tc["args"]
                    tool_call_id = tc["id"]

                    logger.info(f"调用工具(stream): {tool_name}, 参数: {tool_args}")

                    # 发送工具调用开始
                    yield {"type": "tool_call", "name": tool_name, "args": tool_args}

                    # 执行工具
                    result = None
                    for t in SYSTEM_TOOLS:
                        if t.name == tool_name:
                            if isinstance(tool_args, dict):
                                result = t.invoke(tool_args)
                            else:
                                result = t.invoke(tool_args)
                            break

                    if result is None:
                        result = f"Tool {tool_name} not found"

                    logger.info(f"工具 {tool_name}(stream) 返回: {str(result)[:200]}")

                    # 发送工具结果
                    yield {"type": "tool_result", "result": str(result)}

                    # 添加 ToolMessage
                    messages.append(ToolMessage(
                        content=str(result),
                        tool_call_id=tool_call_id
                    ))

            yield {"type": "error", "error": "处理超时"}

        except Exception as e:
            logger.error(f"Stream chat error: {e}")
            yield {"type": "error", "error": str(e)}


# 单例
_chat_chain: Optional[ChatChain] = None


def get_chat_chain() -> ChatChain:
    """获取对话链实例"""
    global _chat_chain
    if _chat_chain is None:
        _chat_chain = ChatChain()
    return _chat_chain