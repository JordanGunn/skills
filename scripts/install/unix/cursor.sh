#!/usr/bin/env bash
# cursor.sh - Generate Cursor command files from skills
#
# Usage: cursor.sh [project_root]
#
# If project_root is provided, runs from that directory.
# Otherwise, attempts to find project root from script location.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve project root
if [[ $# -ge 1 ]]; then
    PROJECT_ROOT="$1"
else
    # Navigate up from .codex/scripts/install/unix/ to project root
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
fi

ADAPTER_SCRIPT="$PROJECT_ROOT/.codex/scripts/adapter/cursor.sh"

if [[ ! -f "$ADAPTER_SCRIPT" ]]; then
    echo "Error: Could not find adapter script at $ADAPTER_SCRIPT" >&2
    exit 1
fi

if [[ ! -x "$ADAPTER_SCRIPT" ]]; then
    chmod +x "$ADAPTER_SCRIPT" 2>/dev/null || true
fi

exec "$ADAPTER_SCRIPT"
