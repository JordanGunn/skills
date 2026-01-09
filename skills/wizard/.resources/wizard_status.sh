#!/usr/bin/env bash
# wizard_status.sh - Check if an active wizard session exists
#
# Exit codes:
#   0 - Active session exists
#   1 - No active session
#
# Output (if active):
#   SESSION_ID=<id>
#   SESSION_PATH=<path>
#   STATUS=active
#
# Usage: wizard_status.sh

set -euo pipefail

RUNE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/lask"
RUNE_FILE="$RUNE_DIR/.rune"

if [[ ! -f "$RUNE_FILE" ]]; then
    echo "No active wizard session." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$RUNE_FILE"

if [[ -z "${SESSION_PATH:-}" ]] || [[ ! -f "$SESSION_PATH" ]]; then
    echo "Stale .rune detected. Session file missing." >&2
    rm -f "$RUNE_FILE"
    exit 1
fi

# Check session status from frontmatter
STATUS=$(sed -n 's/^status: *//p' "$SESSION_PATH" | head -1)

if [[ "$STATUS" != "active" ]]; then
    echo "Session exists but is closed." >&2
    rm -f "$RUNE_FILE"
    exit 1
fi

echo "SESSION_ID=$SESSION_ID"
echo "SESSION_PATH=$SESSION_PATH"
echo "STATUS=active"
exit 0
