"""系统工具定义"""
import requests
import pandas as pd
from langchain_core.tools import tool
from typing import Optional

from config import config


# 用户上下文（用于在工具调用间传递 user_id）
class UserContext:
    user_id: Optional[int] = None

user_context = UserContext()


def set_user_id(uid: int):
    """设置当前用户ID"""
    user_context.user_id = uid


def get_user_id() -> Optional[int]:
    """获取当前用户ID"""
    return user_context.user_id


def get_java_headers() -> dict:
    """获取调用 Java 后端的请求头"""
    headers = {"Content-Type": "application/json"}
    if config.JAVA_API_KEY:
        headers["Authorization"] = f"Bearer {config.JAVA_API_KEY}"
    return headers


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
        return f"""查询结果如下：

| 项目 | 内容 |
|:---|:---|
| **用户ID** | {user_id} |
| **姓名** | {user['name']} |
| **部门** | {user['dept']} |
| **职位** | {user['role']} |

如果您还有其他问题，欢迎继续提问！"""
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


@tool
def get_diet_records(days: int = 30) -> str:
    """查询当前用户饮食记录并分析健康程度

    查询当前登录用户的饮食记录，进行健康分析并给出建议。
    注意：无需传入用户ID，会自动使用当前登录用户。

    Args:
        days: 查询的天数，默认30天，最小1天，最大365天
    """
    try:
        # 获取当前用户ID
        user_id = get_user_id()
        if user_id is None:
            return "无法获取用户ID，请重新登录后重试"

        # 限制查询范围
        days = max(1, min(days, 365))

        # 调用 Java 内部 API（已放行，无需认证）
        url = f"{config.JAVA_BASE_URL}/api/ai/internal/diet/page"
        params = {
            "userId": user_id,
            "pageNum": 1,
            "pageSize": 100,
            "startDate": f"{(pd.Timestamp.now() - pd.Timedelta(days=days)).strftime('%Y-%m-%d')}",
            "endDate": pd.Timestamp.now().strftime('%Y-%m-%d')
        }

        response = requests.get(url, headers=get_java_headers(), params=params, timeout=10)

        if response.status_code != 200:
            return f"查询饮食记录失败：HTTP {response.status_code}"

        data = response.json()
        if data.get("code") != 200:
            return f"查询饮食记录失败：{data.get('message', '未知错误')}"

        result = data.get("data", {})
        records = result.get("list", [])

        if not records:
            return f"最近{days}天没有饮食记录"

        # 格式化饮食记录
        total = len(records)
        meal_stats = {"breakfast": 0, "lunch": 0, "dinner": 0, "snack": 0, "drink": 0}
        tag_stats = {}
        food_list = []

        for r in records:
            meal_type = r.get("mealType", "")
            meal_stats[meal_type] = meal_stats.get(meal_type, 0) + 1
            food_list.append(f"{r.get('mealTypeName', meal_type)}: {r.get('foodName', '')} {r.get('portion', '')}")
            if r.get('tags'):
                for tag in r.get('tags', '').split(','):
                    tag_stats[tag] = tag_stats.get(tag, 0) + 1

        # 生成分析报告
        report = [f"📊 饮食记录统计（最近{days}天）"]
        report.append(f"总记录：{total}条")
        report.append(f"\n🍽️ 餐食分布：")
        for meal, count in meal_stats.items():
            if count > 0:
                meal_names = {"breakfast": "早餐", "lunch": "午餐", "dinner": "晚餐", "snack": "宵夜", "drink": "饮料"}
                report.append(f"  {meal_names.get(meal, meal)}: {count}次")

        report.append(f"\n🏷️ 标签统计：")
        for tag, count in tag_stats.items():
            tag_names = {"healthy": "健康", "light": "轻食", "high-sugar": "高糖", "oily": "油炸", "spicy": "辣", "bland": "清淡"}
            report.append(f"  {tag_names.get(tag, tag)}: {count}次")

        # 健康建议
        report.append(f"\n💡 健康建议：")

        healthy_count = tag_stats.get("healthy", 0) + tag_stats.get("light", 0)
        unhealthy_count = tag_stats.get("high-sugar", 0) + tag_stats.get("oily", 0)

        if unhealthy_count > healthy_count:
            report.append("  ⚠️ 近期油炸、高糖食物较多，建议增加蔬菜水果摄入")
        if meal_stats.get("snack", 0) > 5:
            report.append("  ⚠️ 宵夜频率较高，长期可能影响消化和睡眠")
        if meal_stats.get("drink", 0) > 10:
            report.append("  ⚠️ 饮料摄入较多，建议用白开水或茶替代")
        if healthy_count > unhealthy_count:
            report.append("  ✅ 饮食结构较为健康，继续保持！")

        report.append(f"\n📋 详细记录：")
        report.append("\n".join(food_list[:20]))  # 最多显示20条
        if len(food_list) > 20:
            report.append(f"  ...还有{len(food_list) - 20}条记录")

        return "\n".join(report)

    except Exception as e:
        return f"查询饮食记录出错：{str(e)}"


# 工具列表
SYSTEM_TOOLS = [get_user_info, search_data, get_weather, calculate, get_diet_records]
