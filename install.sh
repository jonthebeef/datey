#!/bin/bash
#
# install.sh
# Installs datey hooks for Claude Code
#
# Usage:
#   ./install.sh           # Install to current project (.claude/)
#   ./install.sh --global  # Install to user config (~/.claude/)
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine install location
if [[ "${1:-}" == "--global" ]]; then
  INSTALL_DIR="$HOME/.claude"
  echo -e "${YELLOW}Installing globally to ~/.claude/${NC}"
else
  INSTALL_DIR=".claude"
  echo -e "${YELLOW}Installing to current project (.claude/)${NC}"
fi

HOOKS_DIR="$INSTALL_DIR/hooks"
SETTINGS_FILE="$INSTALL_DIR/settings.json"

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for jq dependency
if ! command -v jq &> /dev/null; then
  echo -e "${RED}Error: jq is required but not installed.${NC}"
  echo ""
  echo "Install jq:"
  echo "  macOS:  brew install jq"
  echo "  Ubuntu: sudo apt-get install jq"
  echo "  Arch:   sudo pacman -S jq"
  exit 1
fi

# Create hooks directory
mkdir -p "$HOOKS_DIR"
echo -e "${GREEN}Created $HOOKS_DIR${NC}"

# Copy hook scripts
cp "$SCRIPT_DIR/hooks/date-aware-search.sh" "$HOOKS_DIR/"
cp "$SCRIPT_DIR/hooks/session-date-context.sh" "$HOOKS_DIR/"
chmod +x "$HOOKS_DIR/date-aware-search.sh"
chmod +x "$HOOKS_DIR/session-date-context.sh"
echo -e "${GREEN}Installed hook scripts${NC}"

# Handle settings.json
if [[ -f "$SETTINGS_FILE" ]]; then
  echo -e "${YELLOW}Existing settings.json found. Merging hooks...${NC}"

  # Create a backup
  cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
  echo -e "${GREEN}Backup created: $SETTINGS_FILE.backup${NC}"

  # Merge the hooks configuration
  MERGED=$(jq -s '
    .[0] as $existing |
    .[1] as $new |
    $existing * {
      hooks: {
        SessionStart: (($existing.hooks.SessionStart // []) + ($new.hooks.SessionStart // [])),
        PreToolUse: (($existing.hooks.PreToolUse // []) + ($new.hooks.PreToolUse // []))
      }
    }
  ' "$SETTINGS_FILE" "$SCRIPT_DIR/settings.example.json")

  echo "$MERGED" > "$SETTINGS_FILE"
  echo -e "${GREEN}Merged hooks into existing settings.json${NC}"
else
  # Copy the example settings
  cp "$SCRIPT_DIR/settings.example.json" "$SETTINGS_FILE"
  echo -e "${GREEN}Created $SETTINGS_FILE${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "The following hooks are now active:"
echo "  - SessionStart: Injects current date context at session start"
echo "  - PreToolUse (WebSearch): Appends current year to search queries"
echo ""
echo "To verify, start Claude Code and check that hooks are loaded."
echo "Use 'claude --debug' for verbose hook execution logs."
