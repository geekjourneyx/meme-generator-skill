#!/usr/bin/env python3
"""
情感伴侣存储管理 (Emotional Companion Storage)
管理 emotional-companion skill 的用户数据和会话状态

Usage:
    python3 storage.py <action> [args...]

Actions:
    init-session <session-id>     初始化会话
    get-stage <session-id>          获取当前关系阶段
    increment <session-id>           增加交互计数
    log-meme <session-id> <template>  记录表情使用
    get-stats <session-id>           获取会话统计
"""

import json
import os
import sys
from datetime import datetime
from pathlib import Path

# 存储路径
BASE_DIR = Path.home() / ".openclaw" / "skills" / "emotional-companion"
SESSIONS_DIR = BASE_DIR / "sessions"
USERS_DIR = BASE_DIR / "users"

# 关系阶段阈值
STAGE_THRESHOLDS = {
    "ice_break": 0,
    "familiar": 11,
    "intimate": 51
}

# 阶段顺序
STAGE_ORDER = ["ice_break", "familiar", "intimate"]


def get_session_file(session_id):
    """获取会话存储文件路径"""
    return SESSIONS_DIR / f"{session_id}.json"


def get_user_file(user_id):
    """获取用户存储文件路径"""
    return USERS_DIR / f"{user_id}.json"


def ensure_dirs():
    """确保必要的目录存在"""
    SESSIONS_DIR.mkdir(parents=True, exist_ok=True)
    USERS_DIR.mkdir(parents=True, exist_ok=True)


def init_session(session_id):
    """初始化新会话"""
    ensure_dirs()
    session_file = get_session_file(session_id)

    data = {
        "session_id": session_id,
        "interaction_count": 0,
        "relationship_stage": "ice_break",
        "meme_usage_log": [],
        "created_at": datetime.now().isoformat(),
        "last_seen": datetime.now().isoformat()
    }

    with open(session_file, "w") as f:
        json.dump(data, f, indent=2)

    return data


def get_session_data(session_id):
    """获取会话数据"""
    session_file = get_session_file(session_id)
    if session_file.exists():
        with open(session_file, "r") as f:
            return json.load(f)
    return init_session(session_id)


def increment_interaction(session_id):
    """增加交互计数并更新阶段"""
    data = get_session_data(session_id)
    data["interaction_count"] += 1
    data["last_seen"] = datetime.now().isoformat()

    # 检查是否需要升级阶段
    current_stage = data["relationship_stage"]
    current_count = data["interaction_count"]

    new_stage = current_stage
    if current_stage == "ice_break" and current_count >= STAGE_THRESHOLDS["familiar"]:
        new_stage = "familiar"
    elif current_stage == "familiar" and current_count >= STAGE_THRESHOLDS["intimate"]:
        new_stage = "intimate"

    if new_stage != current_stage:
        data["relationship_stage"] = new_stage
        data["stage_upgraded_at"] = datetime.now().isoformat()

    with open(get_session_file(session_id), "w") as f:
        json.dump(data, f, indent=2)

    return data


def log_meme_usage(session_id, template, user_emotion, context=""):
    """记录表情包使用"""
    data = get_session_data(session_id)

    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "template": template,
        "user_emotion": user_emotion,
        "context": context
    }

    data["meme_usage_log"].append(log_entry)
    # 只保留最近 50 条记录
    if len(data["meme_usage_log"]) > 50:
        data["meme_usage_log"] = data["meme_usage_log"][-50:]

    with open(get_session_file(session_id), "w") as f:
        json.dump(data, f, indent=2)


def get_stats(session_id):
    """获取会话统计信息"""
    data = get_session_data(session_id)

    # 统计表情使用频率
    template_counts = {}
    for log in data["meme_usage_log"]:
        tmpl = log["template"]
        template_counts[tmpl] = template_counts.get(tmpl, 0) + 1

    # 统计情绪分布
    emotion_counts = {}
    for log in data["meme_usage_log"]:
        em = log["user_emotion"]
        emotion_counts[em] = emotion_counts.get(em, 0) + 1

    return {
        "session_id": session_id,
        "interaction_count": data["interaction_count"],
        "relationship_stage": data["relationship_stage"],
        "created_at": data["created_at"],
        "last_seen": data["last_seen"],
        "template_counts": template_counts,
        "emotion_counts": emotion_counts,
        "total_memes": len(data["meme_usage_log"])
    }


def create_user_memory(user_id):
    """创建用户记忆"""
    ensure_dirs()
    user_file = get_user_file(user_id)

    if not user_file.exists():
        data = {
            "user_id": user_id,
            "total_interactions": 0,
            "relationship_stage": "ice_break",
            "first_interaction": datetime.now().isoformat(),
            "last_interaction": datetime.now().isoformat(),
            "preferences": {
                "favorite_templates": [],
                "avoid_topics": []
            }
        }

        with open(user_file, "w") as f:
            json.dump(data, f, indent=2)

        return data
    else:
        with open(user_file, "r") as f:
            return json.load(f)


def update_user_interaction(user_id, emotion, stage):
    """更新用户交互记录"""
    user_file = get_user_file(user_id)

    if user_file.exists():
        with open(user_file, "r") as f:
            data = json.load(f)
    else:
        data = create_user_memory(user_id)

    data["total_interactions"] += 1
    data["last_interaction"] = datetime.now().isoformat()
    data["relationship_stage"] = stage

    # 记录情绪偏好
    if emotion and emotion not in ["neutral", "weak"]:
        if emotion not in data["preferences"]["favorite_templates"]:
            data["preferences"]["favorite_templates"].append(emotion)

    with open(user_file, "w") as f:
        json.dump(data, f, indent=2)


def get_user_stage(user_id):
    """获取用户的关系阶段"""
    user_file = get_user_file(user_id)

    if not user_file.exists():
        return "ice_break"

    with open(user_file, "r") as f:
        data = json.load(f)
        return data.get("relationship_stage", "ice_break")


def cleanup_old_sessions(days=30):
    """清理超过指定天数的旧会话数据"""
    ensure_dirs()
    now = datetime.now()
    cutoff = now.timestamp() - (days * 86400)
    cleaned = 0

    for session_file in SESSIONS_DIR.glob("*.json"):
        stat = session_file.stat()
        if stat.st_mtime < cutoff:
            session_file.unlink()
            cleaned += 1

    return cleaned


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    action = sys.argv[1]

    if action == "init-session":
        if len(sys.argv) < 3:
            print("Error: requires session-id")
            sys.exit(1)
        result = init_session(sys.argv[2])

    elif action == "get-stage":
        if len(sys.argv) < 3:
            print("Error: requires session-id")
            sys.exit(1)
        data = get_session_data(sys.argv[2])
        print(f"Stage: {data['relationship_stage']}")
        print(f"Interactions: {data['interaction_count']}")

    elif action == "increment":
        if len(sys.argv) < 3:
            print("Error: requires session-id")
            sys.exit(1)
        result = increment_interaction(sys.argv[2])
        print(f"Stage: {result['relationship_stage']}")
        print(f"Interactions: {result['interaction_count']}")

    elif action == "log-meme":
        if len(sys.argv) < 4:
            print("Error: requires session-id, template")
            sys.exit(1)
        log_meme_usage(sys.argv[2], sys.argv[3], " ".join(sys.argv[4:]))
        print("Meme usage logged")

    elif action == "get-stats":
        if len(sys.argv) < 3:
            print("Error: requires session-id")
            sys.exit(1)
        stats = get_stats(sys.argv[2])
        print(json.dumps(stats, indent=2, ensure_ascii=False))

    elif action == "cleanup":
        days = int(sys.argv[2]) if len(sys.argv) > 2 else 30
        cleaned = cleanup_old_sessions(days)
        print(f"Cleaned {cleaned} old session files (older than {days} days)")

    else:
        print(f"Unknown action: {action}")
        sys.exit(1)


if __name__ == "__main__":
    main()
