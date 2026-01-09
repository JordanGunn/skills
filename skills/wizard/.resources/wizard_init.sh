#!/usr/bin/env bash
# wizard_init.sh - Initialize a new wizard session
#
# Creates:
#   - .rune pointer file in state directory
#   - Session markdown file from template
#
# Exit codes:
#   0 - Session created successfully
#   1 - Session already exists (use wizard_status.sh to check)
#
# Output:
#   SESSION_ID=<id>
#   SESSION_PATH=<path>
#
# Usage: wizard_init.sh

set -euo pipefail

RUNE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/lask"
RUNE_FILE="$RUNE_DIR/.rune"
SESSION_DIR="$RUNE_DIR/wizard-sessions"

# Check for existing session
if [[ -f "$RUNE_FILE" ]]; then
    echo "Active session already exists. Use wizard_status.sh or wizard_destroy.sh first." >&2
    exit 1
fi

# Create directories
mkdir -p "$RUNE_DIR" "$SESSION_DIR"

# Generate session ID
SESSION_ID=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid 2>/dev/null || date +%s%N)
SESSION_PATH="$SESSION_DIR/session-$SESSION_ID.md"

# Locate template
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/SESSION_TEMPLATE.md"

if [[ ! -f "$TEMPLATE" ]]; then
    echo "Session template not found: $TEMPLATE" >&2
    exit 1
fi

# Create session file from template
sed "s/\${SESSION_ID}/$SESSION_ID/g" "$TEMPLATE" > "$SESSION_PATH"

# Create .rune pointer
cat > "$RUNE_FILE" << EOF
SESSION_ID=$SESSION_ID
SESSION_PATH=$SESSION_PATH
EOF

echo "SESSION_ID=$SESSION_ID"
echo "SESSION_PATH=$SESSION_PATH"
exit 0
