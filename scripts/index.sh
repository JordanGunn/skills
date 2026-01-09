#!/usr/bin/env bash
#
# index.sh — Generate a skill index from all SKILL.md files
#
# Usage: ./index.sh [skills_dir] [output_file]
#   skills_dir:  Directory to scan (default: .codex/skills)
#   output_file: Output index file (default: .codex/skills/INDEX.md)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SKILLS_DIR="${1:-$REPO_ROOT/.codex/skills}"
OUTPUT_FILE="${2:-$SKILLS_DIR/INDEX.md}"

# Temporary files for collecting data
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

QUICK_REF="$TMP_DIR/quick_ref.txt"
SKILLSETS="$TMP_DIR/skillsets.txt"
STANDALONE="$TMP_DIR/standalone.txt"
KEYWORDS="$TMP_DIR/keywords.txt"

touch "$QUICK_REF" "$SKILLSETS" "$STANDALONE" "$KEYWORDS"

# Extract value from YAML frontmatter (handles single-line and folded scalar start)
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
            if ($0 != "") { print; capture = 0 }
            next
        }
        capture && /^[[:space:]]+/ {
            sub(/^[[:space:]]+/, "")
            print
            capture = 0
        }
        capture && /^[a-z]/ { capture = 0 }
    ' "$file" | head -1 | cut -c1-100
}

# Extract skillset member skills (specifically under skillset.skills:)
yaml_skillset_members() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^[[:space:]]+skills:/ && in_skillset { capture = 1; next }
        in_front && /^[[:space:]]+skillset:/ { in_skillset = 1; next }
        in_front && capture && /^[[:space:]]+-[[:space:]]/ {
            sub(/^[[:space:]]+-[[:space:]]*/, "")
            # Only print if it looks like a skill name (has hyphen, no brackets)
            if ($0 ~ /^[a-z]+-[a-z]/ && $0 !~ /^\[/) print
        }
        in_front && capture && /^[[:space:]]+[a-z]+:/ && !/^[[:space:]]+-/ { capture = 0 }
    ' "$file"
}

# Extract keywords from metadata.keywords:
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

# Check if file has skillset metadata (is an orchestrator)
is_skillset() {
    local file="$1"
    grep -q "skillset:" "$file" && grep -q "skills:" "$file"
}

# Extract default pipeline from skillset.pipelines.default:
yaml_pipeline() {
    local file="$1"
    awk '
        /^---$/ { in_front = !in_front; next }
        in_front && /^[[:space:]]+default:$/ && in_pipelines { capture = 1; next }
        in_front && /^[[:space:]]+pipelines:/ { in_pipelines = 1; next }
        in_front && capture && /^[[:space:]]+-[[:space:]]/ {
            sub(/^[[:space:]]+-[[:space:]]*/, "")
            # Only print skill names (has hyphen, no brackets)
            if ($0 ~ /^[a-z]+-[a-z]/ && $0 !~ /^\[/) print
        }
        in_front && capture && /^[[:space:]]+[a-z]+:/ && !/^[[:space:]]+-/ { exit }
    ' "$file" | paste -sd ' -> ' -
}

echo "Scanning $SKILLS_DIR for SKILL.md files..."

# Track known skillsets for member detection
SKILLSET_NAMES="$TMP_DIR/skillset_names.txt"
touch "$SKILLSET_NAMES"

# Pass 1: Identify skillsets first
while IFS= read -r skill_file; do
    [[ "$(dirname "${skill_file#$SKILLS_DIR/}")" == "index-skills" ]] && continue
    name=$(yaml_value "$skill_file" "name")
    [[ -z "$name" ]] && continue
    is_skillset "$skill_file" && echo "$name" >> "$SKILLSET_NAMES"
done < <(find "$SKILLS_DIR" -name "SKILL.md" -type f | sort)

# Pass 2: Process all skills with skillset knowledge
while IFS= read -r skill_file; do
    rel_path="${skill_file#$SKILLS_DIR/}"
    skill_dir="$(dirname "$rel_path")"
    
    # Skip index-skills itself
    [[ "$skill_dir" == "index-skills" ]] && continue
    
    name=$(yaml_value "$skill_file" "name")
    desc=$(yaml_description "$skill_file")
    
    [[ -z "$name" ]] && continue
    
    # Determine type
    if is_skillset "$skill_file"; then
        echo "$name|$skill_dir|skillset|$desc" >> "$QUICK_REF"
        
        members=$(yaml_skillset_members "$skill_file" | paste -sd ',' -)
        pipeline=$(yaml_pipeline "$skill_file")
        
        {
            echo "SKILLSET:$name"
            echo "PATH:$skill_dir"
            echo "DESC:$desc"
            echo "MEMBERS:$members"
            echo "PIPELINE:$pipeline"
            echo "---"
        } >> "$SKILLSETS"
    elif [[ "$name" == *-* ]] && grep -qF "${name%%-*}" "$SKILLSET_NAMES" 2>/dev/null; then
        # Member of a skillset
        echo "$name|$skill_dir|member|$desc" >> "$QUICK_REF"
    else
        echo "$name|$skill_dir|standalone|$desc" >> "$QUICK_REF"
        
        keywords=$(yaml_keywords "$skill_file" | paste -sd ',' -)
        
        {
            echo "SKILL:$name"
            echo "PATH:$skill_dir"
            echo "DESC:$desc"
            echo "KEYWORDS:$keywords"
            echo "---"
        } >> "$STANDALONE"
    fi
    
    # Collect keywords for index
    while IFS= read -r kw; do
        [[ -n "$kw" ]] && echo "$kw|$name" >> "$KEYWORDS"
    done < <(yaml_keywords "$skill_file")
    
done < <(find "$SKILLS_DIR" -name "SKILL.md" -type f | sort)

# Generate INDEX.md
{
    cat << 'HEADER'
# Skill Index

> Auto-generated. Do not edit manually.
> Regenerate with: `.codex/scripts/index.sh`

---

## Quick Reference

| Skill | Path | Type |
|-------|------|------|
HEADER

    # Quick reference table
    sort -t'|' -k1 "$QUICK_REF" | while IFS='|' read -r name path type desc; do
        echo "| \`$name\` | \`$path/\` | $type |"
    done

    echo ""
    echo "---"
    echo ""
    echo "## Skillsets"
    echo ""

    # Skillsets section
    current_skillset=""
    while IFS= read -r line; do
        case "$line" in
            SKILLSET:*)
                current_skillset="${line#SKILLSET:}"
                echo "### \`$current_skillset\`"
                echo ""
                ;;
            PATH:*)
                echo "**Path:** \`${line#PATH:}/\`"
                ;;
            DESC:*)
                desc="${line#DESC:}"
                [[ -n "$desc" ]] && echo "> $desc"
                echo ""
                ;;
            MEMBERS:*)
                members="${line#MEMBERS:}"
                echo "**Members:** \`${members//,/\`, \`}\`"
                ;;
            PIPELINE:*)
                pipeline="${line#PIPELINE:}"
                [[ -n "$pipeline" ]] && echo "**Default Pipeline:** $pipeline"
                echo ""
                ;;
            ---) 
                # Print member details from quick ref
                if [[ -n "$current_skillset" ]]; then
                    echo "#### Members"
                    echo ""
                    grep "|member|" "$QUICK_REF" | grep "^${current_skillset}-" | while IFS='|' read -r mname mpath mtype mdesc; do
                        echo "- **\`$mname\`** — $mdesc"
                    done
                    echo ""
                    echo "---"
                    echo ""
                fi
                ;;
        esac
    done < "$SKILLSETS"

    echo "## Standalone Skills"
    echo ""

    # Standalone skills section
    while IFS= read -r line; do
        case "$line" in
            SKILL:*)
                echo "### \`${line#SKILL:}\`"
                echo ""
                ;;
            PATH:*)
                echo "**Path:** \`${line#PATH:}/\`"
                ;;
            DESC:*)
                desc="${line#DESC:}"
                [[ -n "$desc" ]] && echo "> $desc"
                echo ""
                ;;
            KEYWORDS:*)
                kws="${line#KEYWORDS:}"
                [[ -n "$kws" ]] && echo "**Keywords:** \`${kws//,/\`, \`}\`"
                echo ""
                echo "---"
                echo ""
                ;;
        esac
    done < "$STANDALONE"

    echo "## Keyword Index"
    echo ""
    echo "| Keyword | Skills |"
    echo "|---------|--------|"

    # Keyword index (aggregate skills per keyword)
    sort -t'|' -k1 "$KEYWORDS" | awk -F'|' '
        {
            if ($1 != prev_kw && prev_kw != "") {
                printf "| `%s` | %s |\n", prev_kw, skills
                skills = ""
            }
            prev_kw = $1
            skills = (skills == "") ? "`" $2 "`" : skills ", `" $2 "`"
        }
        END {
            if (prev_kw != "") printf "| `%s` | %s |\n", prev_kw, skills
        }
    '

} > "$OUTPUT_FILE"

echo "Generated: $OUTPUT_FILE"
