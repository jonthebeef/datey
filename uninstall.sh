#!/bin/bash
#
# uninstall.sh
# Removes datey hooks from Claude Code
#
# Usage:
#   ./uninstall.sh           # Remove from current project
#   ./uninstall.sh --global  # Remove from user config
#

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ "${1:-}" == "--global" ]]; then
  INSTALL_DIR="$HOME/.claude"
else
  INSTALL_DIR=".claude"
fi

HOOKS_DIR="$INSTALL_DIR/hooks"
SETTINGS_FILE="$INSTALL_DIR/settings.json"

# Remove hook scripts
if [[ -f "$HOOKS_DIR/date-aware-search.sh" ]]; then
  rm "$HOOKS_DIR/date-aware-search.sh"
  echo -e "${GREEN}Removed date-aware-search.sh${NC}"
fi

if [[ -f "$HOOKS_DIR/session-date-context.sh" ]]; then
  rm "$HOOKS_DIR/session-date-context.sh"
  echo -e "${GREEN}Removed session-date-context.sh${NC}"
fi

# Note about settings.json
if [[ -f "$SETTINGS_FILE" ]]; then
  echo -e "${YELLOW}Note: settings.json was not modified.${NC}"
  echo "You may want to manually remove the hook entries from $SETTINGS_FILE"
fi

echo ""
echo -e "${GREEN}Uninstall complete!${NC}"
