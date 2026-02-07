# Meme Generator Skill - 项目记忆

## 项目概述

这是一个 OpenClaw 技能（Skill），用于生成中文表情包，基于 [meme-generator-rs](https://github.com/MemeCrafters/meme-generator-rs) CLI 工具。

## 项目信息

- **仓库名**: `geekjourneyx/meme-generator-skill`
- **Skill 名称**: `generating-memes`
- **GitHub**: https://github.com/geekjourneyx/meme-generator-skill
- **上游项目**: https://github.com/MemeCrafters/meme-generator-rs

## 目录结构

```
meme-generator-skill/
├── skills/
│   └── generating-memes/          # 表情生成 skill
│       ├── SKILL.md               # 主技能文件
│       └── references/
│           ├── templates.md       # 298 模板分类列表
│           └── examples.md        # 使用示例
├── scripts/
│   └── install-openclaw.sh        # 一键安装脚本
├── README.md                      # 项目文档（中文）
├── CLAUDE.md                      # 本文件（项目记忆）
├── CHANGELOG.md                   # 版本变更记录
└── meme.md                        # CLI 文档参考
```

## 开发规范

### 提交代码工作流

每次提交代码前必须严格执行以下检查：

#### 1. 语法检查
```bash
# 检查 Shell 脚本语法
bash -n scripts/install-openclaw.sh
bash -n generating-memes/scripts/meme_wrapper.sh

# 检查 YAML frontmatter 有效性
# 确保 SKILL.md 的 frontmatter 格式正确
```

#### 2. 代码与文档一致性检查

| 检查项 | 说明 |
|--------|------|
| 文件路径 | 脚本中的路径与实际目录结构一致 |
| 命令示例 | 文档中的命令示例可以实际执行 |
| 版本信息 | releases 文件名与上游一致 |
| 链接有效 | 所有 URL 可以访问 |

#### 3. 文档质量检查

| 检查项 | 说明 |
|--------|------|
| YAML frontmatter | name 符合规范，description 第三人称 |
| SKILL.md 行数 | 保持在 500 行以内 |
| 渐进式披露 | 详细内容在 references/ 中 |
| 中英文双语 | 关键提示提供双语 |
| 排版格式 | Markdown 格式规范，表格对齐 |

#### 4. SKILL.md 意图识别检查

关键检查点：
- `description` 是否能准确触发技能
- 包含足够的关键词（meme, petpet, slap, hug, rub 等）
- 说明何时使用该技能
- 第三人称描述

当前 description：
```
Creates memes using the meme CLI with 298 templates. Generates, previews, searches, and lists meme templates. Use when user asks to make memes, create memes, generate memes, or mentions specific meme names like petpet, slap, hug, rub, etc.
```

#### 5. 提交前测试

```bash
# 测试安装脚本
bash scripts/install-openclaw.sh --help 2>/dev/null || echo "Syntax OK"

# 验证 SKILL.md frontmatter
head -25 generating-memes/SKILL.md

# 检查文件完整性
find generating-memes -type f | sort
```

### Git 提交规范

#### 提交信息格式

```
<type>: <subject>

<body>

<footer>
```

**类型 (type):**
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具链相关

**示例:**
```
feat: add Android platform support to installation guide

- Add Android ARM64 to platform list
- Update download instructions for .zip files
- Add installation examples for Android

Related to: https://github.com/MemeCrafters/meme-generator-rs/releases
```

#### 提交注意事项

1. ❌ **不要**在提交信息中包含 `Co-Authored-By: Claude`
2. ❌ **不要**包含 claude 相关的邮件地址
3. ✅ 使用清晰简洁的提交信息
4. ✅ 一个提交只做一件事
5. ✅ 提交前确保通过所有检查

### 版本发布流程

1. 更新 `CHANGELOG.md`
2. 更新版本号（如有需要）
3. 创建 git tag:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   ```
4. 推送标签:
   ```bash
   git push origin main --tags
   ```
5. 创建 GitHub Release

## 重要链接

### 上游项目
- Releases: https://github.com/MemeCrafters/meme-generator-rs/releases
- Repository: https://github.com/MemeCrafters/meme-generator-rs

### 相关资源
- OpenClaw: https://openclaw.ai/
- ClawHub: https://clawhub.ai/
- Skill 最佳实践: `/root/skill-rules/SKILL-RULE.md`

## 常用命令

```bash
# 检查 SKILL.md 行数
wc -l generating-memes/SKILL.md

# 验证 Shell 脚本语法
bash -n scripts/*.sh
bash -n generating-memes/scripts/*.sh

# 测试 meme CLI
meme --version
meme list | head -20
meme info petpet
```

## 注意事项

1. **网络问题**: `meme download` 可能因网络问题失败，已在文档中添加故障排除
2. **平台支持**: 上游提供 Linux/macOS/Windows/Android 多平台支持
3. **文件格式**: Releases 文件为 .zip 格式，需要解压
4. **依赖检查**: Skill 通过 `requires.bins: ["meme"]` 检查依赖

---

## Skills 概述

### generating-memes (表情生成)

- **功能**: 调用 meme CLI 生成表情包
- **触发**: 用户要求制作/生成表情包
- **依赖**: meme CLI
- **文件**: `skills/generating-memes/SKILL.md`
