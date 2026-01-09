#!/usr/bin/env python3
"""
create.py - Create a new task directory with 00_TASK.md.

Usage:
    python create.py --root tasks/ --id implement-auth --title "Implement authentication" \
        --kind feature --scope moderate --risk medium --origin human

Options:
    --root      Root directory for tasks (default: tasks/)
    --id        Task ID (required)
    --title     Task title (required)
    --kind      Task kind (required)
    --scope     Task scope (required)
    --risk      Task risk level (required)
    --origin    Task origin (required)
    --goal      Goal statement (optional)
    --expires   Expiry date RFC3339 (optional)
    --staleness Staleness threshold in days (optional)
"""

import argparse
import hashlib
import re
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path


VALID_KINDS = ["feature", "bugfix", "refactor", "research", "documentation", "maintenance", "exploration", "spike"]
VALID_SCOPES = ["trivial", "minor", "moderate", "major", "epic"]
VALID_RISKS = ["none", "low", "medium", "high", "critical"]
VALID_ORIGINS = ["human", "agent", "mixed"]


def get_utc_now_rfc3339() -> str:
    """Return current UTC time in RFC3339 format."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def validate_id(task_id: str) -> tuple[bool, str]:
    """Validate task ID format."""
    if not task_id:
        return False, "ID cannot be empty"
    if len(task_id) > 64:
        return False, "ID must be 64 characters or less"
    if not re.match(r"^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$", task_id):
        return False, "ID must be lowercase letters, numbers, and hyphens (no leading/trailing hyphens)"
    if "--" in task_id:
        return False, "ID cannot contain consecutive hyphens"
    return True, "Valid"


def compute_hash(canonical_blob: str) -> str:
    """Compute SHA256 hash of canonical intent."""
    return hashlib.sha256(canonical_blob.encode("utf-8")).hexdigest()


def create_task(
    root: Path,
    task_id: str,
    title: str,
    kind: str,
    scope: str,
    risk: str,
    origin: str,
    goal: str = "",
    expires_at: str = "",
    staleness_days: int = None
) -> tuple[bool, str]:
    """Create a new task directory."""
    
    valid, msg = validate_id(task_id)
    if not valid:
        return False, f"Invalid ID: {msg}"
    
    if kind not in VALID_KINDS:
        return False, f"Invalid kind: {kind} (valid: {VALID_KINDS})"
    if scope not in VALID_SCOPES:
        return False, f"Invalid scope: {scope} (valid: {VALID_SCOPES})"
    if risk not in VALID_RISKS:
        return False, f"Invalid risk: {risk} (valid: {VALID_RISKS})"
    if origin not in VALID_ORIGINS:
        return False, f"Invalid origin: {origin} (valid: {VALID_ORIGINS})"
    
    task_dir = root / task_id
    if task_dir.exists():
        return False, f"Task directory already exists: {task_dir}"
    
    created_at = get_utc_now_rfc3339()
    
    staleness_line = ""
    if staleness_days:
        staleness_line = f"staleness_days_threshold: {staleness_days}\n"
    
    expires_line = ""
    if expires_at:
        expires_line = f'expires_at: "{expires_at}"\n'
    
    goal_text = goal if goal else "<!-- Define the desired outcome -->"
    
    content = f'''---
id: "{task_id}"
title: "{title}"
kind: "{kind}"
scope: "{scope}"
risk: "{risk}"
epistemic_state: candidate
confidence: low
origin: "{origin}"
lifecycle_state: inactive
created_at: "{created_at}"
{staleness_line}{expires_line}intent_hash: "PENDING"
intent_hash_algo: sha256-v1
intent_hash_scope: canonical-intent
---

# {title}

## Goal

{goal_text}

## Acceptance

- [ ] Define acceptance criteria

## Constraints

- Define constraints

## Dependencies

- None

## Evidence

- (To be filled upon completion)
'''
    
    task_dir.mkdir(parents=True, exist_ok=True)
    task_file = task_dir / "00_TASK.md"
    task_file.write_text(content, encoding="utf-8")
    
    canonical_blob = create_canonical_blob(task_id, title, kind, scope, risk, origin, created_at, goal_text)
    intent_hash = compute_hash(canonical_blob)
    
    updated_content = content.replace('intent_hash: "PENDING"', f'intent_hash: "{intent_hash}"')
    task_file.write_text(updated_content, encoding="utf-8")
    
    return True, f"Created task: {task_id}\n  Path: {task_dir}/\n  Created: {created_at}\n  Hash: {intent_hash[:16]}...\n  State: candidate / inactive"


def create_canonical_blob(task_id: str, title: str, kind: str, scope: str, risk: str, origin: str, created_at: str, goal: str) -> str:
    """Create canonical blob for hashing."""
    return f"""---
confidence: low
created_at: {created_at}
epistemic_state: candidate
id: {task_id}
intent_hash: PENDING
intent_hash_algo: sha256-v1
intent_hash_scope: canonical-intent
kind: {kind}
lifecycle_state: inactive
origin: {origin}
risk: {risk}
scope: {scope}
title: {title}
---
## Goal

{goal}

## Acceptance

- [ ] Define acceptance criteria

## Constraints

- Define constraints

## Dependencies

- None"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Create a new task")
    parser.add_argument("--root", type=str, default="tasks/", help="Root directory for tasks")
    parser.add_argument("--id", type=str, required=True, help="Task ID")
    parser.add_argument("--title", type=str, required=True, help="Task title")
    parser.add_argument("--kind", type=str, required=True, choices=VALID_KINDS, help="Task kind")
    parser.add_argument("--scope", type=str, required=True, choices=VALID_SCOPES, help="Task scope")
    parser.add_argument("--risk", type=str, required=True, choices=VALID_RISKS, help="Task risk")
    parser.add_argument("--origin", type=str, required=True, choices=VALID_ORIGINS, help="Task origin")
    parser.add_argument("--goal", type=str, default="", help="Goal statement")
    parser.add_argument("--expires", type=str, default="", help="Expiry date (RFC3339)")
    parser.add_argument("--staleness", type=int, default=None, help="Staleness threshold in days")

    args = parser.parse_args()
    root = Path(args.root)
    
    root.mkdir(parents=True, exist_ok=True)
    
    success, msg = create_task(
        root=root,
        task_id=args.id,
        title=args.title,
        kind=args.kind,
        scope=args.scope,
        risk=args.risk,
        origin=args.origin,
        goal=args.goal,
        expires_at=args.expires,
        staleness_days=args.staleness
    )
    
    print(msg)
    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())
