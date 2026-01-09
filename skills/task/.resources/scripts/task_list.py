#!/usr/bin/env python3
"""
task_list.py - List tasks with optional filters.

Lists tasks from a root directory with deterministic ordering.

Usage:
    python task_list.py --root tasks/
    python task_list.py --root tasks/ --stale
    python task_list.py --root tasks/ --validated --active
    python task_list.py --root tasks/ --json

Options:
    --stale         Show only stale tasks
    --validated     Show only validated tasks
    --active        Show only active tasks
    --inactive      Show only inactive tasks
    --sort          Sort field (default: created_at)
    --desc          Descending order (default)
    --asc           Ascending order
"""

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path


def parse_rfc3339(timestamp: str) -> datetime:
    """Parse RFC3339 timestamp to datetime."""
    if not timestamp:
        return datetime.min.replace(tzinfo=timezone.utc)
    timestamp = timestamp.replace("Z", "+00:00")
    try:
        return datetime.fromisoformat(timestamp)
    except ValueError:
        return datetime.min.replace(tzinfo=timezone.utc)


def read_frontmatter(task_file: Path) -> dict:
    """Read frontmatter from task file."""
    try:
        content = task_file.read_text(encoding="utf-8")
    except Exception:
        return {}
    
    if not content.startswith("---"):
        return {}
    
    parts = content.split("---", 2)
    if len(parts) < 3:
        return {}
    
    try:
        import yaml
        return yaml.safe_load(parts[1].strip()) or {}
    except ImportError:
        return _parse_simple_yaml(parts[1].strip())
    except Exception:
        return {}


def _parse_simple_yaml(raw: str) -> dict:
    """Simple YAML parser fallback."""
    result = {}
    for line in raw.split("\n"):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" in line:
            key, _, value = line.partition(":")
            value = value.strip().strip('"').strip("'")
            if value.lower() == "true":
                value = True
            elif value.lower() == "false":
                value = False
            result[key.strip()] = value
    return result


def discover_tasks(root: Path) -> list[dict]:
    """Discover all task directories under root."""
    tasks = []
    
    if not root.exists():
        return tasks
    
    for task_dir in root.iterdir():
        if not task_dir.is_dir():
            continue
        
        task_file = task_dir / "00_TASK.md"
        if not task_file.exists():
            continue
        
        frontmatter = read_frontmatter(task_file)
        if not frontmatter:
            continue
        
        tasks.append({
            "path": str(task_dir),
            "dir_name": task_dir.name,
            **frontmatter
        })
    
    return tasks


def filter_tasks(tasks: list[dict], filters: dict) -> list[dict]:
    """Apply filters to task list."""
    result = tasks
    
    if filters.get("stale"):
        result = [t for t in result if is_task_stale(t)]
    
    if filters.get("validated"):
        result = [t for t in result if t.get("epistemic_state") == "validated"]
    
    if filters.get("invalidated"):
        result = [t for t in result if t.get("epistemic_state") == "invalidated"]
    
    if filters.get("active"):
        result = [t for t in result if t.get("lifecycle_state") == "active"]
    
    if filters.get("inactive"):
        result = [t for t in result if t.get("lifecycle_state") == "inactive"]
    
    if filters.get("blocked"):
        result = [t for t in result if t.get("lifecycle_state") == "blocked"]
    
    if filters.get("completed"):
        result = [t for t in result if t.get("lifecycle_state") == "completed"]
    
    if filters.get("kind"):
        result = [t for t in result if t.get("kind") == filters["kind"]]
    
    return result


def is_task_stale(task: dict) -> bool:
    """Check if task is stale based on frontmatter."""
    now = datetime.now(timezone.utc)
    
    last_reviewed = task.get("last_reviewed_at")
    created = task.get("created_at")
    threshold = task.get("staleness_days_threshold", 14)
    expires = task.get("expires_at")
    
    if expires:
        expires_dt = parse_rfc3339(expires)
        if expires_dt < now:
            return True
    
    reference = parse_rfc3339(last_reviewed or created or "")
    if reference == datetime.min.replace(tzinfo=timezone.utc):
        return False
    
    days_since = (now - reference).days
    return days_since > threshold


def sort_tasks(tasks: list[dict], sort_field: str, descending: bool) -> list[dict]:
    """Sort tasks by field."""
    def get_sort_key(task):
        value = task.get(sort_field, "")
        if sort_field in ["created_at", "last_reviewed_at", "expires_at"]:
            return parse_rfc3339(value)
        return str(value).lower()
    
    return sorted(tasks, key=get_sort_key, reverse=descending)


def format_task_line(task: dict) -> str:
    """Format single task for display."""
    task_id = task.get("id", task.get("dir_name", "?"))
    title = task.get("title", "Untitled")[:50]
    epistemic = task.get("epistemic_state", "?")[:4]
    lifecycle = task.get("lifecycle_state", "?")[:6]
    created = task.get("created_at", "")[:10]
    
    stale_marker = "[STALE]" if is_task_stale(task) else ""
    
    return f"{task_id:<20} {epistemic:<6} {lifecycle:<8} {created:<12} {stale_marker:<8} {title}"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="List tasks with optional filters"
    )
    parser.add_argument(
        "--root",
        type=str,
        default="tasks/",
        help="Root directory containing task directories"
    )
    parser.add_argument("--stale", action="store_true", help="Show only stale tasks")
    parser.add_argument("--validated", action="store_true", help="Show only validated tasks")
    parser.add_argument("--invalidated", action="store_true", help="Show only invalidated tasks")
    parser.add_argument("--active", action="store_true", help="Show only active tasks")
    parser.add_argument("--inactive", action="store_true", help="Show only inactive tasks")
    parser.add_argument("--blocked", action="store_true", help="Show only blocked tasks")
    parser.add_argument("--completed", action="store_true", help="Show only completed tasks")
    parser.add_argument("--kind", type=str, help="Filter by kind")
    parser.add_argument("--sort", type=str, default="created_at", help="Sort field")
    parser.add_argument("--asc", action="store_true", help="Ascending order")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    parser.add_argument("--count", action="store_true", help="Output only count")

    args = parser.parse_args()
    root = Path(args.root)

    if not root.exists():
        print(f"Error: Root directory does not exist: {root}", file=sys.stderr)
        return 1

    tasks = discover_tasks(root)
    
    filters = {
        "stale": args.stale,
        "validated": args.validated,
        "invalidated": args.invalidated,
        "active": args.active,
        "inactive": args.inactive,
        "blocked": args.blocked,
        "completed": args.completed,
        "kind": args.kind
    }
    
    tasks = filter_tasks(tasks, filters)
    tasks = sort_tasks(tasks, args.sort, not args.asc)
    
    if args.count:
        print(len(tasks))
        return 0
    
    if args.json:
        output = [
            {
                "id": t.get("id", t.get("dir_name")),
                "title": t.get("title"),
                "path": t.get("path"),
                "epistemic_state": t.get("epistemic_state"),
                "lifecycle_state": t.get("lifecycle_state"),
                "created_at": t.get("created_at"),
                "is_stale": is_task_stale(t)
            }
            for t in tasks
        ]
        print(json.dumps(output, indent=2))
    else:
        if not tasks:
            print("No tasks found.")
        else:
            print(f"{'ID':<20} {'EPIST':<6} {'LIFE':<8} {'CREATED':<12} {'STATUS':<8} TITLE")
            print("-" * 80)
            for task in tasks:
                print(format_task_line(task))
            print(f"\nTotal: {len(tasks)} task(s)")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())
