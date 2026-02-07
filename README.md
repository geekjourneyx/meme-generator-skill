# 表情包生成技能 (Meme Generator Skill)

一个用于 OpenClaw 的技能，基于 [meme CLI](https://github.com/MemeCrafters/meme-generator-rs) 支持 298+ 种表情包模板。

## 特性

- **298+ 表情包模板** 包括热门格式如 petpet、slap、hug、rub 等
- **搜索和发现** 按关键词搜索模板
- **预览模板** 生成前预览效果
- **图片和文字** 支持图片和文字类表情包

## 安装

### 快速安装（一键）

```bash
curl -fsSL https://raw.githubusercontent.com/geekjourneyx/meme-generator-skill/main/scripts/install-openclaw.sh | bash
```

安装程序将：
- ✅ 检查 `meme` CLI 是否已安装（未安装会引导你）
- ✅ 下载并安装技能到 `~/.openclaw/skills/`
- ✅ 设置脚本执行权限

### 前置要求

本技能需要 **meme CLI** 工具。如果未安装，安装程序会引导你。

**安装 meme CLI：**

1. **从 GitHub Releases 下载**（推荐）

   访问：https://github.com/MemeCrafters/meme-generator-rs/releases

   | 平台 | 文件名 |
   |----------|-----------|
   | Linux x86_64 | `meme-generator-cli-linux-x86_64.zip` |
   | Linux ARM64 | `meme-generator-cli-linux-aarch64.zip` |
   | macOS x86_64 | `meme-generator-cli-macos-x86_64.zip` |
   | macOS ARM64 | `meme-generator-cli-macos-aarch64.zip` |
   | Windows x86_64 | `meme-generator-cli-windows-x86_64.zip` |
   | Android ARM64 | `meme-generator-cli-android-aarch64.zip` |

   下载后执行：
   ```bash
   # 解压
   unzip meme-generator-cli-*.zip

   # 安装
   chmod +x meme && sudo mv meme /usr/local/bin/

   # 下载资源
   meme download
   ```

2. **一键安装**（Linux x86_64）：
   ```bash
   curl -L https://github.com/MemeCrafters/meme-generator-rs/releases/latest/download/meme-generator-cli-linux-x86_64.zip -o meme-cli.zip
   unzip meme-cli.zip && chmod +x meme && sudo mv meme /usr/local/bin/
   rm meme-cli.zip && meme download
   ```

3. **使用 Cargo**（需要 Rust）：
   ```bash
   cargo install meme-generator
   meme download
   ```

**GitHub**: https://github.com/MemeCrafters/meme-generator-rs

### 其他安装方式

#### 方式 1: npx skills（通用 - 推荐）

**npx skills** CLI 支持 35+ 种 AI 编码工具，包括 Claude Code、Cursor、Codex、OpenCode 和 OpenClaw。

```bash
# 安装到所有支持的 agent（自动检测）
npx skills add geekjourneyx/meme-generator-skill

# 只安装到指定的 agent
npx skills add geekjourneyx/meme-generator-skill -a claude-code -a cursor -a openclaw

# 查看仓库中可用的 skills
npx skills add geekjourneyx/meme-generator-skill --list

# 全局安装（所有项目可用）
npx skills add geekjourneyx/meme-generator-skill -g
```

**支持的 Agent**: Claude Code、Cursor、Codex、OpenCode、OpenClaw、Cline、Roo Code、Windsurf、GitHub Copilot 和 25+ 更多。

更多信息：https://github.com/vercel-labs/skills

---

#### 方式 2: ClawHub（OpenClaw）

```bash
clawhub install generating-memes
```

---

#### 方式 3: 手动安装

```bash
# 复制到 OpenClaw skills 目录
cp -r skills/generating-memes ~/.openclaw/skills/

# 或复制到 Claude Code skills 目录
cp -r skills/generating-memes ~/.claude/skills/
```

## 使用方法

### 在 OpenClaw 中

直接让助手创建表情包：

- "用这张照片做个 petpet 表情包"
- "用我朋友的照片做个 slap 表情包"
- "生成一个 hug 表情包"
- "做个 5000choyen 文字表情包"

### 命令行

#### 基础命令

```bash
# 列出所有可用模板
meme list

# 按关键词搜索模板
meme search "pet"
meme search "slap"
meme search "hug"

# 生成表情包
meme generate petpet --images avatar.jpg > petpet.gif

# 生成文字类表情包
meme generate 5000choyen --texts "大字" "小字"

# 查看模板要求
meme info petpet

# 预览模板
meme preview petpet
```

#### 使用包装脚本

内置的包装脚本简化了表情包生成：

```bash
# 基础用法
~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet avatar.jpg output.gif

# 使用默认输出文件名 (meme_output.gif)
~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet avatar.jpg
```

## 热门模板

| 模板 | 描述 | 类型 |
|----------|-------------|------|
| `petpet` | 摸头动画 | 图片 |
| `slap` | 一巴掌 | 图片 |
| `hug` | 抱抱 | 图片 |
| `rub` | 贴贴 | 图片 |
| `pat` | 拍头 | 图片 |
| `kiss` | 亲亲 | 图片 |
| `pinch` | 捏脸 | 图片 |
| `5000choyen` | 大小文字对比 | 文字 |
| `always` | "一直" 格式 | 文字 |
| `shock` | 震惊 | 文字 |
| `good_news` | 喜报 | 文字 |
| `bad_news` | 悲报 | 文字 |
| `applaud` | 鼓掌 | 图片 |
| `stare_at_you` | 盯着你 | 图片 |

[查看完整模板列表](skills/generating-memes/references/templates.md)

## 使用示例

### Petpet 摸头

```bash
meme generate petpet --images photo.jpg > petpet.gif
```

### Slap 一巴掌

```bash
meme generate slap --images target.jpg > slap.gif
```

### Hug 抱抱

```bash
meme generate hug --images friend.jpg > hug.gif
```

### 5000choyen 大小字

```bash
meme generate 5000choyen --texts "重要" "忽略"
```

### YouTube 风格

```bash
meme generate youtube --texts "视频标题" "频道名称"
```

### 使用包装脚本

```bash
~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet input.jpg output.gif
```

## 常用工作流

### 发现工作流

```bash
# 1. 搜索模板
meme search "pet"

# 2. 预览模板
meme preview petpet

# 3. 查看要求
meme info petpet

# 4. 生成表情包
meme generate petpet --images photo.jpg > output.gif
```

### 批量处理

```bash
# 为所有图片生成 petpet 变体
for img in *.jpg; do
    meme generate petpet --images "$img" > "petpet_$(basename $img .jpg).gif"
done
```

## 目录结构

```
meme-generator-skill/
├── skills/                        # 技能根目录
│   └── generating-memes/          # Skill 主目录
│       ├── SKILL.md               # 主技能文件
│       ├── scripts/
│       │   └── meme_wrapper.sh    # 生成包装脚本
│       └── references/
│           ├── templates.md       # 完整模板列表（298 个）
│           └── examples.md        # 使用示例和工作流
├── scripts/                       # 项目脚本
│   └── install-openclaw.sh        # 一键安装脚本
├── README.md                      # 本文件
├── CHANGELOG.md                   # 版本记录
└── CLAUDE.md                      # 项目记忆
```

## 故障排除

### "meme: command not found"

meme CLI 未安装。见上方 [安装](#安装) 说明。

### 模板未找到

```bash
# 验证模板名称
meme list | grep <template>

# 搜索相似模板
meme search <keyword>
```

### 缺少资源

```bash
# 下载所需的模板资源
meme download
```

### 网络问题（下载失败）

如果 `meme download` 遇到连接超时：

```bash
# 错误：Connection timed out (os error 110)
# CLI 尝试连接 cdn.jsdelivr.net 失败

# 解决方案：从 GitHub releases 手动下载资源包
# https://github.com/MemeCrafters/meme-generator-rs/releases
```

**注意**: 某些模板可能使用内置资源，无需下载即可使用。

### 权限问题

```bash
# 为包装脚本添加执行权限
chmod +x ~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh
```

## 资源链接

- [meme CLI GitHub](https://github.com/MemeCrafters/meme-generator-rs) - 源码和文档
- [完整模板列表](skills/generating-memes/references/templates.md) - 所有 298 个模板分类
- [使用示例](skills/generating-memes/references/examples.md) - 详细示例和工作流

## 许可证

MIT License

## 贡献

欢迎贡献！欢迎提交 Issue 和 Pull Request。

---

## 💰 打赏 Buy Me A Coffee

如果该项目帮助了您，请作者喝杯咖啡吧 ☕️

### 微信打赏

<img src="https://raw.githubusercontent.com/geekjourneyx/awesome-developer-go-sail/main/docs/assets/wechat-reward-code.jpg" alt="微信打赏码" width="200" />

---

## 🧑‍💻 作者

- **作者**: geekjourneyx
- **X (Twitter)**: https://x.com/seekjourney
- **公众号**: 极客杰尼

关注公众号，获取更多 AI 编程、AI 工具与 AI 出海建站的实战分享：

<p align="center">
<img src="https://raw.githubusercontent.com/geekjourneyx/awesome-developer-go-sail/main/docs/assets/qrcode.jpg" alt="公众号：极客杰尼" width="180" />
</p>

---

**Made with 🎭 for OpenClaw**
