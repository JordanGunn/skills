#!/usr/bin/env bash
# codex.sh - Install skills to codex home or target directory
#
# Usage: codex.sh [target_dir]
#
# If target_dir is provided:
#   - Checks if target_dir/.codex or target_dir/.codex/skills exists
#   - Copies skills to target_dir/.codex/skills/
#
# If no argument:
#   - Installs to $HOME/.codex/skills/

set -euo pipefail

# Check for rsync (required)
if ! command -v rsync &>/dev/null; then
    echo "Error: rsync is required but not installed." >&2
    echo "Install it via your package manager (e.g., apt install rsync, brew install rsync)" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
SOURCE_SKILLS="$PROJECT_ROOT/skills"

if [[ ! -d "$SOURCE_SKILLS" ]]; then
    echo "Error: Source skills directory not found: $SOURCE_SKILLS" >&2
    exit 1
fi

# Determine target directory
if [[ $# -ge 1 ]]; then
    TARGET_DIR="$1"
    
    # Normalize: strip trailing slash
    TARGET_DIR="${TARGET_DIR%/}"
    
    # Check if target already has .codex structure
    if [[ "$TARGET_DIR" == *"/.codex/skills" ]]; then
        # User passed full path including .codex/skills
        DEST_SKILLS="$TARGET_DIR"
    elif [[ "$TARGET_DIR" == *"/.codex" ]]; then
        # User passed path including .codex
        DEST_SKILLS="$TARGET_DIR/skills"
    else
        # User passed project root
        DEST_SKILLS="$TARGET_DIR/.codex/skills"
    fi
else
    # Default: install to home
    DEST_SKILLS="$HOME/.codex/skills"
fi

# Create destination if needed
mkdir -p "$DEST_SKILLS"

echo "Installing skills..."
echo "  Source: $SOURCE_SKILLS"
echo "  Destination: $DEST_SKILLS"
echo

# Copy skills (excluding any .git or __pycache__)
rsync -av --exclude='.git' --exclude='__pycache__' --exclude='*.pyc' \
    "$SOURCE_SKILLS/" "$DEST_SKILLS/"

echo
echo "Skills installed to: $DEST_SKILLS"
