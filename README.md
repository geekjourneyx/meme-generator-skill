# Generating Memes Skill

An OpenClaw skill for creating memes using the [meme CLI](https://github.com/MemeCrafters/meme-generator) with 298+ templates.

## Features

- **298+ meme templates** including popular formats like petpet, slap, hug, rub, and more
- **Search and discover** templates by keyword
- **Preview templates** before generation
- **Text-based and image-based** meme support
- **Simplified wrapper script** for easy generation
- **Friendly error handling** with clear installation instructions

## Installation

### Quick Install (One-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/geekjourneyx/meme-generator-skill/main/scripts/install-openclaw.sh | bash
```

This installer will:
- ✅ Check if `meme` CLI is installed (guide you if not)
- ✅ Download and install the skill to `~/.openclaw/skills/`
- ✅ Set proper permissions for scripts

### Prerequisites

The skill requires the **meme CLI** tool. If not installed, the installer will guide you.

**Install meme CLI:**

1. **Download from GitHub Releases** (推荐/recommended)

   Visit: https://github.com/MemeCrafters/meme-generator-rs/releases

   | Platform | File Name |
   |----------|-----------|
   | Linux x86_64 | `meme-generator-cli-linux-x86_64.zip` |
   | Linux ARM64 | `meme-generator-cli-linux-aarch64.zip` |
   | macOS x86_64 | `meme-generator-cli-macos-x86_64.zip` |
   | macOS ARM64 | `meme-generator-cli-macos-aarch64.zip` |
   | Windows x86_64 | `meme-generator-cli-windows-x86_64.zip` |
   | Android ARM64 | `meme-generator-cli-android-aarch64.zip` |

   After download:
   ```bash
   # 解压
   unzip meme-generator-cli-*.zip

   # 安装
   chmod +x meme && sudo mv meme /usr/local/bin/

   # 下载资源
   meme download
   ```

2. **One-line install** (Linux x86_64):
   ```bash
   curl -L https://github.com/MemeCrafters/meme-generator-rs/releases/latest/download/meme-generator-cli-linux-x86_64.zip -o meme-cli.zip
   unzip meme-cli.zip && chmod +x meme && sudo mv meme /usr/local/bin/
   rm meme-cli.zip && meme download
   ```

3. **Using Cargo** (需要 Rust):
   ```bash
   cargo install meme-generator
   meme download
   ```

**GitHub**: https://github.com/MemeCrafters/meme-generator-rs

### Alternative Installation Methods

#### Method 1: npx skills (Universal - Recommended)

The **npx skills** CLI supports 35+ AI coding agents including Claude Code, Cursor, Codex, OpenCode, and OpenClaw.

```bash
# Install to all supported agents (auto-detected)
npx skills add geekjourneyx/meme-generator-skill

# Install to specific agents only
npx skills add geekjourneyx/meme-generator-skill -a claude-code -a cursor -a openclaw

# List available skills in the repository
npx skills add geekjourneyx/meme-generator-skill --list

# Install globally (available across all projects)
npx skills add geekjourneyx/meme-generator-skill -g
```

**Supported Agents**: Claude Code, Cursor, Codex, OpenCode, OpenClaw, Cline, Roo Code, Windsurf, GitHub Copilot, and 25+ more.

For more information: https://github.com/vercel-labs/skills

---

#### Method 2: ClawHub (OpenClaw)

```bash
clawhub install generating-memes
```

---

#### Method 3: Manual Installation

```bash
# Copy to OpenClaw skills directory
cp -r generating-memes ~/.openclaw/skills/

# Or copy to Claude Code skills directory
cp -r generating-memes ~/.claude/skills/
```

## Usage

### In OpenClaw

Simply ask the assistant to create memes:

- "Make a petpet meme from this photo"
- "Create a slap meme with my friend's picture"
- "Generate a hug meme"
- "Make a 5000choyen meme with text"

### Command Line

#### Basic Commands

```bash
# List all available templates
meme list

# Search templates by keyword
meme search "pet"
meme search "slap"
meme search "hug"

# Generate a simple meme
meme generate petpet --images avatar.jpg > petpet.gif

# Generate a text-based meme
meme generate 5000choyen --texts "IMPORTANT" "small text"

# Check template requirements
meme info petpet

# Preview a template
meme preview petpet
```

#### Using the Wrapper Script

The included wrapper script simplifies meme generation:

```bash
# Basic usage
~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet avatar.jpg output.gif

# With default output (meme_output.gif)
~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet avatar.jpg
```

## Popular Templates

| Template | Description | Type |
|----------|-------------|------|
| `petpet` | Petting animation (摸/摸摸) | Image |
| `slap` | Slapping (一巴掌) | Image |
| `hug` | Hugging (抱/抱抱) | Image |
| `rub` | Nuzzling (贴/贴贴) | Image |
| `pat` | Patting (拍) | Image |
| `kiss` | Kissing (亲/亲亲) | Image |
| `pinch` | Pinching (捏/捏脸) | Image |
| `5000choyen` | Big/small text contrast | Text |
| `always` | "Always" format meme | Text |
| `shock` | Shocked reaction (震惊) | Text |
| `good_news` | Good news header (喜报) | Text |
| `bad_news` | Bad news header (悲报) | Text |
| `applaud` | Applause (鼓掌) | Image |
| `stare_at_you` | Staring at you (盯着你) | Image |

[See full template list](references/templates.md)

## Examples

### Petpet Meme

```bash
meme generate petpet --images photo.jpg > petpet.gif
```

### Slap Meme

```bash
meme generate slap --images target.jpg > slap.gif
```

### Hug Meme

```bash
meme generate hug --images friend.jpg > hug.gif
```

### Text Meme (5000choyen)

```bash
meme generate 5000choyen --texts "IMPORTANT" "ignore this"
```

### YouTube Style

```bash
meme generate youtube --texts "Video Title" "Channel Name"
```

### With Wrapper Script

```bash
~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet input.jpg output.gif
```

## Common Workflows

### Discovery Workflow

```bash
# 1. Search for a template
meme search "pet"

# 2. Preview the template
meme preview petpet

# 3. Check requirements
meme info petpet

# 4. Generate the meme
meme generate petpet --images photo.jpg > output.gif
```

### Batch Processing

```bash
# Create petpet variants for all images
for img in *.jpg; do
    meme generate petpet --images "$img" > "petpet_$(basename $img .jpg).gif"
done
```

## File Structure

```
generating-memes/
├── SKILL.md              # Main skill file
├── README.md             # This file
├── scripts/
│   └── meme_wrapper.sh   # Simplified generation wrapper
└── references/
    ├── templates.md      # Full template list (298 templates)
    └── examples.md       # Usage examples and workflows
```

## Troubleshooting

### "meme: command not found"

The meme CLI is not installed. See [Installation](#installation) above.

### Template Not Found

```bash
# Verify template name
meme list | grep <template>

# Search for similar templates
meme search <keyword>
```

### Missing Resources

```bash
# Download required template assets
meme download
```

### Network Issues (Download Failed)

If `meme download` fails with connection timeout:

```bash
# Error: Connection timed out (os error 110)
# The CLI tries to connect to cdn.jsdelivr.net

# Try using a proxy or VPN
export https_proxy=http://127.0.0.1:7890
meme download

# Or download resources manually from GitHub releases:
# https://github.com/MemeCrafters/meme-generator/releases
```

**Note**: Some templates may work without downloading resources if the assets are built-in.

### Permission Issues

```bash
# Make wrapper script executable
chmod +x ~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh
```

## Resources

- [meme CLI GitHub](https://github.com/MemeCrafters/meme-generator) - Source code and documentation
- [Full Template List](references/templates.md) - All 298 templates categorized
- [Usage Examples](references/examples.md) - Detailed examples and workflows

## License

MIT License

## Contributing

Contributions welcome! Feel free to submit issues and pull requests.

---

## 💰 Buy Me A Coffee

如果该项目帮助了您，请作者喝杯咖啡吧 ☕️

### WeChat

<img src="https://raw.githubusercontent.com/geekjourneyx/awesome-developer-go-sail/main/docs/assets/wechat-reward-code.jpg" alt="微信打赏码" width="200" />

---

## 🧑‍💻 Author

- **Author**: geekjourneyx
- **X (Twitter)**: https://x.com/seekjourney
- **公众号**: 极客杰尼

关注公众号，获取更多 AI 编程、AI 工具与 AI 出海建站的实战分享：

<p align="center">
<img src="https://raw.githubusercontent.com/geekjourneyx/awesome-developer-go-sail/main/docs/assets/qrcode.jpg" alt="公众号：极客杰尼" width="180" />
</p>

---

**Made with 🎭 for OpenClaw**
