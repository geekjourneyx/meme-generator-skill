#!/usr/bin/env python3
"""
情绪分析脚本 (Emotion Analyzer)
分析用户文本，识别情绪类型、强度和场景。

Usage:
    python3 emotion_analyzer.py <user_input>

Output:
    JSON with emotion, intensity, and scenario fields
"""

import re
import json
import sys

# 情绪关键词库
EMOTION_KEYWORDS = {
    "positive_strong": ["太棒", "完美", "成功", "搞定", "完成", "通过", "赢了", "🎉", "👍", "开心", "高兴", "兴奋", "激动"],
    "positive_medium": ["不错", "可以", "还行", "好的", "满意", "喜欢"],
    "positive_weak": ["嗯", "哦", "了解", "嘿嘿", "哈哈"],

    "negative_strong": ["气死", "讨厌", "烦死了", "累死了", "崩溃", "绝望", "想死", "受够了"],
    "negative_medium": ["累", "烦", "难过", "伤心", "痛苦", "失望", "怕", "焦虑", "担心"],
    "negative_weak": ["唉", "算了", "随便", "无聊", "无语", "惆怅"],

    "confused": ["不知道", "怎么办", "懵", "不明白", "为啥", "搞不懂", "不理解"],
    "curious": ["想知道", "怎么回事", "为什么", "如何"],
    "tired": ["累", "困", "疲惫", "乏力", "想睡"],
    "miss": ["想", "思念", "怀念", "好久不见"],
}

# 情感检测优先级
PRIORITY_PATTERNS = {
    "success": ["完成", "成功", "搞定", "通过", "赢了", "达成", "升职", "加薪"],
    "failure": ["失败", "搞砸", "挂了", "错了", "不行", "不行"],
    "sharing": ["看", "这个", "给你", "分享", "哈哈"],
    "greeting": ["你好", "在吗", "在没", "早上好", "晚安", "回来"],
    "goodbye": ["走了", "拜拜", "睡了", "回见"],
    "thinking": ["思考", "想", "不知道", "怎么", "如何"],
}

def detect_emotion(text):
    """
    检测情绪类型和强度

    返回: (emotion_type, intensity)
    emotion_type: positive, negative, neutral
    intensity: strong, medium, weak, none
    """
    text_lower = text.lower()

    # 检查强烈情绪
    for keyword in EMOTION_KEYWORDS["positive_strong"]:
        if keyword in text:
            return "positive", "strong"

    for keyword in EMOTION_KEYWORDS["negative_strong"]:
        if keyword in text:
            return "negative", "strong"

    # 检查中等情绪
    for keyword in EMOTION_KEYWORDS["positive_medium"]:
        if keyword in text:
            return "positive", "medium"

    for keyword in EMOTION_KEYWORDS["negative_medium"]:
        if keyword in text:
            return "negative", "medium"

    # 检查弱情绪
    for keyword in EMOTION_KEYWORDS["positive_weak"]:
        if keyword in text:
            return "positive", "weak"

    for keyword in EMOTION_KEYWORDS["negative_weak"]:
        if keyword in text:
            return "negative", "weak"

    # 检查特殊情绪
    for keyword in EMOTION_KEYWORDS["confused"]:
        if keyword in text:
            return "neutral", "confused"

    for keyword in EMOTION_KEYWORDS["tired"]:
        if keyword in text:
            return "negative", "medium"  # 疲累也算消极

    for keyword in EMOTION_KEYWORDS["miss"]:
        if keyword in text:
            return "positive", "medium"  # 思念是积极的

    return "neutral", "weak"

def detect_scenario(text, emotion, intensity):
    """
    检测场景类型

    返回: scenario
    scenario: success, failure, casual, confusion, sharing, greeting, goodbye, thinking, tired
    """
    text_lower = text.lower()

    # 先检查特定场景模式
    for scenario, keywords in PRIORITY_PATTERNS.items():
        for keyword in keywords:
            if keyword in text_lower:
                return scenario

    # 根据情绪推断场景
    if emotion == "positive" and intensity in ["strong", "medium"]:
        if any(k in text for k in ["看", "这个", "分享", "给你", "哈哈"]):
            return "sharing"
        return "success"

    if emotion == "negative" and intensity in ["strong", "medium"]:
        if any(k in text for k in ["搞砸", "失败", "挂了"]):
            return "failure"
        return "tired"

    if emotion == "neutral":
        if intensity == "confused":
            return "confusion"
        if any(k in text for k in ["在吗", "你好", "在没"]):
            return "greeting"
        if any(k in text for k in ["走了", "拜拜", "睡了"]):
            return "goodbye"
        if any(k in text for k in ["知道", "怎么", "如何", "为什么"]):
            return "thinking"

    return "casual"

def analyze_emotion(text):
    """
    完整的情绪分析

    返回: dict
    {
        "emotion": "positive|negative|neutral",
        "intensity": "strong|medium|weak|none|confused",
        "scenario": "success|failure|casual|confusion|sharing|greeting|goodbye|thinking|tired",
        "should_respond": bool,
        "recommended_template": str or None
    }
    """
    if not text or len(text.strip()) < 1:
        return {"emotion": "neutral", "intensity": "none", "scenario": "casual", "should_respond": False}

    emotion, intensity = detect_emotion(text)
    scenario = detect_scenario(text, emotion, intensity)

    # 判断是否应该回应（避免过度表达）
    should_respond = True
    if emotion == "neutral" and intensity == "weak" and scenario == "casual":
        # 中性弱情绪的日常闲聊，可以不发表情
        should_respond = False

    # 推荐模板
    recommended_template = recommend_template(emotion, scenario)

    return {
        "emotion": emotion,
        "intensity": intensity,
        "scenario": scenario,
        "should_respond": should_respond,
        "recommended_template": recommended_template
    }

def recommend_template(emotion, scenario):
    """根据情绪和场景推荐模板"""
    # 破冰期默认推荐（实际应根据关系阶段调整）
    templates_by_scenario = {
        "success": ["applaud", "perfect", "good_news", "petpet", "hug"],
        "failure": ["pat", "hug", "rub", "petpet"],
        "sharing": ["shock", "clown", "applaud", "pinch"],
        "casual": ["petpet", "rub", "stare_at_you"],
        "confusion": ["stare_at_you", "think_what", "murmur"],
        "greeting": ["petpet", "rub", "hug"],
        "thinking": ["stare_at_you", "think_what"],
        "tired": ["pat", "hug", "rub", "petpet"],
    }

    templates = templates_by_scenario.get(scenario, ["petpet"])
    return templates[0] if templates else "petpet"

def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Usage: python3 emotion_analyzer.py <text>"}))
        sys.exit(1)

    text = " ".join(sys.argv[1:])
    result = analyze_emotion(text)
    print(json.dumps(result, ensure_ascii=False))

if __name__ == "__main__":
    main()
