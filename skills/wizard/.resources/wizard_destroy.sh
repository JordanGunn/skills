#!/usr/bin/env bash
# wizard_destroy.sh - Abort and destroy an active wizard session
#
# Actions:
#   - Removes .rune pointer
#   - Optionally removes session file (--delete-session)
#
# Exit codes:
#   0 - Session destroyed
#   1 - No active session
#
# Usage: wizard_destroy.sh [--delete-session]

set -euo pipefail

DELETE_SESSION="${1:-}"
RUNE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/lask"
RUNE_FILE="$RUNE_DIR/.rune"

if [[ ! -f "$RUNE_FILE" ]]; then
    echo "No active wizard session to destroy." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$RUNE_FILE"

# Remove .rune pointer
rm -f "$RUNE_FILE"
echo "Session pointer removed."

if [[ "$DELETE_SESSION" == "--delete-session" ]] && [[ -f "$SESSION_PATH" ]]; then
    rm -f "$SESSION_PATH"
    echo "Session file deleted: $SESSION_PATH"
else
    echo "Session file preserved: $SESSION_PATH"
fi

echo "Wizard session destroyed: $SESSION_ID"
exit 0
