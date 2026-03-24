#!/usr/bin/env bash
#
# AI Pilot — One-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/manhpd98/ai-pilot/main/install.sh | bash
#
# Or with a target directory:
#   curl -fsSL ... | bash -s -- /path/to/your/project

set -euo pipefail

# ─────────────────────────────────────────────
# Colors & helpers
# ─────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()    { echo -e "${BLUE}ℹ${NC}  $1"; }
success() { echo -e "${GREEN}✅${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠️${NC}  $1"; }
error()   { echo -e "${RED}❌${NC} $1"; }

# ─────────────────────────────────────────────
# Banner
# ─────────────────────────────────────────────
echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║          🤖 AI Pilot Installer       ║${NC}"
echo -e "${CYAN}${BOLD}║    Multi-Agent Coding Workflow        ║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""

# ─────────────────────────────────────────────
# Determine target directory
# ─────────────────────────────────────────────
TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    error "Directory '$1' does not exist."
    exit 1
}

info "Target project: ${BOLD}$TARGET_DIR${NC}"

# ─────────────────────────────────────────────
# Check if .agent already exists
# ─────────────────────────────────────────────
if [ -d "$TARGET_DIR/.agent" ]; then
    warn ".agent/ directory already exists in this project."
    read -rp "   Overwrite? (y/N) " choice < /dev/tty
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        info "Aborted. No changes made."
        exit 0
    fi
    rm -rf "$TARGET_DIR/.agent"
fi

# ─────────────────────────────────────────────
# Download AI Pilot
# ─────────────────────────────────────────────
info "Downloading AI Pilot..."

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

if command -v git &>/dev/null; then
    git clone --quiet --depth 1 https://github.com/manhpd98/ai-pilot.git "$TEMP_DIR/ai-pilot" 2>/dev/null
elif command -v curl &>/dev/null; then
    curl -fsSL https://github.com/manhpd98/ai-pilot/archive/main.tar.gz | tar xz -C "$TEMP_DIR"
    mv "$TEMP_DIR/ai-pilot-main" "$TEMP_DIR/ai-pilot"
else
    error "Neither git nor curl found. Please install one of them."
    exit 1
fi

# ─────────────────────────────────────────────
# Copy .agent to project
# ─────────────────────────────────────────────
cp -r "$TEMP_DIR/ai-pilot/.agent" "$TARGET_DIR/.agent"
success "Installed .agent/ to $TARGET_DIR"

# ─────────────────────────────────────────────
# Copy optional resources (if user wants them)
# ─────────────────────────────────────────────
echo ""
read -rp "$(echo -e "${BLUE}ℹ${NC}  Also copy templates, examples, and docs? (y/N) ")" copy_extras < /dev/tty
if [[ "$copy_extras" =~ ^[Yy]$ ]]; then
    mkdir -p "$TARGET_DIR/ai-pilot-resources"
    cp -r "$TEMP_DIR/ai-pilot/templates" "$TARGET_DIR/ai-pilot-resources/" 2>/dev/null || true
    cp -r "$TEMP_DIR/ai-pilot/examples"  "$TARGET_DIR/ai-pilot-resources/" 2>/dev/null || true
    cp -r "$TEMP_DIR/ai-pilot/docs"      "$TARGET_DIR/ai-pilot-resources/" 2>/dev/null || true
    success "Copied resources to ai-pilot-resources/"
fi

# ─────────────────────────────────────────────
# Check AI Workers
# ─────────────────────────────────────────────
echo ""
info "Checking AI workers..."

WORKER_FOUND=false

if command -v claude &>/dev/null; then
    success "Claude Code found: $(which claude)"
    WORKER_FOUND=true
else
    warn "Claude Code not found"
    echo -e "   Install: ${CYAN}npm install -g @anthropic-ai/claude-code${NC}"
fi

if command -v opencode &>/dev/null; then
    success "OpenCode found: $(which opencode)"
    WORKER_FOUND=true
else
    warn "OpenCode not found"
    echo -e "   Install: ${CYAN}curl -fsSL https://opencode.ai/install | bash${NC}"
fi

if command -v aider &>/dev/null; then
    success "Aider found: $(which aider)"
    WORKER_FOUND=true
fi

if [ "$WORKER_FOUND" = false ]; then
    echo ""
    warn "No AI worker found. Install at least one:"
    echo -e "   ${CYAN}npm install -g @anthropic-ai/claude-code${NC}  (Claude Pro/Max required)"
    echo -e "   ${CYAN}curl -fsSL https://opencode.ai/install | bash${NC}  (Free)"
    echo -e "   ${CYAN}pip install aider-chat${NC}  (Free / BYO API key)"
fi

# ─────────────────────────────────────────────
# Done
# ─────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║       🎉 AI Pilot installed!         ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "  1. Open your project in VS Code with Antigravity"
echo -e "  2. Tell it: ${CYAN}\"Fix the login bug — delegate to Claude Code\"${NC}"
echo -e ""
echo -e "  📖 Docs:  ${CYAN}https://github.com/manhpd98/ai-pilot${NC}"
echo ""
