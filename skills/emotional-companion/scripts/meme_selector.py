#!/usr/bin/env python3
"""
表情选择脚本 (Meme Selector)
根据情绪、场景、关系阶段选择合适的表情模板。

Usage:
    python3 meme_selector.py <emotion> <scenario> [stage]

Output:
    JSON with selected template and text suggestion
"""

import json
import sys
import random

# 模板分类
TEMPLATES = {
    "gentle": ["petpet", "rub", "hug", "pat"],
    "playful": ["slap", "pinch", "clown", "shock"],
    "attentive": ["stare_at_you", "think_what", "murmur"],
    "celebration": ["applaud", "perfect", "good_news"],
    "empathy": ["sad", "speechless", "confuse"],
}

# 文字模板
TEXT_TEMPLATES = {
    "positive": [
        "太棒了！为你骄傲",
        "这也太厉害了",
        "你真的做到了",
        "恭喜恭喜",
    ],
    "negative": [
        "没事，抱抱",
        "别担心，我在呢",
        "大家都会遇到这种时候",
        "想说说吗？我听着",
    ],
    "neutral": [
        "嗯...",
        "在想什么？",
        "我在听你说",
        "继续说，我听着",
    ],
}

# 关系阶段配置
STAGE_CONFIG = {
    "ice_break": {  # 0-10 次
        "allowed": ["gentle", "attentive", "empathy", "celebration"],
        "frequency": 0.25,  # 25% 基础概率
        "banned": ["slap", "clown", "pinch"],
        "text_style": "warm",
    },
    "familiar": {  # 11-50 次
        "allowed": ["gentle", "playful", "attentive", "empathy", "celebration"],
        "frequency": 0.20,
        "banned": [],
        "text_style": "casual",
    },
    "intimate": {  # 50+ 次
        "allowed": ["all"],
        "frequency": "adaptive",
        "banned": [],
        "text_style": "authentic",
    },
}

# 根据情绪和场景的模板选择规则
SELECTION_RULES = {
    # 成功场景
    ("positive", "success"): {
        "weights": {"celebration": 0.5, "gentle": 0.3, "attentive": 0.2},
        "templates": {
            "celebration": ["applaud", "perfect", "good_news"],
            "gentle": ["hug", "petpet"],
            "attentive": ["stare_at_you"],
        },
    },
    # 失败场景
    ("negative", "failure"): {
        "weights": {"empathy": 0.5, "gentle": 0.4, "attentive": 0.1},
        "templates": {
            "empathy": ["hug", "pat", "rub"],
            "gentle": ["petpet"],
            "attentive": ["murmur"],
        },
    },
    # 分享场景
    ("positive", "sharing"): {
        "weights": {"playful": 0.4, "celebration": 0.4, "gentle": 0.2},
        "templates": {
            "playful": ["shock", "clown", "pinch"],
            "celebration": ["applaud"],
            "gentle": ["petpet", "rub"],
        },
    },
    # 困惑场景
    ("neutral", "confusion"): {
        "weights": {"attentive": 0.6, "gentle": 0.4},
        "templates": {
            "attentive": ["stare_at_you", "think_what"],
            "gentle": ["rub", "murmur"],
        },
    },
    # 疲累场景
    ("negative", "tired"): {
        "weights": {"gentle": 0.6, "empathy": 0.3, "attentive": 0.1},
        "templates": {
            "gentle": ["hug", "pat", "rub"],
            "empathy": ["petpet"],
            "attentive": ["stare_at_you"],
        },
    },
    # 默认日常场景
    ("*", "casual"): {
        "weights": {"gentle": 0.5, "attentive": 0.3, "playful": 0.2},
        "templates": {
            "gentle": ["petpet", "rub"],
            "attentive": ["stare_at_you"],
            "playful": ["pinch"],
        },
    },
}

def get_text_suggestion(emotion, template, stage="ice_break"):
    """生成自然的文字建议"""
    style = STAGE_CONFIG[stage]["text_style"]

    if emotion == "positive":
        texts = [
            "太棒了！为你骄傲",
            "这真的太厉害了",
            "你做到了！",
            "恭喜恭喜",
        ]
    elif emotion == "negative":
        texts = [
            "没事，抱抱",
            "别担心，我在呢",
            "想说说吗？我听着",
            "都会过去的",
        ]
    else:  # neutral
        texts = [
            "嗯...",
            "我在听",
            "然后呢？",
            "继续说",
        ]

    # 根据关系阶段调整
    if style == "warm":
        return texts[0] + "～"
    elif style == "casual":
        return texts[random.randint(0, len(texts) - 1)]
    elif style == "authentic":
        return texts[random.randint(0, len(texts) - 1)]
    else:
        return texts[0]

def should_use_meme(stage, recent_count):
    """判断是否应该使用表情（频率控制）"""
    config = STAGE_CONFIG[stage]

    if config["frequency"] == "adaptive":
        # 自适应模式：根据最近使用频率动态调整
        if recent_count >= 3:
            return False  # 过去使用了3次，暂停
        return 0.3  # 30% 基础概率
    else:
        base_prob = config["frequency"]
        if recent_count >= 3:
            base_prob *= 0.3  # 降低概率
        return random.random() < base_prob

def select_template(emotion, scenario, stage="ice_break", interaction_count=0, recent_count=0):
    """
    选择合适的表情模板

    参数:
        emotion: positive, negative, neutral
        scenario: success, failure, casual, confusion, sharing, greeting, etc.
        stage: ice_break, familiar, intimate
        interaction_count: 累计交互次数
        recent_count: 最近5分钟内的表情使用次数

    返回: dict
    {
        "template": str,
        "text": str,
        "use_meme": bool,
        "reason": str
    }
    """
    # 检查是否应该使用表情
    use_meme = should_use_meme(stage, recent_count)

    if not use_meme:
        return {
            "template": None,
            "text": "",
            "use_meme": False,
            "reason": "frequency_control"
        }

    # 获取选择规则
    key = (emotion, scenario) if (emotion, scenario) in SELECTION_RULES else ("*", "casual")
    rule = SELECTION_RULES[key]

    # 选择类别
    allowed_categories = []
    if stage == "ice_break":
        allowed_categories = STAGE_CONFIG[stage]["allowed"]
    elif stage == "familiar":
        allowed_categories = STAGE_CONFIG[stage]["allowed"]
    else:  # intimate
        allowed_categories = TEMPLATES.keys()

    # 根据权重选择类别
    categories = list(rule["weights"].keys())
    if allowed_categories != ["all"]:
        categories = [c for c in categories if c in allowed_categories]

    weights = [rule["weights"][c] for c in categories]
    total = sum(weights)
    weights = [w / total for w in weights]

    category = random.choices(categories, weights=weights)[0]

    # 从类别中选择具体模板
    available_templates = rule["templates"][category]
    # 过滤掉被禁用的模板
    banned = STAGE_CONFIG[stage].get("banned", [])

    available_templates = [t for t in available_templates if t not in banned]
    if not available_templates:
        available_templates = TEMPLATES["gentle"]  # 后备

    template = random.choice(available_templates)

    # 生成文字
    text = get_text_suggestion(emotion, template, stage)

    return {
        "template": template,
        "text": text,
        "use_meme": True,
        "reason": f"{emotion}_{scenario}_{stage}"
    }

def main():
    if len(sys.argv) < 3:
        print(json.dumps({"error": "Usage: python3 meme_selector.py <emotion> <scenario> [stage]"}))
        sys.exit(1)

    emotion = sys.argv[1]
    scenario = sys.argv[2]
    stage = sys.argv[3] if len(sys.argv) > 3 else "ice_break"

    result = select_template(emotion, scenario, stage)
    print(json.dumps(result, ensure_ascii=False))

if __name__ == "__main__":
    main()
