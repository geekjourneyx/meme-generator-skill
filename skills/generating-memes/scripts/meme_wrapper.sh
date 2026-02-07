#!/usr/bin/env bash
#
# meme_wrapper.sh - Simplified meme generation wrapper
#
# Usage: meme_wrapper.sh <template> <input_image> [output_file]
#
# Examples:
#   meme_wrapper.sh petpet avatar.jpg output.gif
#   meme_wrapper.sh slap friend.jpg
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if meme binary exists
check_meme_binary() {
    if ! command -v meme &> /dev/null; then
        echo -e "${RED}Error: 'meme' command not found${NC}" >&2
        echo "" >&2
        echo "The meme CLI is not installed. To install:" >&2
        echo "" >&2
        echo "  # Download from GitHub" >&2
        echo "  curl -L https://github.com/MemeCrafters/meme-generator/releases/latest/download/meme-x86_64-unknown-linux-gnu -o meme" >&2
        echo "  chmod +x meme" >&2
        echo "  sudo mv meme /usr/local/bin/" >&2
        echo "" >&2
        echo "  # Download required resources" >&2
        echo "  meme download" >&2
        echo "" >&2
        echo "GitHub: https://github.com/MemeCrafters/meme-generator" >&2
        exit 1
    fi
}

# Validate template exists
validate_template() {
    local template="$1"

    if ! meme list 2>/dev/null | grep -q "^${template} "; then
        echo -e "${YELLOW}Warning: Template '${template}' not found in list${NC}" >&2
        echo "" >&2
        echo "Similar templates:" >&2
        meme search "$template" 2>/dev/null | head -10 >&2
        echo "" >&2
        echo "Use 'meme list' to see all templates" >&2
        echo "Use 'meme search <keyword>' to search" >&2
        exit 1
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 <template> <input_image> [output_file]" >&2
    echo "" >&2
    echo "Arguments:" >&2
    echo "  template      Meme template name (e.g., petpet, slap, hug)" >&2
    echo "  input_image   Path to input image file" >&2
    echo "  output_file   Optional output filename (default: meme_output.gif)" >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "  $0 petpet avatar.jpg output.gif" >&2
    echo "  $0 slap friend.jpg" >&2
    echo "" >&2
    echo "Common templates:" >&2
    echo "  petpet, slap, hug, rub, pat, kiss, pinch" >&2
    echo "" >&2
    echo "See all templates: meme list" >&2
    exit 1
}

# Main function
main() {
    # Parse arguments
    if [[ $# -lt 2 ]]; then
        show_usage
    fi

    local TEMPLATE="$1"
    local INPUT="$2"
    local OUTPUT="${3:-meme_output.gif}"

    # Check binary
    check_meme_binary

    # Validate input image exists
    if [[ ! -f "$INPUT" ]]; then
        echo -e "${RED}Error: Input image not found: $INPUT${NC}" >&2
        exit 1
    fi

    # Validate template
    validate_template "$TEMPLATE"

    # Check template info to warn about requirements
    local template_info
    template_info=$(meme info "$TEMPLATE" 2>/dev/null || true)

    # Warn if template requires text
    if echo "$template_info" | grep -q "需要文字数目：[1-9]"; then
        echo -e "${YELLOW}Warning: Template '$TEMPLATE' requires text arguments${NC}" >&2
        echo "This wrapper only supports image-based templates." >&2
        echo "Use the full command instead:" >&2
        echo "  meme generate $TEMPLATE --images $INPUT --texts \"text1\" \"text2\"" >&2
        exit 1
    fi

    # Generate meme
    echo -e "${GREEN}Generating $TEMPLATE meme from $INPUT...${NC}"

    # Create output directory if needed
    local output_dir
    output_dir=$(dirname "$OUTPUT")
    if [[ "$output_dir" != "." ]] && [[ ! -d "$output_dir" ]]; then
        mkdir -p "$output_dir"
    fi

    # Generate with error handling
    if ! meme generate "$TEMPLATE" --images "$INPUT" > "$OUTPUT" 2>/dev/null; then
        echo -e "${RED}Error: Generation failed${NC}" >&2
        echo "" >&2
        echo "Check template requirements:" >&2
        echo "  meme info $TEMPLATE" >&2
        exit 1
    fi

    # Success - output with MEDIA: prefix for OpenClaw
    local full_path
    full_path=$(realpath "$OUTPUT")

    echo -e "${GREEN}Meme saved to: $full_path${NC}"
    echo "MEDIA:$full_path"
}

# Run main
main "$@"
