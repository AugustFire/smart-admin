"""系统工具定义"""
from langchain_core.tools import tool
from typing import Optional


@tool
def get_user_info(user_id: int) -> str:
    """查询用户信息

    根据用户ID查询用户的基本信息，包括姓名、部门、职位等。

    Args:
        user_id: 用户ID，整数类型
    """
    # TODO: 实际项目中这里调用 Java 后端 API 或数据库
    # 目前返回模拟数据
    users = {
        1: {"name": "张三", "dept": "技术部", "role": "开发工程师"},
        2: {"name": "李四", "dept": "产品部", "role": "产品经理"},
        3: {"name": "王五", "dept": "设计部", "role": "UI设计师"},
    }
    user = users.get(user_id, None)
    if user:
        return f"用户ID={user_id}，姓名={user['name']}，部门={user['dept']}，职位={user['role']}"
    return f"未找到用户ID={user_id}的用户"


@tool
def search_data(keyword: str) -> str:
    """搜索系统数据

    根据关键词搜索系统中的数据，包括用户、订单、任务等信息。

    Args:
        keyword: 搜索关键词
    """
    # TODO: 实际项目中这里可以连接搜索引擎、数据库等
    # 目前返回模拟数据
    results = [
        f"搜索到关于 '{keyword}' 的相关结果：",
        f"1. 用户表中有3条相关记录",
        f"2. 订单表中有12条相关记录",
        f"3. 任务表中有5条相关记录",
    ]
    return "\n".join(results)


@tool
def get_weather(city: str) -> str:
    """查询城市天气

    查询指定城市的当前天气情况。

    Args:
        city: 城市名称，如"北京"、"上海"
    """
    # TODO: 实际项目中这里调用天气 API
    # 目前返回模拟数据
    weathers = {
        "北京": "晴，25°C，空气质量良",
        "上海": "多云，22°C，空气质量优",
        "广州": "雷阵雨，28°C，空气质量良",
        "深圳": "晴，30°C，空气质量优",
        "杭州": "阴，20°C，空气质量良",
    }
    return weathers.get(city, f"抱歉，暂不支持查询 {city} 的天气")


@tool
def calculate(expression: str) -> str:
    """数学计算

    执行数学表达式的计算。

    Args:
        expression: 数学表达式，如 "2+3*5" 或 "(10+5)/3"
    """
    try:
        # 安全计算（仅支持基本运算）
        allowed_chars = set("0123456789+-*/.() ")
        if all(c in allowed_chars for c in expression):
            result = eval(expression)
            return f"{expression} = {result}"
        else:
            return "表达式包含非法字符"
    except Exception as e:
        return f"计算错误: {str(e)}"


# 工具列表
SYSTEM_TOOLS = [get_user_info, search_data, get_weather, calculate]
