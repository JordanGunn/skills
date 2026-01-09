#!/usr/bin/env bash
# Namespace Integrity Detection Script
# Scans a Python package for structural smells
#
# Usage:
#   ./detect.sh <target_path> [--pattern <pattern>] [--output <file>]
#
# Patterns:
#   utility-dump      - Scan for common/, utils/, helpers/ packages
#   stuttery-sibling  - Scan for modules with prefix matching sibling packages
#   thin-wrapper      - Scan for single-function modules
#   semantic-diffusion - Scan for duplicate module names
#   layer-bleeding    - Scan for upward imports across layers
#   all               - Run all patterns (default)
#
# Examples:
#   ./detect.sh pulsar/api
#   ./detect.sh pulsar/api --pattern utility-dump
#   ./detect.sh pulsar/api --pattern stuttery-sibling --output report.txt

set -euo pipefail

# Default values
TARGET=""
PATTERN="all"
OUTPUT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --pattern)
            PATTERN="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        -h|--help)
            head -20 "$0" | tail -18
            exit 0
            ;;
        *)
            TARGET="$1"
            shift
            ;;
    esac
done

if [[ -z "$TARGET" ]]; then
    echo "Error: Target path required"
    echo "Usage: $0 <target_path> [--pattern <pattern>]"
    exit 1
fi

if [[ ! -d "$TARGET" ]]; then
    echo "Error: Target directory does not exist: $TARGET"
    exit 1
fi

# Output helper
output() {
    if [[ -n "$OUTPUT" ]]; then
        echo "$1" >> "$OUTPUT"
    else
        echo "$1"
    fi
}

# Initialize output file
if [[ -n "$OUTPUT" ]]; then
    echo "# Namespace Integrity Scan: $TARGET" > "$OUTPUT"
    echo "# Pattern: $PATTERN" >> "$OUTPUT"
    echo "# Date: $(date -Iseconds)" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
fi

# Pattern: Utility Dump
scan_utility_dump() {
    output "## Utility Dump Candidates"
    output ""
    local found=0
    
    while IFS= read -r dir; do
        if [[ -n "$dir" ]]; then
            found=1
            output "- \`$dir\`"
            # Check contents
            local file_count
            file_count=$(find "$dir" -maxdepth 1 -name "*.py" -type f | wc -l)
            if [[ "$file_count" -eq 1 ]]; then
                output "  - Contains only \`__init__.py\` (possible obsolete shim)"
            else
                output "  - Contains $file_count Python files"
            fi
        fi
    done < <(find "$TARGET" -type d \( \
        -name "common" -o \
        -name "utils" -o \
        -name "helpers" -o \
        -name "core" -o \
        -name "shared" -o \
        -name "misc" -o \
        -name "internal" -o \
        -name "lib" \
    \) 2>/dev/null)
    
    if [[ $found -eq 0 ]]; then
        output "No utility dump packages found."
    fi
    output ""
}

# Pattern: Stuttery Sibling
scan_stuttery_sibling() {
    output "## Stuttery Sibling Candidates"
    output ""
    local found=0
    
    while IFS= read -r dir; do
        [[ -d "$dir" ]] || continue
        for file in "$dir"/*.py; do
            [[ -f "$file" ]] || continue
            local base
            base=$(basename "$file" .py)
            [[ "$base" == "__init__" ]] && continue
            
            # Extract underscore-delimited prefix
            local prefix
            prefix=$(echo "$base" | cut -d'_' -f1)
            
            # Check if sibling directory exists
            if [[ -d "$dir/$prefix" ]]; then
                found=1
                output "- \`$file\`"
                output "  - Sibling package: \`$dir/$prefix/\`"
                output "  - Suggested move: \`$dir/$prefix/${base#${prefix}_}.py\`"
            fi
        done
    done < <(find "$TARGET" -type d 2>/dev/null)
    
    if [[ $found -eq 0 ]]; then
        output "No stuttery sibling modules found."
    fi
    output ""
}

# Pattern: Thin Wrapper
scan_thin_wrapper() {
    output "## Thin Wrapper Candidates"
    output ""
    local found=0
    
    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        local base
        base=$(basename "$file" .py)
        [[ "$base" == "__init__" ]] && continue
        
        # Count public functions (def statements not starting with _)
        local public_funcs
        public_funcs=$(grep -cE "^def [a-z]" "$file" 2>/dev/null | tr -d '[:space:]' || echo 0)
        [[ -z "$public_funcs" ]] && public_funcs=0
        
        # Count lines (excluding blank and comments)
        local code_lines
        code_lines=$(grep -cvE "^[[:space:]]*(#|$)" "$file" 2>/dev/null | tr -d '[:space:]' || echo 0)
        [[ -z "$code_lines" ]] && code_lines=0
        
        if [[ "$public_funcs" -eq 1 ]] && [[ "$code_lines" -lt 50 ]]; then
            found=1
            output "- \`$file\`"
            output "  - Public functions: $public_funcs"
            output "  - Code lines: $code_lines"
        fi
    done < <(find "$TARGET" -name "*.py" -type f 2>/dev/null)
    
    if [[ $found -eq 0 ]]; then
        output "No thin wrapper modules found."
    fi
    output ""
}

# Pattern: Semantic Diffusion
scan_semantic_diffusion() {
    output "## Semantic Diffusion Candidates"
    output ""
    local found=0
    
    # Find duplicate module names
    local dupes
    dupes=$(find "$TARGET" -name "*.py" -type f -exec basename {} \; 2>/dev/null | \
            grep -v "__init__.py" | sort | uniq -d)
    
    for dupe in $dupes; do
        found=1
        output "- \`$dupe\` appears in multiple locations:"
        find "$TARGET" -name "$dupe" -type f 2>/dev/null | while read -r loc; do
            output "  - \`$loc\`"
        done
    done
    
    if [[ $found -eq 0 ]]; then
        output "No duplicate module names found."
    fi
    output ""
}

# Pattern: Layer Bleeding
scan_layer_bleeding() {
    output "## Layer Bleeding Candidates"
    output ""
    local found=0
    
    # Define layer boundaries (lower layers should not import from higher)
    # data < io < engine < processor < cli
    
    # Check io importing from processor or engine
    if [[ -d "$TARGET/io" ]]; then
        local io_violations
        io_violations=$(grep -r "from.*\.processor" "$TARGET/io" 2>/dev/null || true)
        if [[ -n "$io_violations" ]]; then
            found=1
            output "### io/ importing from processor/"
            output "\`\`\`"
            output "$io_violations"
            output "\`\`\`"
            output ""
        fi
        
        io_violations=$(grep -r "from.*\.engine" "$TARGET/io" 2>/dev/null | \
                        grep -v "engine.plan.load" || true)  # load_plan is acceptable
        if [[ -n "$io_violations" ]]; then
            found=1
            output "### io/ importing from engine/"
            output "\`\`\`"
            output "$io_violations"
            output "\`\`\`"
            output ""
        fi
    fi
    
    # Check data importing from io, engine, or processor
    if [[ -d "$TARGET/data" ]]; then
        local data_violations
        data_violations=$(grep -r "from.*\.io\." "$TARGET/data" 2>/dev/null || true)
        data_violations+=$(grep -r "from.*\.engine" "$TARGET/data" 2>/dev/null || true)
        data_violations+=$(grep -r "from.*\.processor" "$TARGET/data" 2>/dev/null || true)
        if [[ -n "$data_violations" ]]; then
            found=1
            output "### data/ importing from higher layers"
            output "\`\`\`"
            output "$data_violations"
            output "\`\`\`"
            output ""
        fi
    fi
    
    if [[ $found -eq 0 ]]; then
        output "No obvious layer bleeding found."
    fi
    output ""
}

# Run selected patterns
output "# Namespace Integrity Scan Results"
output ""
output "**Target:** \`$TARGET\`"
output "**Pattern:** $PATTERN"
output "**Date:** $(date)"
output ""
output "---"
output ""

case "$PATTERN" in
    utility-dump)
        scan_utility_dump
        ;;
    stuttery-sibling)
        scan_stuttery_sibling
        ;;
    thin-wrapper)
        scan_thin_wrapper
        ;;
    semantic-diffusion)
        scan_semantic_diffusion
        ;;
    layer-bleeding)
        scan_layer_bleeding
        ;;
    all)
        scan_utility_dump
        scan_stuttery_sibling
        scan_thin_wrapper
        scan_semantic_diffusion
        scan_layer_bleeding
        ;;
    *)
        echo "Unknown pattern: $PATTERN"
        echo "Valid patterns: utility-dump, stuttery-sibling, thin-wrapper, semantic-diffusion, layer-bleeding, all"
        exit 1
        ;;
esac

output "---"
output ""
output "Scan complete. Review candidates and consult skill references for analysis guidance."
