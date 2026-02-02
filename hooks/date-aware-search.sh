#!/bin/bash
#
# date-aware-search.sh (part of datey)
# A Claude Code PreToolUse hook that ensures web searches include the current year
#
# This hook intercepts WebSearch calls and appends the current year to queries
# that don't already contain it, helping Claude find current information.
#

set -euo pipefail

# Read the hook input from stdin
INPUT=$(cat)

# Extract the search query
QUERY=$(echo "$INPUT" | jq -r '.tool_input.query // empty')

# If no query, pass through unchanged
if [[ -z "$QUERY" ]]; then
  echo "$INPUT"
  exit 0
fi

# Get current date info
YEAR=$(date +%Y)

# Check if the year is already in the query (avoid duplication)
if [[ "$QUERY" =~ $YEAR ]]; then
  # Year already present, pass through unchanged
  echo "$INPUT"
  exit 0
fi

# Append the year to the query
echo "$INPUT" | jq --arg year "$YEAR" '.tool_input.query = .tool_input.query + " " + $year'
