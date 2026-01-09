#!/usr/bin/env bash
#
# cursor.sh — Generate Cursor commands from agent skills
#
# Usage: ./cursor.sh [skills_dir] [commands_dir]
#   skills_dir:   Directory containing skills (default: skills/)
#   commands_dir: Output directory for commands (default: .cursor)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SKILLS_DIR="${1:-$REPO_ROOT/skills}"
COMMANDS_DIR="${2:-$REPO_ROOT/.cursor/commands}"

# Ensure output directory exists
mkdir -p "$COMMANDS_DIR"

# Skip these skills (meta-skills, not user-facing)
SKIP_PATTERNS="^index$|index-skills|adapter"

# Extract value from YAML frontmatter
yaml_value() {
    local file="$1" key="$2"
    awk -v key="$key" '
        /^---$/ { in_front = !in_front; next }
        in_front && $0 ~ "^" key ":" {
            sub("^" key ":[[:space:]]*[>|]?[[:space:]]*", "")
            if ($0 != "") print
            next
        }
    ' "$file" | head -1
}

# Extract multi-line description
yaml_description() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^description:/ {
            capture = 1
            sub(/^description:[[:space:]]*[>|]?[[:space:]]*/, "")
            if ($0 != "") { print; exit }
            next
        }
        capture && /^[[:space:]]+/ {
            sub(/^[[:space:]]+/, "")
            print
            exit
        }
        capture && /^[a-z]/ { exit }
    ' "$file" | head -1
}

# Extract keywords list
yaml_keywords() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^[[:space:]]+keywords:/ { capture = 1; next }
        in_front && capture && /^[[:space:]]+-[[:space:]]/ {
            sub(/^[[:space:]]+-[[:space:]]*/, "")
            gsub(/["\047]/, "")
            print
        }
        in_front && capture && /^[[:space:]]*[a-z]+:/ && !/^[[:space:]]+-/ { capture = 0 }
    ' "$file"
}

# Extract skillset members
yaml_skillset_members() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^[[:space:]]+skills:$/ && in_skillset { capture = 1; next }
        in_front && /^[[:space:]]+skillset:$/ { in_skillset = 1; next }
        in_front && capture && /^[[:space:]]+-[[:space:]]/ {
            sub(/^[[:space:]]+-[[:space:]]*/, "")
            if ($0 ~ /^[a-z]+-[a-z]+(-[a-z]+)*$/) print
        }
        in_front && capture && /^[[:space:]]+[a-z]+:/ && !/^[[:space:]]+-/ { capture = 0 }
    ' "$file"
}

# Extract default pipeline
yaml_pipeline() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^[[:space:]]+default:$/ && in_pipelines { capture = 1; next }
        in_front && /^[[:space:]]+pipelines:$/ { in_pipelines = 1; next }
        in_front && capture && /^[[:space:]]+-[[:space:]]/ {
            sub(/^[[:space:]]+-[[:space:]]*/, "")
            if ($0 ~ /^[a-z]+-[a-z]+(-[a-z]+)*$/) print
        }
        in_front && capture && /^[[:space:]]+[a-z]+:/ && !/^[[:space:]]+-/ { exit }
    ' "$file" | tr '\n' '|' | sed 's/|$//; s/|/ -> /g'
}

# Check if file has skillset metadata
is_skillset() {
    local file="$1"
    grep -q "skillset:" "$file" && grep -q "skills:" "$file"
}

# Extract references list
yaml_references() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^[[:space:]]+references:/ { capture = 1; next }
        in_front && capture && /^[[:space:]]+-[[:space:]]/ {
            sub(/^[[:space:]]+-[[:space:]]*/, "")
            gsub(/["\047]/, "")
            print
        }
        in_front && capture && /^[[:space:]]*[a-z]+:/ && !/^[[:space:]]+-/ { capture = 0 }
    ' "$file"
}

# Generate command for a single skill
generate_command() {
    local skill_file="$1"
    local rel_path="$2"
    local skill_dir="$3"
    
    local name=$(yaml_value "$skill_file" "name")
    local desc=$(yaml_description "$skill_file")
    local command_file="$COMMANDS_DIR/${name}.md"
    
    [[ -z "$name" ]] && return
    
    # Collect keywords
    local keywords=$(yaml_keywords "$skill_file" | tr '\n' '|' | sed 's/|$//; s/|/, /g')
    
    # Check for scripts directory
    local has_scripts=""
    [[ -d "$(dirname "$skill_file")/scripts" ]] && has_scripts="yes"
    
    # Generate the command (plain markdown, no frontmatter)
    {
        echo "# ${name}"
        echo ""
        echo "$desc"
        echo ""
        echo "## Instructions"
        echo ""
        echo "1. Read the skill manifest: \`skills/${skill_dir}/SKILL.md\`"
        echo "2. Read all references in order:"
        
        # List references
        while IFS= read -r ref; do
            [[ -n "$ref" ]] && echo "   - \`references/${ref}\`"
        done < <(yaml_references "$skill_file")
        
        if [[ -n "$has_scripts" ]]; then
            echo "3. If scripts are present in \`scripts/\`, follow automated steps first"
            echo "4. Execute the skill procedure as documented"
            echo "5. Produce output in the format specified by the skill"
        else
            echo "3. Execute the skill procedure as documented"
            echo "4. Produce output in the format specified by the skill"
        fi
        echo ""
        echo "## Skill Location"
        echo ""
        echo "**Path:** \`skills/${skill_dir}/\`"
        echo ""
        
        # Add skillset-specific info
        if is_skillset "$skill_file"; then
            local members=$(yaml_skillset_members "$skill_file" | tr '\n' '|' | sed 's/|$//; s/|/, /g')
            local pipeline=$(yaml_pipeline "$skill_file")
            
            echo "## Skillset"
            echo ""
            echo "This is an orchestrator skill with member skills."
            echo ""
            echo "- **Members:** ${members}"
            if [[ -n "$pipeline" ]]; then
                echo "- **Default Pipeline:** ${pipeline}"
            fi
            echo ""
        fi
        
        if [[ -n "$keywords" ]]; then
            echo "## Keywords"
            echo ""
            printf '%s' "${keywords}"
        fi
    } > "$command_file"
    echo "" >> "$command_file"
    
    echo "Generated: $command_file"
}

echo "Generating Cursor commands from agent skills..."
echo "  Skills: $SKILLS_DIR"
echo "  Output: $COMMANDS_DIR"
echo ""

# Process all SKILL.md files
count=0
while IFS= read -r skill_file; do
    rel_path="${skill_file#$SKILLS_DIR/}"
    skill_dir="$(dirname "$rel_path")"
    
    # Skip meta-skills
    if echo "$skill_dir" | grep -qE "$SKIP_PATTERNS"; then
        echo "Skipping: $skill_dir (meta-skill)"
        continue
    fi
    
    generate_command "$skill_file" "$rel_path" "$skill_dir"
    ((count++)) || true
    
done < <(find "$SKILLS_DIR" -name "SKILL.md" -type f | sort)

echo ""
echo "Generated $count command(s)"
