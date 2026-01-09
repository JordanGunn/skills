#!/usr/bin/env bash
# wizard_close.sh - Close an active wizard session
#
# Requires:
#   - Active session (checked via .rune)
#   - Session frontmatter must have decision != "undecided"
#
# Actions:
#   - Updates session frontmatter: status -> closed
#   - Removes .rune pointer
#   - Optionally archives session if export_on_close: true
#
# Exit codes:
#   0 - Session closed successfully
#   1 - No active session
#   2 - Session not ready for closure (decision still undecided)
#
# Usage: wizard_close.sh [--force]

set -euo pipefail

FORCE="${1:-}"
RUNE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/lask"
RUNE_FILE="$RUNE_DIR/.rune"

if [[ ! -f "$RUNE_FILE" ]]; then
    echo "No active wizard session to close." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$RUNE_FILE"

if [[ ! -f "$SESSION_PATH" ]]; then
    echo "Session file missing. Cleaning up stale .rune." >&2
    rm -f "$RUNE_FILE"
    exit 1
fi

# Check decision status
DECISION=$(sed -n 's/^decision: *//p' "$SESSION_PATH" | head -1)

if [[ "$DECISION" == "undecided" ]] && [[ "$FORCE" != "--force" ]]; then
    echo "Cannot close session: decision is still 'undecided'." >&2
    echo "Use --force to close anyway, or complete the wizard reasoning." >&2
    exit 2
fi

# Update frontmatter: status -> closed
sed -i 's/^status: *active/status: closed/' "$SESSION_PATH"

# Check for export_on_close
EXPORT=$(sed -n 's/^export_on_close: *//p' "$SESSION_PATH" | head -1)

if [[ "$EXPORT" == "true" ]]; then
    ARCHIVE_DIR="$RUNE_DIR/wizard-archive"
    mkdir -p "$ARCHIVE_DIR"
    cp "$SESSION_PATH" "$ARCHIVE_DIR/"
    echo "Session archived to: $ARCHIVE_DIR/$(basename "$SESSION_PATH")"
fi

# Remove .rune pointer
rm -f "$RUNE_FILE"

echo "Session closed: $SESSION_ID"
echo "Session file: $SESSION_PATH"
exit 0
