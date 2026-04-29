"""LangChain 对话链 - 使用 OpenAI Tools 模式"""
import logging
import asyncio
from typing import List, Optional, AsyncGenerator, Union
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, AIMessage, SystemMessage, BaseMessage, ToolMessage
from langchain_core.tools import tool
from langchain_core.output_parsers import StrOutputParser

from config import config
from models.schemas import Message, ToolCall
from chain.tools import SYSTEM_TOOLS

logger = logging.getLogger(__name__)


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

    def chat(self, message: str, history: List[Message] = None) -> tuple[str, List[ToolCall]]:
        """
        对话（非流式）

        Args:
            message: 用户消息
            history: 历史消息

        Returns:
            (回答, 工具调用列表)
        """
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
            messages = chat_history + [HumanMessage(content=message)]

            # 循环处理工具调用
            max_iterations = 10
            iteration = 0
            tool_calls = []

            while iteration < max_iterations:
                iteration += 1

                # 调用 LLM
                response = self.llm_with_tools.invoke(messages)

                # 如果没有 tool_calls，返回最终回答
                if not response.tool_calls:
                    messages.append(response)
                    return response.content, tool_calls

                # 记录工具调用
                for tc in response.tool_calls:
                    tool_calls.append(ToolCall(
                        name=tc["name"],
                        arguments=tc["args"],
                        result=None
                    ))

                # 先把带有 tool_calls 的 AIMessage 添加到消息列表
                messages.append(response)

                # 为每个 tool_call 执行工具并添加 ToolMessage
                for tc in response.tool_calls:
                    tool_name = tc["name"]
                    tool_args = tc["args"]
                    tool_call_id = tc["id"]

                    # 找到并执行工具
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

                    # 更新结果记录
                    for tc_record in tool_calls:
                        if tc_record.name == tool_name and tc_record.result is None:
                            tc_record.result = str(result)
                            break

                    # 添加 ToolMessage（必须包含 tool_call_id）
                    messages.append(ToolMessage(
                        content=str(result),
                        tool_call_id=tool_call_id
                    ))

            # 超过最大迭代次数
            return "处理超时，请稍后重试", tool_calls

        except Exception as e:
            logger.error(f"Chat error: {e}")
            return f"抱歉，处理消息时出错: {str(e)}", []

    async def stream_chat(self, message: str, history: List[Message] = None) -> AsyncGenerator[dict, None]:
        """
        流式对话

        Args:
            message: 用户消息
            history: 历史消息

        Yields:
            dict: 包含 type 和 content/error 的字典
        """
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
            messages = chat_history + [HumanMessage(content=message)]

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
                    # 逐字流式返回（模拟打字机效果）
                    for char in content:
                        yield {"type": "content", "content": char}
                        await asyncio.sleep(0.02)  # 打字速度
                    messages.append(response)
                    return

                # 处理工具调用
                messages.append(response)

                # 为每个 tool_call 执行工具
                for tc in response.tool_calls:
                    tool_name = tc["name"]
                    tool_args = tc["args"]
                    tool_call_id = tc["id"]

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