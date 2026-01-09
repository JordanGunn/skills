#!/usr/bin/env bash
#
# status.sh — Display plan execution status by parsing frontmatter
#
# Usage: ./status.sh [phase-number]
#   If no phase number is provided, uses the highest-numbered phase.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../../.." && pwd)"
PLANNING_DIR="$REPO_ROOT/docs/planning"

# Determine phase number
if [[ -n "${1:-}" ]]; then
    PHASE_NUM="$1"
else
    # Find highest phase number
    PHASE_NUM=$(ls -1 "$PLANNING_DIR" 2>/dev/null | grep -E '^phase-[0-9]+$' | sed 's/phase-//' | sort -n | tail -1)
    if [[ -z "$PHASE_NUM" ]]; then
        echo "No phases found in $PLANNING_DIR"
        exit 1
    fi
fi

PHASE_DIR="$PLANNING_DIR/phase-$PHASE_NUM"

if [[ ! -d "$PHASE_DIR" ]]; then
    echo "Phase directory not found: $PHASE_DIR"
    exit 1
fi

# Extract status from frontmatter
get_status() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "missing"
        return
    fi
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^status:/ {
            sub(/^status:[[:space:]]*/, "")
            print
            exit
        }
    ' "$file"
}

# Status symbol
status_symbol() {
    case "$1" in
        complete) echo "✓" ;;
        in_progress) echo "●" ;;
        pending) echo "○" ;;
        *) echo "?" ;;
    esac
}

echo ""
echo "Phase $PHASE_NUM Status"
echo "────────────────"

# Get root plan status
root_status=$(get_status "$PHASE_DIR/plan.md")
echo "plan.md       $(status_symbol "$root_status") $root_status"
echo ""

# Track counts
total=0
complete=0
in_progress=0
pending=0
active_task=""

# Iterate through sub-plans
for subplan_dir in "$PHASE_DIR"/*/; do
    [[ -d "$subplan_dir" ]] || continue
    
    letter=$(basename "$subplan_dir")
    [[ "$letter" =~ ^[a-z]$ ]] || continue
    
    # Get sub-plan index status
    index_status=$(get_status "$subplan_dir/index.md")
    
    # Iterate through task files
    for task_file in "$subplan_dir"/*.md; do
        [[ -f "$task_file" ]] || continue
        
        filename=$(basename "$task_file")
        [[ "$filename" == "index.md" ]] && continue
        
        # Only process roman numeral files
        [[ "$filename" =~ ^(i|ii|iii|iv|v|vi|vii|viii|ix|x)\.md$ ]] || continue
        
        task_status=$(get_status "$task_file")
        symbol=$(status_symbol "$task_status")
        
        # Track active task
        marker=""
        if [[ "$task_status" == "in_progress" ]]; then
            marker=" ← active"
            active_task="$letter/$filename"
        fi
        
        printf "%-12s %s %s%s\n" "$letter/$filename" "$symbol" "$task_status" "$marker"
        
        # Update counts
        ((total++)) || true
        case "$task_status" in
            complete) ((complete++)) || true ;;
            in_progress) ((in_progress++)) || true ;;
            pending) ((pending++)) || true ;;
        esac
    done
done

echo ""

# Calculate progress
if [[ $total -gt 0 ]]; then
    pct=$((complete * 100 / total))
    echo "Progress: $complete/$total tasks ($pct%)"
else
    echo "Progress: No tasks found"
fi

if [[ -n "$active_task" ]]; then
    echo "Active: $active_task"
fi

echo ""
