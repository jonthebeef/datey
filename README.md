# datey

A [Claude Code](https://claude.ai/code) hook that ensures web searches always include the current year, helping Claude find up-to-date information.

## The Problem

Claude's knowledge has a cutoff date, and when searching the web, it sometimes forgets to include the current year in queries. This leads to outdated results when searching for documentation, recent events, or current best practices.

## The Solution

datey automatically:

1. **Injects date context** at session start so Claude knows today's date
2. **Appends the current year** to WebSearch queries (if not already present)

## Installation

### Prerequisites

- [Claude Code](https://claude.ai/code) installed
- `jq` command-line JSON processor
  ```bash
  # macOS
  brew install jq

  # Ubuntu/Debian
  sudo apt-get install jq

  # Arch Linux
  sudo pacman -S jq
  ```

### Install

```bash
# Clone the repo
git clone https://github.com/jonthebeef/datey.git
cd datey

# Install to your current project
./install.sh

# Or install globally (applies to all projects)
./install.sh --global
```

### Manual Installation

If you prefer to install manually:

1. Copy the `hooks/` folder to `.claude/hooks/` in your project (or `~/.claude/hooks/` for global)

2. Add to your `.claude/settings.json`:
   ```json
   {
     "hooks": {
       "SessionStart": [
         {
           "hooks": [
             {
               "type": "command",
               "command": ".claude/hooks/session-date-context.sh"
             }
           ]
         }
       ],
       "PreToolUse": [
         {
           "matcher": "WebSearch",
           "hooks": [
             {
               "type": "command",
               "command": ".claude/hooks/date-aware-search.sh"
             }
           ]
         }
       ]
     }
   }
   ```

3. Make the scripts executable:
   ```bash
   chmod +x .claude/hooks/*.sh
   ```

## How It Works

### SessionStart Hook

When you start a Claude Code session, `session-date-context.sh` runs and injects context like:

> Today's date is 2026-02-02 (February 02, 2026). When performing web searches for current information, documentation, or recent events, include the year 2026 in your search queries to get up-to-date results.

### PreToolUse Hook

Before every `WebSearch` call, `date-aware-search.sh` checks if the query already contains the current year. If not, it appends it:

- `"React documentation"` → `"React documentation 2026"`
- `"best practices Node.js 2026"` → unchanged (year already present)

## Uninstall

```bash
./uninstall.sh           # Remove from current project
./uninstall.sh --global  # Remove from global config
```

Note: The uninstall script removes the hook files but leaves `settings.json` intact. You may want to manually remove the hook entries.

## Configuration

### Customize the Search Hook

Edit `.claude/hooks/date-aware-search.sh` to customize behavior:

```bash
# Example: Add month and year for more specific searches
YEAR=$(date +%Y)
MONTH=$(date +%B)
# Then append "$MONTH $YEAR" instead of just "$YEAR"
```

### Customize Session Context

Edit `.claude/hooks/session-date-context.sh` to change the context message injected at session start.

## Troubleshooting

### Hooks not running?

1. Check that scripts are executable: `chmod +x .claude/hooks/*.sh`
2. Run Claude with debug flag: `claude --debug`
3. Verify `jq` is installed: `jq --version`

### Settings not loading?

Make sure your `settings.json` is valid JSON. Use `jq . .claude/settings.json` to validate.

## Platform Support

| Platform | Status |
|----------|--------|
| macOS    | Fully supported |
| Linux    | Fully supported |
| Windows  | Requires WSL or Git Bash |

## Contributing

Contributions welcome! Feel free to:

- Report issues
- Suggest improvements
- Submit pull requests

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

Built for the Claude Code community. If you find this useful, give it a star!
