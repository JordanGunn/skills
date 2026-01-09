#!/usr/bin/env bash
# Load a persona spec into the slot
# Usage: load.sh <persona>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIMIC_ROOT="$SCRIPT_DIR/.."
LIBRARY_DIR="$MIMIC_ROOT/assets/library"
SLOT_DIR="$MIMIC_ROOT/assets/persona"

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <persona>" >&2
    echo "Available: $(ls "$LIBRARY_DIR" | sed 's/\.yaml$//' | tr '\n' ' ')" >&2
    exit 1
fi

persona="$1"
spec_file="$LIBRARY_DIR/${persona}.yaml"

if [[ ! -f "$spec_file" ]]; then
    echo "Error: Unknown persona '$persona'" >&2
    echo "Available: $(ls "$LIBRARY_DIR" | sed 's/\.yaml$//' | tr '\n' ' ')" >&2
    exit 1
fi

cp "$spec_file" "$SLOT_DIR/spec.yaml"
echo "✨ Loaded '$persona' into slot."
