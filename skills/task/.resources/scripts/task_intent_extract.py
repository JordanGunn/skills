#!/usr/bin/env python3
"""
task_intent_extract.py - Extract canonical intent blob from a task.

Extracts and canonicalizes the intent surface from 00_TASK.md for hashing.

Canonicalization (v1):
- Normalize line endings to \\n
- Trim trailing whitespace from each line
- Collapse multiple blank lines to single blank line
- Parse YAML frontmatter and re-emit with sorted keys
- Include canonical body sections (Goal, Acceptance, Constraints, Dependencies)
- Exclude Evidence section (not part of canonical intent)

Usage:
    python task_intent_extract.py --task /path/to/task-dir

Output:
    Canonical intent blob to stdout
"""

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


def parse_frontmatter(content: str) -> tuple[dict[str, Any], str]:
    """Parse YAML frontmatter from markdown content."""
    if not content.startswith("---"):
        raise ValueError("Missing frontmatter delimiter at start of file")
    
    parts = content.split("---", 2)
    if len(parts) < 3:
        raise ValueError("Missing closing frontmatter delimiter")
    
    frontmatter_raw = parts[1].strip()
    body = parts[2]
    
    try:
        import yaml
        frontmatter = yaml.safe_load(frontmatter_raw)
        if frontmatter is None:
            frontmatter = {}
    except ImportError:
        frontmatter = _parse_simple_yaml(frontmatter_raw)
    
    return frontmatter, body


def _parse_simple_yaml(raw: str) -> dict[str, Any]:
    """Simple YAML parser for basic key-value pairs (fallback)."""
    result = {}
    current_key = None
    current_list = None
    
    for line in raw.split("\n"):
        line = line.rstrip()
        if not line or line.startswith("#"):
            continue
        
        if line.startswith("  - "):
            if current_list is not None:
                current_list.append(line[4:].strip().strip('"').strip("'"))
            continue
        
        if line.startswith("- "):
            if current_list is not None:
                current_list.append(line[2:].strip().strip('"').strip("'"))
            continue
        
        if ":" in line:
            key, _, value = line.partition(":")
            key = key.strip()
            value = value.strip().strip('"').strip("'")
            
            if value == "" or value == "|" or value == ">":
                current_key = key
                current_list = []
                result[key] = current_list
            else:
                result[key] = value
                current_key = None
                current_list = None
    
    return result


def serialize_frontmatter_canonical(fm: dict[str, Any]) -> str:
    """Serialize frontmatter with sorted keys for deterministic output."""
    intent_fields = [
        "id", "title", "kind", "scope", "risk",
        "epistemic_state", "confidence", "origin", "lifecycle_state",
        "created_at", "intent_hash", "intent_hash_algo", "intent_hash_scope",
        "depends_on", "blocked_by", "tags"
    ]
    
    lines = []
    for key in sorted(fm.keys()):
        if key not in intent_fields:
            continue
        value = fm[key]
        if isinstance(value, list):
            lines.append(f"{key}:")
            for item in value:
                lines.append(f"  - {item}")
        elif isinstance(value, bool):
            lines.append(f"{key}: {str(value).lower()}")
        elif value is None:
            lines.append(f"{key}: null")
        else:
            if isinstance(value, str) and ("\n" in value or ":" in value or '"' in value):
                lines.append(f'{key}: "{value}"')
            else:
                lines.append(f"{key}: {value}")
    
    return "\n".join(lines)


def extract_canonical_sections(body: str) -> str:
    """Extract canonical intent sections from body (Goal, Acceptance, Constraints, Dependencies)."""
    canonical_headers = ["Goal", "Acceptance", "Constraints", "Dependencies"]
    exclude_headers = ["Evidence"]
    
    lines = body.split("\n")
    result_lines = []
    in_canonical_section = False
    current_header = None
    
    for line in lines:
        header_match = re.match(r"^##\s+(.+)$", line.strip())
        if header_match:
            header_name = header_match.group(1).strip()
            if header_name in canonical_headers:
                in_canonical_section = True
                current_header = header_name
                result_lines.append(line)
            elif header_name in exclude_headers:
                in_canonical_section = False
                current_header = None
            else:
                in_canonical_section = False
                current_header = None
        elif in_canonical_section:
            if not line.strip().startswith("<!--") and not line.strip().endswith("-->"):
                if "<!--" not in line:
                    result_lines.append(line)
    
    return "\n".join(result_lines)


def canonicalize_text(text: str) -> str:
    """Apply canonical transformations to text."""
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    text = "\n".join(lines)
    text = re.sub(r"\n{3,}", "\n\n", text)
    text = text.strip()
    return text


def extract_canonical_intent(task_dir: Path) -> str:
    """Extract canonical intent blob from task directory."""
    task_file = task_dir / "00_TASK.md"
    
    if not task_file.exists():
        raise FileNotFoundError(f"00_TASK.md not found in {task_dir}")
    
    content = task_file.read_text(encoding="utf-8")
    frontmatter, body = parse_frontmatter(content)
    
    required_fields = ["id", "title", "kind", "scope", "risk", "epistemic_state", 
                       "confidence", "origin", "lifecycle_state", "created_at"]
    missing = [f for f in required_fields if f not in frontmatter]
    if missing:
        raise ValueError(f"Missing required frontmatter fields: {', '.join(missing)}")
    
    canonical_fm = serialize_frontmatter_canonical(frontmatter)
    canonical_body = extract_canonical_sections(body)
    canonical_blob = f"---\n{canonical_fm}\n---\n{canonical_body}"
    canonical_blob = canonicalize_text(canonical_blob)
    
    return canonical_blob


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract canonical intent blob from a task"
    )
    parser.add_argument(
        "--task",
        type=str,
        required=True,
        help="Path to task directory"
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output as JSON object with blob and metadata"
    )

    args = parser.parse_args()
    task_dir = Path(args.task)

    if not task_dir.exists():
        print(f"Error: Task directory does not exist: {task_dir}", file=sys.stderr)
        return 1

    if not task_dir.is_dir():
        print(f"Error: Path is not a directory: {task_dir}", file=sys.stderr)
        return 1

    try:
        canonical_blob = extract_canonical_intent(task_dir)
        
        if args.json:
            output = {
                "task_dir": str(task_dir),
                "canonical_blob": canonical_blob,
                "blob_length": len(canonical_blob)
            }
            print(json.dumps(output, indent=2))
        else:
            print(canonical_blob)
        
        return 0
    except FileNotFoundError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
