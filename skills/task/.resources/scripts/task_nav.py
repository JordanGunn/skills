#!/usr/bin/env python3
"""
task_nav.py - Navigate between tasks in deterministic order.

Implements --next and --prev relative to chronological ordering.

Usage:
    python task_nav.py --root tasks/ --next task-id
    python task_nav.py --root tasks/ --prev task-id
    python task_nav.py --root tasks/ --first
    python task_nav.py --root tasks/ --last

Output:
    Task ID of the next/previous task, or empty if at boundary
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
            result[key.strip()] = value.strip().strip('"').strip("'")
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
        
        task_id = frontmatter.get("id", task_dir.name)
        tasks.append({
            "id": task_id,
            "path": str(task_dir),
            "dir_name": task_dir.name,
            "created_at": frontmatter.get("created_at", "")
        })
    
    return tasks


def sort_tasks_chronologically(tasks: list[dict], descending: bool = True) -> list[dict]:
    """Sort tasks by created_at timestamp."""
    def get_sort_key(task):
        return parse_rfc3339(task.get("created_at", ""))
    
    return sorted(tasks, key=get_sort_key, reverse=descending)


def find_task_index(tasks: list[dict], task_id: str) -> int:
    """Find index of task by ID."""
    for i, task in enumerate(tasks):
        if task["id"] == task_id or task["dir_name"] == task_id:
            return i
    return -1


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Navigate between tasks in deterministic order"
    )
    parser.add_argument(
        "--root",
        type=str,
        default="tasks/",
        help="Root directory containing task directories"
    )
    parser.add_argument("--next", dest="next_id", type=str, help="Get task after this ID")
    parser.add_argument("--prev", dest="prev_id", type=str, help="Get task before this ID")
    parser.add_argument("--first", action="store_true", help="Get first task (newest)")
    parser.add_argument("--last", action="store_true", help="Get last task (oldest)")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    parser.add_argument("--path", action="store_true", help="Output path instead of ID")

    args = parser.parse_args()
    root = Path(args.root)

    if not root.exists():
        print(f"Error: Root directory does not exist: {root}", file=sys.stderr)
        return 1

    tasks = discover_tasks(root)
    if not tasks:
        if args.json:
            print(json.dumps({"error": "No tasks found", "result": None}))
        else:
            print("No tasks found.", file=sys.stderr)
        return 1

    tasks = sort_tasks_chronologically(tasks, descending=True)
    
    result_task = None
    
    if args.first:
        result_task = tasks[0]
    elif args.last:
        result_task = tasks[-1]
    elif args.next_id:
        idx = find_task_index(tasks, args.next_id)
        if idx == -1:
            if args.json:
                print(json.dumps({"error": f"Task not found: {args.next_id}", "result": None}))
            else:
                print(f"Error: Task not found: {args.next_id}", file=sys.stderr)
            return 1
        if idx + 1 < len(tasks):
            result_task = tasks[idx + 1]
    elif args.prev_id:
        idx = find_task_index(tasks, args.prev_id)
        if idx == -1:
            if args.json:
                print(json.dumps({"error": f"Task not found: {args.prev_id}", "result": None}))
            else:
                print(f"Error: Task not found: {args.prev_id}", file=sys.stderr)
            return 1
        if idx > 0:
            result_task = tasks[idx - 1]
    else:
        print("Error: Must specify --next, --prev, --first, or --last", file=sys.stderr)
        return 1

    if result_task:
        if args.json:
            print(json.dumps({
                "result": result_task["id"],
                "path": result_task["path"],
                "created_at": result_task["created_at"]
            }))
        elif args.path:
            print(result_task["path"])
        else:
            print(result_task["id"])
        return 0
    else:
        if args.json:
            print(json.dumps({"result": None, "reason": "At boundary"}))
        return 0


if __name__ == "__main__":
    sys.exit(main())
