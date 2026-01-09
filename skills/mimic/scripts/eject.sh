#!/usr/bin/env bash
# Eject the current persona (clear slot)
# Usage: eject.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SLOT_DIR="$SCRIPT_DIR/../assets/persona"

if [[ -f "$SLOT_DIR/spec.yaml" ]]; then
    rm -f "$SLOT_DIR"/*.yaml "$SLOT_DIR"/*.md 2>/dev/null || true
    echo "Persona ejected. Slot is now empty."
else
    echo "No persona loaded. Slot is already empty."
fi
