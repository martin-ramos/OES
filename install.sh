#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# OES Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/martin-ramos/OES/main/install.sh | bash
# Or:    bash install.sh  (from inside a cloned OES repo)
# ─────────────────────────────────────────────

OES_REPO="https://github.com/martin-ramos/OES.git"
PROJECT_DIR="$(pwd)"
TMP_DIR=""

# ── Colors ────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
RESET='\033[0m'

info()    { echo -e "${CYAN}[OES]${RESET} $*"; }
success() { echo -e "${GREEN}[OES]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[OES]${RESET} $*"; }
error()   { echo -e "${RED}[OES]${RESET} $*" >&2; }
header()  { echo -e "\n${BOLD}$*${RESET}"; }

# ── Cleanup ───────────────────────────────────
cleanup() {
  if [[ -n "$TMP_DIR" && -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
  fi
}
trap cleanup EXIT

# ── Resolve OES source ────────────────────────
resolve_oes_source() {
  # If running from inside the OES repo, use it directly
  if [[ -f "$PROJECT_DIR/VERSION" && -d "$PROJECT_DIR/.claude" && -d "$PROJECT_DIR/.opencode" ]]; then
    OES_DIR="$PROJECT_DIR"
    info "Using local OES repo: $OES_DIR"
  else
    # Download from GitHub
    if ! command -v git &>/dev/null; then
      error "git is required but not found. Install git and retry."
      exit 1
    fi
    info "Downloading OES from GitHub..."
    TMP_DIR=$(mktemp -d)
    git clone --depth=1 --quiet "$OES_REPO" "$TMP_DIR/OES"
    OES_DIR="$TMP_DIR/OES"
    success "Downloaded $(cat "$OES_DIR/VERSION")"
  fi
}

# ── Detect tools ──────────────────────────────
detect_tools() {
  HAS_CLAUDE=false
  HAS_OPENCODE=false
  HAS_CODEX=false

  command -v claude    &>/dev/null && HAS_CLAUDE=true
  command -v opencode  &>/dev/null && HAS_OPENCODE=true
  command -v codex     &>/dev/null && HAS_CODEX=true

  # Also detect by existing config dirs in project
  [[ -d "$PROJECT_DIR/.claude" ]]   && HAS_CLAUDE=true
  [[ -d "$PROJECT_DIR/.opencode" ]] && HAS_OPENCODE=true
  [[ -f "$PROJECT_DIR/AGENTS.md" ]] && HAS_CODEX=true
}

# ── Prompt yes/no ─────────────────────────────
confirm() {
  local prompt="$1"
  local default="${2:-y}"
  local reply
  read -r -p "$(echo -e "${YELLOW}?${RESET} $prompt [Y/n] ")" reply
  reply="${reply:-$default}"
  [[ "$reply" =~ ^[Yy]$ ]]
}

# ── Safe copy (asks before overwrite) ─────────
safe_copy_dir() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [[ -d "$dst" ]]; then
    if confirm "$label already exists at $dst — overwrite?"; then
      rm -rf "$dst"
      cp -r "$src" "$dst"
      success "$label updated."
    else
      warn "Skipped $label."
    fi
  else
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    success "$label installed."
  fi
}

safe_copy_file() {
  local src="$1"
  local dst="$2"
  local label="$3"

  if [[ -f "$dst" ]]; then
    if confirm "$label already exists — overwrite?"; then
      cp "$src" "$dst"
      success "$label updated."
    else
      warn "Skipped $label."
    fi
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    success "$label installed."
  fi
}

safe_copy_glob() {
  local src_dir="$1"
  local dst_dir="$2"
  local label="$3"

  mkdir -p "$dst_dir"
  local count=0
  for f in "$src_dir"/*; do
    [[ -f "$f" ]] || continue
    local fname
    fname="$(basename "$f")"
    local dst_file="$dst_dir/$fname"
    if [[ -f "$dst_file" ]]; then
      if confirm "$label: $fname exists — overwrite?"; then
        cp "$f" "$dst_file"
        ((count++)) || true
      fi
    else
      cp "$f" "$dst_file"
      ((count++)) || true
    fi
  done
  [[ $count -gt 0 ]] && success "$label: $count file(s) installed."
}

# ── Install: Claude Code ──────────────────────
install_claude() {
  header "Claude Code"

  echo -e "  ${BOLD}(1)${RESET} Global — available in all projects (~/.claude/)"
  echo -e "  ${BOLD}(2)${RESET} Project — only this project (.claude/)"
  echo -e "  ${BOLD}(3)${RESET} Both"
  read -r -p "$(echo -e "${YELLOW}?${RESET} Choose [1/2/3]: ")" scope
  scope="${scope:-1}"

  case "$scope" in
    1|3)
      info "Installing globally to ~/.claude/ ..."
      mkdir -p ~/.claude/commands ~/.claude/agents

      safe_copy_glob "$OES_DIR/.claude/commands" ~/.claude/commands "commands"

      # agents/ may not exist globally yet
      if [[ -d "$OES_DIR/.claude/agents" ]]; then
        safe_copy_glob "$OES_DIR/.claude/agents" ~/.claude/agents "agents"
      fi

      # protocols
      if [[ -d "$OES_DIR/.claude/protocols" ]]; then
        mkdir -p ~/.claude/protocols
        safe_copy_glob "$OES_DIR/.claude/protocols" ~/.claude/protocols "protocols"
      fi

      # AGENTS.md (standards) to global
      if [[ -f "$OES_DIR/.claude/AGENTS.md" ]]; then
        safe_copy_file "$OES_DIR/.claude/AGENTS.md" ~/.claude/AGENTS.md "AGENTS.md (standards)"
      fi

      # CLAUDE.md to global
      if [[ -f "$OES_DIR/.claude/CLAUDE.md" ]]; then
        safe_copy_file "$OES_DIR/.claude/CLAUDE.md" ~/.claude/CLAUDE.md "CLAUDE.md"
      fi
      ;;
  esac

  case "$scope" in
    2|3)
      info "Installing to project $PROJECT_DIR/.claude/ ..."
      safe_copy_dir "$OES_DIR/.claude" "$PROJECT_DIR/.claude" ".claude/"
      ;;
  esac
}

# ── Install: OpenCode ─────────────────────────
install_opencode() {
  header "OpenCode"
  info "Installing to project $PROJECT_DIR/.opencode/ ..."
  safe_copy_dir "$OES_DIR/.opencode" "$PROJECT_DIR/.opencode" ".opencode/"
}

# ── Install: Codex ────────────────────────────
install_codex() {
  header "Codex CLI"
  info "Installing AGENTS.md to project root ..."
  safe_copy_file "$OES_DIR/AGENTS.md" "$PROJECT_DIR/AGENTS.md" "AGENTS.md"
}

# ── Engram reminder ───────────────────────────
remind_engram() {
  if ! command -v engram &>/dev/null; then
    echo ""
    warn "Engram not detected. OES uses Engram for persistent memory."
    warn "Install: npm install -g @engramhq/engram"
    warn "Then add to ~/.claude/settings.json:"
    warn '  { "mcpServers": { "engram": { "command": "engram", "args": ["--mcp"] } } }'
    warn "Full instructions: ENGRAM.md"
  else
    success "Engram detected — memory layer ready."
  fi
}

# ── Summary ───────────────────────────────────
print_summary() {
  echo ""
  success "OES installed. $(cat "$OES_DIR/VERSION")"
  echo ""
  echo -e "  ${BOLD}Commands available:${RESET}"
  echo -e "  /work   /feature   /bugfix   /refactor"
  echo -e "  /review /review-pr /sdd      /deploy"
  echo -e "  /test   /commit    /document /explore"
  echo ""
  echo -e "  ${BOLD}Start a session:${RESET}"
  echo -e "  > mem_context   ← load prior context"
  echo -e "  > /work <task>  ← start working"
  echo ""
  echo -e "  ${CYAN}Full guide: QUICKSTART.md${RESET}"
}

# ─────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────
main() {
  echo ""
  echo -e "${BOLD}OES Installer${RESET}"
  echo -e "Installing to: ${CYAN}$PROJECT_DIR${RESET}"
  echo ""

  resolve_oes_source
  detect_tools

  # Show detected tools
  info "Detected tools:"
  $HAS_CLAUDE    && echo "  ✓ Claude Code" || echo "  ✗ Claude Code"
  $HAS_OPENCODE  && echo "  ✓ OpenCode"    || echo "  ✗ OpenCode"
  $HAS_CODEX     && echo "  ✓ Codex CLI"   || echo "  ✗ Codex CLI"
  echo ""

  # If nothing detected, ask what to install
  if ! $HAS_CLAUDE && ! $HAS_OPENCODE && ! $HAS_CODEX; then
    warn "No tools detected. Select what to install:"
    confirm "Install for Claude Code?" && HAS_CLAUDE=true
    confirm "Install for OpenCode?"    && HAS_OPENCODE=true
    confirm "Install for Codex CLI?"   && HAS_CODEX=true
  fi

  $HAS_CLAUDE   && install_claude
  $HAS_OPENCODE && install_opencode
  $HAS_CODEX    && install_codex

  remind_engram
  print_summary
}

main "$@"
