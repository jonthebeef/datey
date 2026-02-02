#!/bin/bash
#
# session-date-context.sh (part of datey)
# A Claude Code SessionStart hook that injects current date context
#
# This hook runs once at session start and provides Claude with
# the current date for temporal awareness throughout the session.
#

set -euo pipefail

# Get current date in various formats
FULL_DATE=$(date +%Y-%m-%d)
YEAR=$(date +%Y)
MONTH_NAME=$(date +%B)
DAY=$(date +%d)

# Output context that will be injected into the session
cat <<EOF
{
  "additionalContext": "Today's date is ${FULL_DATE} (${MONTH_NAME} ${DAY}, ${YEAR}). When performing web searches for current information, documentation, or recent events, include the year ${YEAR} in your search queries to get up-to-date results."
}
EOF
