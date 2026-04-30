"""Pydantic 数据模型"""
from typing import Optional, List
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
    user_id: Optional[int] = Field(default=None, description="用户ID")
