"""Pydantic 数据模型"""
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class Message(BaseModel):
    """聊天消息"""
    role: str = Field(..., description="角色: user/assistant/system")
    content: str = Field(..., description="消息内容")


class ChatRequest(BaseModel):
    """聊天请求"""
    session_id: str = Field(..., description="会话ID")
    message: str = Field(..., description="用户消息")
    history: Optional[List[Message]] = Field(default_factory=list, description="历史消息")
    model: Optional[str] = Field(default=None, description="模型名称")


class ToolCall(BaseModel):
    """工具调用记录"""
    name: str = Field(..., description="工具名称")
    arguments: Dict[str, Any] = Field(..., description="工具参数")
    result: Optional[str] = Field(default=None, description="工具执行结果")


class ChatResponse(BaseModel):
    """聊天响应"""
    answer: str = Field(..., description="AI 回答")
    session_id: str = Field(..., description="会话ID")
    tool_calls: Optional[List[ToolCall]] = Field(default_factory=list, description="工具调用记录")
    model: Optional[str] = Field(default=None, description="使用的模型")


class HistoryRequest(BaseModel):
    """历史记录请求"""
    session_id: str


class ModelInfo(BaseModel):
    """模型信息"""
    id: str
    name: str
    provider: str
