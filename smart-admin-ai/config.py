"""配置管理"""
import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    """DeepSeek 配置"""
    DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY", "your-api-key")
    DEEPSEEK_BASE_URL = os.getenv("DEEPSEEK_BASE_URL", "https://api.deepseek.com")
    DEEPSEEK_MODEL = os.getenv("DEEPSEEK_MODEL", "deepseek-chat")

    """OpenAI 兼容配置（用于 DeepSeek 等）"""
    OPENAI_API_KEY = DEEPSEEK_API_KEY
    OPENAI_BASE_URL = DEEPSEEK_BASE_URL
    OPENAI_MODEL = DEEPSEEK_MODEL

    """日志配置"""
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")

    """服务配置"""
    HOST = os.getenv("HOST", "0.0.0.0")
    PORT = int(os.getenv("PORT", 8000))


config = Config()
