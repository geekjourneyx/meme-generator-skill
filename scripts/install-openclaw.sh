#!/usr/bin/env bash
#
# generating-memes OpenClaw Skill Installer
#
# Just copies skill files to ~/.openclaw/skills/generating-memes
# For ClawHub users: clawhub install generating-memes
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/geekjourneyx/meme-generator-skill/main/scripts/install-openclaw.sh | bash
#

set -e

REPO="geekjourneyx/meme-generator-skill"
SKILL_NAME="generating-memes"
INSTALL_DIR="${HOME}/.openclaw/skills/${SKILL_NAME}"
GITHUB_ARCHIVE="https://github.com/${REPO}/archive/refs/heads/main.tar.gz"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { printf "${BLUE}ℹ${NC} %s\n" "$1"; }
success() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn()    { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error()   { printf "${RED}✗${NC} %s\n" "$1" >&2; exit 1; }

# Header
printf "\n"
printf "${BLUE}========================================${NC}\n"
printf "${BLUE}   Meme Generator OpenClaw Skill${NC}\n"
printf "${BLUE}========================================${NC}\n"
printf "\n"

# Check for ClawHub first
if command -v clawhub &>/dev/null; then
    info "检测到 clawhub CLI / ClawHub CLI detected"
    printf "\n"
    printf "推荐使用 ClawHub 安装 / Recommend using ClawHub:\n"
    printf "  ${GREEN}clawhub install generating-memes${NC}\n"
    printf "\n"
    read -p "继续手动安装？/ Continue manual install? [y/N] " -n 1 -r
    printf "\n"
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
fi

# Check prerequisites
command -v curl &>/dev/null || command -v wget &>/dev/null || \
    error "需要 curl 或 wget / Need curl or wget"

# Check if OpenClaw is installed (optional warning)
if [[ ! -d "${HOME}/.openclaw" ]]; then
    warn "未检测到 OpenClaw 安装 / OpenClaw not detected"
    info "请先安装 OpenClaw: https://openclaw.ai/"
    info "Install OpenClaw first: https://openclaw.ai/"
    printf "\n"
    read -p "仍要继续安装技能？/ Continue installing skill anyway? [y/N] " -n 1 -r
    printf "\n"
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
fi

# Check if meme CLI is installed
if ! command -v meme &>/dev/null; then
    printf "\n"
    printf "${RED}════════════════════════════════════════════════════════════${NC}\n"
    printf "${RED}  ⚠️  未检测到 meme CLI / meme CLI not detected${NC}\n"
    printf "${RED}════════════════════════════════════════════════════════════${NC}\n"
    printf "\n"

    # Detect platform
    OS="$(uname -s)"
    ARCH="$(uname -m)"

    printf "${YELLOW}检测到平台 / Detected platform:${NC} $OS $ARCH\n"
    printf "\n"

    printf "${GREEN}📥 安装方法 / Installation methods:${NC}\n"
    printf "\n"

    # Method 1: Download from GitHub Releases
    printf "${BLUE}方法 1 / Method 1: 从 GitHub Releases 下载${NC} (推荐/recommended)\n"
    printf "  ${YELLOW}→ 访问 / Visit:${NC} https://github.com/MemeCrafters/meme-generator-rs/releases\n"
    printf "  ${YELLOW}→ 下载适合你系统的版本 / Download for your platform:${NC}\n"
    printf "     • Linux x86_64:   meme-generator-cli-linux-x86_64.zip\n"
    printf "     • Linux ARM64:    meme-generator-cli-linux-aarch64.zip\n"
    printf "     • macOS x86_64:   meme-generator-cli-macos-x86_64.zip\n"
    printf "     • macOS ARM64:    meme-generator-cli-macos-aarch64.zip\n"
    printf "     • Windows x86_64: meme-generator-cli-windows-x86_64.zip\n"
    printf "     • Android ARM64:  meme-generator-cli-android-aarch64.zip\n"
    printf "\n"
    printf "  ${GREEN}# 下载后解压并安装 / After download, extract and install:${NC}\n"
    printf "  ${GREEN}unzip meme-generator-cli-*.zip${NC}\n"
    printf "  ${GREEN}chmod +x meme && sudo mv meme /usr/local/bin/${NC}\n"
    printf "  ${GREEN}meme download${NC}\n"
    printf "\n"

    # Method 2: One-line download (Linux x86_64)
    printf "${BLUE}方法 2 / Method 2: 一键下载 / One-line download${NC} (Linux x86_64)\n"
    printf "  ${GREEN}curl -L https://github.com/MemeCrafters/meme-generator-rs/releases/latest/download/meme-generator-cli-linux-x86_64.zip -o meme-cli.zip${NC}\n"
    printf "  ${GREEN}unzip meme-cli.zip && chmod +x meme && sudo mv meme /usr/local/bin/${NC}\n"
    printf "  ${GREEN}rm meme-cli.zip && meme download${NC}\n"
    printf "\n"

    # Method 3: Cargo
    printf "${BLUE}方法 3 / Method 3: 使用 Cargo / Using Cargo${NC} (需要 Rust/needs Rust)\n"
    printf "  ${GREEN}cargo install meme-generator${NC}\n"
    printf "  ${GREEN}meme download${NC}\n"
    printf "\n"

    printf "${YELLOW}─────────────────────────────────────────────────────────${NC}\n"
    printf "${YELLOW}📦 Releases 页面 / Releases:${NC} https://github.com/MemeCrafters/meme-generator-rs/releases\n"
    printf "${YELLOW}📚 项目仓库 / Repository:${NC} https://github.com/MemeCrafters/meme-generator-rs\n"
    printf "${YELLOW}─────────────────────────────────────────────────────────${NC}\n"
    printf "\n"

    printf "${RED}⚠️  注意 / Attention:${NC}\n"
    printf "  • 安装 skill 后仍需安装 meme CLI 才能使用\n"
    printf "  • You still need to install meme CLI after installing this skill\n"
    printf "\n"

    read -p "继续安装技能？/ Continue installing skill anyway? [y/N] " -n 1 -r
    printf "\n"
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
else
    # meme is installed - show version
    MEME_VERSION=$(meme --version 2>/dev/null || echo "unknown")
    success "检测到 meme CLI / meme CLI detected (version: $MEME_VERSION)"
fi

# Handle existing installation
if [[ -d "$INSTALL_DIR" ]]; then
    warn "已存在安装 / Existing installation: $INSTALL_DIR"
    read -p "覆盖？/ Overwrite? [y/N] " -n 1 -r
    printf "\n"
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
    rm -rf "$INSTALL_DIR"
fi

# Download and extract
info "下载技能文件 / Downloading skill files..."

TEMP_DIR=$(mktemp -d)
ARCHIVE="${TEMP_DIR}/repo.tar.gz"

if command -v curl &>/dev/null; then
    curl -fsSL "$GITHUB_ARCHIVE" -o "$ARCHIVE"
else
    wget -q "$GITHUB_ARCHIVE" -O "$ARCHIVE"
fi

tar -xzf "$ARCHIVE" -C "$TEMP_DIR"

# Find extracted directory
EXTRACTED=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "meme-generator-skill-*" | head -n 1)
[[ -z "$EXTRACTED" ]] && error "下载失败 / Download failed"

# Install
mkdir -p "$INSTALL_DIR"
cp -r "${EXTRACTED}/skills/generating-memes/"* "$INSTALL_DIR/"
chmod +x "${INSTALL_DIR}/scripts/"*.sh 2>/dev/null || true

# Cleanup
rm -rf "$TEMP_DIR"

success "安装完成 / Installation complete!"

# Show configuration instructions
printf "\n"
printf "${BLUE}========================================${NC}\n"
printf "${BLUE}   使用说明 / Usage${NC}\n"
printf "${BLUE}========================================${NC}\n"
printf "\n"

printf "${GREEN}测试生成表情包 / Test meme generation:${NC}\n"
printf "\n"
printf "  # 列出所有模板\n"
printf "  ${BLUE}meme list${NC}\n"
printf "\n"
printf "  # 搜索模板\n"
printf "  ${BLUE}meme search pet${NC}\n"
printf "\n"
printf "  # 生成表情包\n"
printf "  ${BLUE}meme generate petpet --images photo.jpg > petpet.gif${NC}\n"
printf "\n"
printf "  # 使用包装脚本\n"
printf "  ${BLUE}~/.openclaw/skills/generating-memes/scripts/meme_wrapper.sh petpet photo.jpg${NC}\n"
printf "\n"

printf "${YELLOW}热门模板 / Popular templates:${NC}\n"
printf "  • petpet  - 摸头/摸摸\n"
printf "  • slap    - 一巴掌\n"
printf "  • hug     - 抱抱\n"
printf "  • rub     - 贴贴\n"
printf "  • 5000choyen - 大小文字对比\n"
printf "\n"

printf "安装路径 / Installed to: ${GREEN}%s${NC}\n" "$INSTALL_DIR"
printf "项目地址 / GitHub: https://github.com/${REPO}\n"
printf "meme CLI: https://github.com/MemeCrafters/meme-generator\n"
printf "OpenClaw: https://openclaw.ai/\n"
printf "ClawHub: https://clawhub.ai/\n"
printf "\n"
printf "${GREEN}🎭 Happy Meme-ing!${NC}\n"
printf "\n"
