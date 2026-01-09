#!/usr/bin/env bash
# List available personas in the library
# Usage: list.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBRARY_DIR="$SCRIPT_DIR/../assets/library"

echo "Available personas:"
for f in "$LIBRARY_DIR"/*.yaml; do
    name=$(basename "$f" .yaml)
    desc=$(yq -r '.description // empty' "$f" | head -1)
    echo "  $name — $desc"
done
