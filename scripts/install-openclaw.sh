#!/usr/bin/env bash
#
# generating-memes OpenClaw Skill Installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/geekjourneyx/meme-generator-skill/main/scripts/install-openclaw.sh | bash
#

set -e

REPO="geekjourneyx/meme-generator-skill"
SKILL_NAME="generating-memes"
INSTALL_DIR="${HOME}/.openclaw/skills/${SKILL_NAME}"
GITHUB_ARCHIVE="https://github.com/${REPO}/archive/refs/heads/main.tar.gz"
MEME_RELEASES_BASE="https://github.com/MemeCrafters/meme-generator-rs/releases/latest/download"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { printf "${BLUE}ℹ${NC} %s\n" "$1"; }
success() { printf "${GREEN}✓${NC} %s\n" "$1"; }
warn()    { printf "${YELLOW}⚠${NC} %s\n" "$1"; }
error()   { printf "${RED}✗${NC} %s\n" "$1" >&2; }

# Header
printf "\n"
printf "${BLUE}========================================${NC}\n"
printf "${BLUE}   Meme Generator OpenClaw Skill${NC}\n"
printf "${BLUE}========================================${NC}\n"
printf "\n"

# Check prerequisites
command -v curl &>/dev/null || command -v wget &>/dev/null || \
    error "需要 curl 或 wget / Need curl or wget"

# Check if OpenClaw is installed (optional warning)
if [[ ! -d "${HOME}/.openclaw" ]]; then
    warn "未检测到 OpenClaw 安装 / OpenClaw not detected"
    info "请先安装 OpenClaw: https://openclaw.ai/"
    printf "\n"
    read -p "仍要继续安装？/ Continue anyway? [y/N] " -n 1 -r
    printf "\n"
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 0
fi

# ============================================================================
# Install meme CLI if not present
# ============================================================================

install_meme_cli() {
    local os="$1"
    local arch="$2"
    local filename="$3"
    local install_cmd="$4"

    printf "\n"
    info "正在下载 meme CLI / Downloading meme CLI..."
    info "文件 / File: ${filename}"

    TEMP_DIR=$(mktemp -d)
    local zip_file="${TEMP_DIR}/meme-cli.zip"

    # Download
    if command -v curl &>/dev/null; then
        curl -fsSL "${MEME_RELEASES_BASE}/${filename}" -o "$zip_file" || {
            rm -rf "$TEMP_DIR"
            error "下载失败 / Download failed"
        }
    else
        wget -q "${MEME_RELEASES_BASE}/${filename}" -O "$zip_file" || {
            rm -rf "$TEMP_DIR"
            error "下载失败 / Download failed"
        }
    fi

    # Extract
    info "解压中 / Extracting..."
    unzip -q "$zip_file" -d "$TEMP_DIR" || {
        rm -rf "$TEMP_DIR"
        error "解压失败 / Extract failed"
    }

    # Install
    info "安装中 / Installing to /usr/local/bin/..."
    if eval "$install_cmd"; then
        success "meme CLI 安装成功 / meme CLI installed successfully"
        rm -rf "$TEMP_DIR"
        return 0
    else
        rm -rf "$TEMP_DIR"
        return 1
    fi
}

# Check if meme CLI is installed
if ! command -v meme &>/dev/null; then
    printf "\n"
    printf "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"
    printf "${YELLOW}  未检测到 meme CLI，正在自动安装...${NC}\n"
    printf "${YELLOW}  meme CLI not detected, installing...${NC}\n"
    printf "${YELLOW}════════════════════════════════════════════════════════════${NC}\n"

    # Detect platform
    OS="$(uname -s)"
    ARCH="$(uname -m)"

    # Map platform to filename
    FILENAME=""
    case "$OS" in
        Linux)
            case "$ARCH" in
                x86_64) FILENAME="meme-generator-cli-linux-x86_64.zip" ;;
                aarch64) FILENAME="meme-generator-cli-linux-aarch64.zip" ;;
                arm64) FILENAME="meme-generator-cli-linux-aarch64.zip" ;;
                *) FILENAME="" ;;
            esac
            ;;
        Darwin)
            case "$ARCH" in
                x86_64) FILENAME="meme-generator-cli-macos-x86_64.zip" ;;
                arm64|arm64e) FILENAME="meme-generator-cli-macos-aarch64.zip" ;;
                *) FILENAME="" ;;
            esac
            ;;
        MINGW*|MSYS*|CYGWIN*)
            case "$ARCH" in
                x86_64) FILENAME="meme-generator-cli-windows-x86_64.zip" ;;
                *) FILENAME="" ;;
            esac
            ;;
        *)
            FILENAME=""
            ;;
    esac

    if [[ -z "$FILENAME" ]]; then
        error "不支持的平台 / Unsupported platform: $OS $ARCH"
    fi

    # Try to install
    if install_meme_cli "$OS" "$ARCH" "$FILENAME" "sudo mv ${TEMP_DIR}/meme /usr/local/bin/ 2>/dev/null || mv ${TEMP_DIR}/meme /usr/local/bin/ 2>/dev/null"; then
        # Success
        :
    elif install_meme_cli "$OS" "$ARCH" "$FILENAME" "sudo mv ${TEMP_DIR}/meme /usr/local/bin/"; then
        # Success with sudo only
        :
    else
        # Failed - provide manual instructions
        printf "\n"
        error "自动安装失败，请手动安装 / Auto-install failed, please install manually:

  ${GREEN}# 下载 / Download${NC}
  curl -L ${MEME_RELEASES_BASE}/${FILENAME} -o meme-cli.zip

  ${GREEN}# 解压并安装 / Extract and install${NC}
  unzip meme-cli.zip
  chmod +x meme
  sudo mv meme /usr/local/bin/

  ${GREEN}# 下载模板资源 / Download templates${NC}
  meme download"
        exit 1
    fi
else
    # meme CLI exists - show version
    MEME_VERSION=$(meme --version 2>/dev/null || echo "unknown")
    success "检测到 meme CLI / meme CLI detected (version: $MEME_VERSION)"
fi

# Check if templates are downloaded
printf "\n"
info "检查模板资源 / Checking templates..."
if ! meme list &>/dev/null; then
    warn "模板资源未下载 / Templates not downloaded"
    info "正在下载模板资源 / Downloading templates..."
    info "这可能需要几分钟 / This may take a few minutes..."

    if meme download; then
        success "模板资源下载完成 / Templates downloaded"
    else
        warn "资源下载失败，请稍后手动运行: meme download"
        warn "Download failed, please run later: meme download"
    fi
else
    success "模板资源已就绪 / Templates ready"
fi

# ============================================================================
# Install skill
# ============================================================================

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

# Cleanup
rm -rf "$TEMP_DIR"

success "安装完成 / Installation complete!"

# Show usage instructions
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

printf "${YELLOW}热门模板 / Popular templates:${NC}\n"
printf "  • petpet  - 摸头/摸摸\n"
printf "  • slap    - 一巴掌\n"
printf "  • hug     - 抱抱\n"
printf "  • rub     - 贴贴\n"
printf "  • 5000choyen - 大小文字对比\n"
printf "\n"

printf "安装路径 / Installed to: ${GREEN}%s${NC}\n" "$INSTALL_DIR"
printf "项目地址 / GitHub: https://github.com/${REPO}\n"
printf "meme CLI: https://github.com/MemeCrafters/meme-generator-rs\n"
printf "OpenClaw: https://openclaw.ai/\n"
printf "\n"
printf "${GREEN}🎭 Happy Meme-ing!${NC}\n"
printf "\n"
