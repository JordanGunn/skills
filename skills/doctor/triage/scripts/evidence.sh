#!/usr/bin/env bash
# Triage Evidence Gathering Script
# Lightweight grep-based evidence pointer discovery
#
# Usage:
#   ./evidence.sh <search_term> [--path <search_path>] [--type <file_type>]
#
# Examples:
#   ./evidence.sh "connection refused"
#   ./evidence.sh "timeout" --path src/
#   ./evidence.sh "database" --type yaml
#   ./evidence.sh "500" --path . --type py

set -euo pipefail

# Default values
SEARCH_TERM=""
SEARCH_PATH="."
FILE_TYPE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --path)
            SEARCH_PATH="$2"
            shift 2
            ;;
        --type)
            FILE_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            head -14 "$0" | tail -12
            exit 0
            ;;
        *)
            SEARCH_TERM="$1"
            shift
            ;;
    esac
done

if [[ -z "$SEARCH_TERM" ]]; then
    echo "Error: Search term required"
    echo "Usage: $0 <search_term> [--path <path>] [--type <extension>]"
    exit 1
fi

echo "# Evidence Pointers for: '$SEARCH_TERM'"
echo ""
echo "**Search Path:** \`$SEARCH_PATH\`"
if [[ -n "$FILE_TYPE" ]]; then
    echo "**File Type:** \`*.$FILE_TYPE\`"
fi
echo "**Date:** $(date)"
echo ""
echo "---"
echo ""

# Build grep command
GREP_OPTS="-rn --color=never"
if [[ -n "$FILE_TYPE" ]]; then
    GREP_OPTS="$GREP_OPTS --include=*.$FILE_TYPE"
fi

# Run search
echo "## Matches"
echo ""
echo '```'
if grep $GREP_OPTS "$SEARCH_TERM" "$SEARCH_PATH" 2>/dev/null | head -50; then
    :
else
    echo "No matches found."
fi
echo '```'
echo ""

# Count matches
MATCH_COUNT=$(grep $GREP_OPTS -c "$SEARCH_TERM" "$SEARCH_PATH" 2>/dev/null | grep -v ":0$" | wc -l || echo 0)
echo "**Files with matches:** $MATCH_COUNT"
echo ""

# List files with matches
if [[ "$MATCH_COUNT" -gt 0 ]]; then
    echo "## Files"
    echo ""
    grep $GREP_OPTS -l "$SEARCH_TERM" "$SEARCH_PATH" 2>/dev/null | head -20 | while read -r file; do
        echo "- \`$file\`"
    done
    echo ""
fi

echo "---"
echo ""
echo "Evidence pointers gathered. Use these locations for focused examination."
