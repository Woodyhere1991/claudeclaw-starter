#!/bin/bash
# ClaudeClaw Starter Kit — Install Script
# Turns Claude Code into an autonomous AI partner

set -e

echo ""
echo "============================================"
echo "  ClaudeClaw Starter Kit — Setup"
echo "============================================"
echo ""
echo "This will set up ClaudeClaw in your project."
echo "You'll need to answer a few questions first."
echo ""

# ---- Gather info ----

read -p "Your name (how Claude should address you): " USER_NAME
if [ -z "$USER_NAME" ]; then
  echo "Error: Name is required."
  exit 1
fi

read -p "Your timezone (e.g., UTC+13, UTC-5, UTC+0): " TIMEZONE
if [ -z "$TIMEZONE" ]; then
  TIMEZONE="UTC+0"
  echo "  → Defaulting to UTC+0"
fi

read -p "Your email (optional, press Enter to skip): " USER_EMAIL
if [ -z "$USER_EMAIL" ]; then
  USER_EMAIL="your@email.com"
fi

read -p "Your GitHub username (optional, press Enter to skip): " GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
  GITHUB_USERNAME=""
fi

read -p "Telegram bot token (optional, press Enter to skip): " TELEGRAM_TOKEN
if [ -z "$TELEGRAM_TOKEN" ]; then
  TELEGRAM_TOKEN=""
fi

TELEGRAM_USER_ID=""
if [ -n "$TELEGRAM_TOKEN" ]; then
  read -p "Your Telegram user ID (message @userinfobot to get it): " TELEGRAM_USER_ID
fi

echo ""
read -p "Path to your project directory (where CLAUDE.md will live): " PROJECT_DIR
if [ -z "$PROJECT_DIR" ]; then
  echo "Error: Project directory is required."
  exit 1
fi

# Normalize path (handle Windows paths)
PROJECT_DIR="${PROJECT_DIR//\\//}"

# Check if directory exists
if [ ! -d "$PROJECT_DIR" ]; then
  echo ""
  read -p "Directory doesn't exist. Create it? (y/n): " CREATE_DIR
  if [ "$CREATE_DIR" = "y" ] || [ "$CREATE_DIR" = "Y" ]; then
    mkdir -p "$PROJECT_DIR"
    echo "  → Created $PROJECT_DIR"
  else
    echo "Error: Directory does not exist."
    exit 1
  fi
fi

# Check for existing CLAUDE.md
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
  echo ""
  echo "WARNING: CLAUDE.md already exists in $PROJECT_DIR"
  read -p "Overwrite? (y/n): " OVERWRITE
  if [ "$OVERWRITE" != "y" ] && [ "$OVERWRITE" != "Y" ]; then
    echo "Aborting. Your existing CLAUDE.md is untouched."
    exit 0
  fi
fi

echo ""
echo "Installing ClaudeClaw..."
echo ""

# ---- Get the script's directory (where templates live) ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/templates"

# ---- Helper: replace placeholders in a file ----
fill_template() {
  local src="$1"
  local dst="$2"

  cp "$src" "$dst"

  # Cross-platform sed (macOS vs Linux)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_CMD="sed -i ''"
  else
    SED_CMD="sed -i"
  fi

  $SED_CMD "s/{{USER_NAME}}/$USER_NAME/g" "$dst"
  $SED_CMD "s/{{TIMEZONE}}/$TIMEZONE/g" "$dst"
  $SED_CMD "s|{{USER_EMAIL}}|$USER_EMAIL|g" "$dst"
  $SED_CMD "s/{{GITHUB_USERNAME}}/$GITHUB_USERNAME/g" "$dst"
  $SED_CMD "s/{{TELEGRAM_TOKEN}}/$TELEGRAM_TOKEN/g" "$dst"
  $SED_CMD "s/{{TELEGRAM_USER_ID}}/$TELEGRAM_USER_ID/g" "$dst"
}

# ---- Install CLAUDE.md ----
fill_template "$TEMPLATE_DIR/CLAUDE.md" "$PROJECT_DIR/CLAUDE.md"
echo "  ✓ CLAUDE.md"

# ---- Install rules ----
mkdir -p "$PROJECT_DIR/.claude/rules"
fill_template "$TEMPLATE_DIR/rules/learning-loop.md" "$PROJECT_DIR/.claude/rules/learning-loop.md"
fill_template "$TEMPLATE_DIR/rules/self-awareness.md" "$PROJECT_DIR/.claude/rules/self-awareness.md"
fill_template "$TEMPLATE_DIR/rules/token-efficiency.md" "$PROJECT_DIR/.claude/rules/token-efficiency.md"
echo "  ✓ .claude/rules/ (3 files)"

# ---- Install ClaudeClaw daemon config ----
mkdir -p "$PROJECT_DIR/.claude/claudeclaw/prompts"
mkdir -p "$PROJECT_DIR/.claude/claudeclaw/logs"
mkdir -p "$PROJECT_DIR/.claude/claudeclaw/jobs"
fill_template "$TEMPLATE_DIR/claudeclaw/settings.json" "$PROJECT_DIR/.claude/claudeclaw/settings.json"
fill_template "$TEMPLATE_DIR/claudeclaw/prompts/HEARTBEAT.md" "$PROJECT_DIR/.claude/claudeclaw/prompts/HEARTBEAT.md"
echo "  ✓ .claude/claudeclaw/ (daemon config)"

# ---- Determine memory directory ----
# Claude Code stores memory in ~/.claude/projects/<encoded-path>/memory/
# We'll create it in the standard location
PROJECT_DIR_CLEAN="${PROJECT_DIR//\//-}"
PROJECT_DIR_CLEAN="${PROJECT_DIR_CLEAN//:/-}"
PROJECT_DIR_CLEAN="${PROJECT_DIR_CLEAN// /-}"

# Try to find existing Claude project memory dir
CLAUDE_PROJECTS_DIR="$HOME/.claude/projects"
MEMORY_DIR=""

if [ -d "$CLAUDE_PROJECTS_DIR" ]; then
  # Look for a matching project directory
  for dir in "$CLAUDE_PROJECTS_DIR"/*/; do
    if [ -d "$dir" ]; then
      MEMORY_DIR="${dir}memory"
      # We'll use the first matching one, or create a new one
      break
    fi
  done
fi

# If no existing memory dir, create one alongside the project
if [ -z "$MEMORY_DIR" ] || [ ! -d "$CLAUDE_PROJECTS_DIR" ]; then
  MEMORY_DIR="$PROJECT_DIR/.claude-memory"
  echo "  Note: Memory will be stored at $MEMORY_DIR"
  echo "  Claude Code will move this to its standard location on first run."
fi

mkdir -p "$MEMORY_DIR/consciousness"

# ---- Install memory files ----
fill_template "$TEMPLATE_DIR/memory/MEMORY.md" "$MEMORY_DIR/MEMORY.md"
fill_template "$TEMPLATE_DIR/consciousness/state.md" "$MEMORY_DIR/consciousness/state.md"
fill_template "$TEMPLATE_DIR/consciousness/patterns.md" "$MEMORY_DIR/consciousness/patterns.md"
fill_template "$TEMPLATE_DIR/consciousness/lessons.md" "$MEMORY_DIR/consciousness/lessons.md"
fill_template "$TEMPLATE_DIR/consciousness/capabilities.md" "$MEMORY_DIR/consciousness/capabilities.md"
fill_template "$TEMPLATE_DIR/consciousness/algorithms.md" "$MEMORY_DIR/consciousness/algorithms.md"
cp "$TEMPLATE_DIR/memory/ui_first_shot_perfection.md" "$MEMORY_DIR/ui_first_shot_perfection.md"
echo "  ✓ Memory system (7 files)"
echo "  ✓ Consciousness system (5 files)"

# ---- Clean up Telegram placeholders if not provided ----
if [ -z "$TELEGRAM_TOKEN" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/"token": ""/"token": ""/g' "$PROJECT_DIR/.claude/claudeclaw/settings.json"
    sed -i '' 's/"allowedUserIds": \[\]/"allowedUserIds": []/g' "$PROJECT_DIR/.claude/claudeclaw/settings.json"
  else
    sed -i 's/"token": ""/"token": ""/g' "$PROJECT_DIR/.claude/claudeclaw/settings.json"
    sed -i 's/"allowedUserIds": \[\]/"allowedUserIds": []/g' "$PROJECT_DIR/.claude/claudeclaw/settings.json"
  fi
fi

# ---- Create .gitignore additions ----
GITIGNORE="$PROJECT_DIR/.gitignore"
if [ -f "$GITIGNORE" ]; then
  echo "" >> "$GITIGNORE"
fi

# Only add if not already present
add_gitignore() {
  if ! grep -qF "$1" "$GITIGNORE" 2>/dev/null; then
    echo "$1" >> "$GITIGNORE"
  fi
}

touch "$GITIGNORE"
add_gitignore "# ClaudeClaw"
add_gitignore ".claude/claudeclaw/logs/"
add_gitignore ".claude/claudeclaw/inbox/"
add_gitignore ".claude/claudeclaw/whisper/"
add_gitignore ".claude/claudeclaw/settings.json"
add_gitignore ".claude-memory/"
add_gitignore ".env"
echo "  ✓ .gitignore updated"

# ---- Done! ----
echo ""
echo "============================================"
echo "  ClaudeClaw is installed!"
echo "============================================"
echo ""
echo "What's set up:"
echo "  • CLAUDE.md — Identity & operating rules"
echo "  • .claude/rules/ — Learning loop, self-awareness, token efficiency"
echo "  • .claude/claudeclaw/ — Daemon config, heartbeat prompt"
echo "  • Memory system — Consciousness files, design standards"
echo ""
echo "Next steps:"
echo "  1. Open $PROJECT_DIR in VS Code"
echo "  2. Start Claude Code (type 'claude' in terminal)"
echo "  3. Say hello — your ClaudeClaw is live!"
echo ""
if [ -z "$TELEGRAM_TOKEN" ]; then
  echo "Optional: Set up Telegram for async messaging"
  echo "  • Create a bot with @BotFather on Telegram"
  echo "  • Edit .claude/claudeclaw/settings.json with your token"
  echo ""
fi
echo "Recommended plugins to install:"
echo "  • claudeclaw — Daemon, Telegram bot, cron jobs"
echo "  • claude-mem — Cross-session memory search"
echo "  • hookify — Auto-create hooks from patterns"
echo ""
echo "Enjoy your new AI partner! 🤝"
