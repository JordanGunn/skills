#!/usr/bin/env python3
"""
task_status.py - Compute derived status flags for a task.

Computes staleness, expiry, hash mismatch, and execution eligibility.
Writes derived state to 99_STATE.md.

Usage:
    python task_status.py --task /path/to/task-dir
    python task_status.py --task /path/to/task-dir --json

Output:
    Derived status summary or JSON object
"""

import argparse
import json
import re
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path

DEFAULT_STALENESS_DAYS = 14


def get_utc_now() -> datetime:
    """Return current UTC datetime."""
    return datetime.now(timezone.utc)


def parse_rfc3339(timestamp: str) -> datetime:
    """Parse RFC3339 timestamp to datetime."""
    if not timestamp:
        return None
    timestamp = timestamp.replace("Z", "+00:00")
    try:
        return datetime.fromisoformat(timestamp)
    except ValueError:
        return None


def read_frontmatter(task_file: Path) -> dict:
    """Read frontmatter from task file."""
    content = task_file.read_text(encoding="utf-8")
    
    if not content.startswith("---"):
        raise ValueError("Missing frontmatter delimiter")
    
    parts = content.split("---", 2)
    if len(parts) < 3:
        raise ValueError("Missing closing frontmatter delimiter")
    
    try:
        import yaml
        return yaml.safe_load(parts[1].strip()) or {}
    except ImportError:
        return _parse_simple_yaml(parts[1].strip())


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
            elif value.isdigit():
                value = int(value)
            result[key.strip()] = value
    return result


def compute_hash(task_dir: Path) -> str:
    """Compute current intent hash."""
    import importlib.util
    import hashlib
    
    script_dir = Path(__file__).parent
    extract_script = script_dir / "task_intent_extract.py"
    
    if extract_script.exists():
        spec = importlib.util.spec_from_file_location("task_intent_extract", extract_script)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        canonical_blob = module.extract_canonical_intent(task_dir)
        return hashlib.sha256(canonical_blob.encode("utf-8")).hexdigest()
    
    return None


def compute_derived_status(task_dir: Path, frontmatter: dict) -> dict:
    """Compute all derived status flags."""
    now = get_utc_now()
    
    created_at = parse_rfc3339(frontmatter.get("created_at", ""))
    last_reviewed_at = parse_rfc3339(frontmatter.get("last_reviewed_at", ""))
    expires_at = parse_rfc3339(frontmatter.get("expires_at", ""))
    staleness_threshold = frontmatter.get("staleness_days_threshold", DEFAULT_STALENESS_DAYS)
    
    epistemic_state = frontmatter.get("epistemic_state", "candidate")
    lifecycle_state = frontmatter.get("lifecycle_state", "inactive")
    stored_hash = frontmatter.get("intent_hash", "")
    
    reference_time = last_reviewed_at or created_at
    
    is_stale = False
    stale_reason = None
    days_since_review = None
    
    if reference_time:
        days_since_review = (now - reference_time).days
        if days_since_review > staleness_threshold:
            is_stale = True
            stale_reason = f"Last reviewed {days_since_review} days ago (threshold: {staleness_threshold})"
    
    is_expired = False
    if expires_at and expires_at < now:
        is_expired = True
        is_stale = True
        stale_reason = f"Expired at {expires_at.strftime('%Y-%m-%dT%H:%M:%SZ')}"
    
    hash_mismatch = False
    computed_hash = None
    try:
        computed_hash = compute_hash(task_dir)
        if stored_hash and computed_hash and stored_hash != computed_hash:
            if not stored_hash.startswith("{{"):
                hash_mismatch = True
    except Exception:
        pass
    
    needs_revalidation = (
        is_stale or 
        hash_mismatch or 
        epistemic_state == "invalidated"
    )
    
    execution_eligible = (
        epistemic_state == "validated" and
        lifecycle_state in ["active"] and
        not is_stale and
        not hash_mismatch
    )
    
    activation_eligible = (
        epistemic_state == "validated" and
        lifecycle_state == "inactive" and
        not is_stale and
        not hash_mismatch
    )
    
    refusal_reasons = []
    if epistemic_state == "invalidated":
        refusal_reasons.append("Task is invalidated")
    if epistemic_state != "validated":
        refusal_reasons.append(f"Task not validated (state: {epistemic_state})")
    if is_stale:
        refusal_reasons.append(stale_reason or "Task is stale")
    if hash_mismatch:
        refusal_reasons.append("Intent hash mismatch - content changed since validation")
    
    return {
        "computed_at": now.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "task_id": frontmatter.get("id", "unknown"),
        "epistemic_state": epistemic_state,
        "lifecycle_state": lifecycle_state,
        "is_stale": is_stale,
        "is_expired": is_expired,
        "stale_reason": stale_reason,
        "days_since_review": days_since_review,
        "staleness_threshold": staleness_threshold,
        "hash_mismatch": hash_mismatch,
        "stored_hash": stored_hash[:16] + "..." if stored_hash and len(stored_hash) > 16 else stored_hash,
        "computed_hash": computed_hash[:16] + "..." if computed_hash and len(computed_hash) > 16 else computed_hash,
        "needs_revalidation": needs_revalidation,
        "execution_eligible": execution_eligible,
        "activation_eligible": activation_eligible,
        "refusal_reasons": refusal_reasons if refusal_reasons else None
    }


def write_state_file(task_dir: Path, status: dict) -> None:
    """Write derived state to 99_STATE.md."""
    state_file = task_dir / "99_STATE.md"
    
    refusal_block = ""
    if status.get("refusal_reasons"):
        reasons = "\n".join(f"  - {r}" for r in status["refusal_reasons"])
        refusal_block = f"\nrefusal_reasons:\n{reasons}"
    
    state_content = f"""---
derived_status:
  computed_at: "{status['computed_at']}"
  task_id: "{status['task_id']}"
  epistemic_state: {status['epistemic_state']}
  lifecycle_state: {status['lifecycle_state']}
  is_stale: {str(status['is_stale']).lower()}
  is_expired: {str(status['is_expired']).lower()}
  stale_reason: {f'"{status["stale_reason"]}"' if status['stale_reason'] else 'null'}
  days_since_review: {status['days_since_review'] if status['days_since_review'] is not None else 'null'}
  staleness_threshold: {status['staleness_threshold']}
  hash_mismatch: {str(status['hash_mismatch']).lower()}
  needs_revalidation: {str(status['needs_revalidation']).lower()}
  execution_eligible: {str(status['execution_eligible']).lower()}
  activation_eligible: {str(status['activation_eligible']).lower()}{refusal_block}
---

# Derived State

> Auto-generated by `task_status.py`. Do not edit manually.

## Status Summary

| Field | Value |
|-------|-------|
| Task ID | `{status['task_id']}` |
| Epistemic State | `{status['epistemic_state']}` |
| Lifecycle State | `{status['lifecycle_state']}` |
| Stale | {status['is_stale']} |
| Hash Mismatch | {status['hash_mismatch']} |
| Needs Revalidation | {status['needs_revalidation']} |
| Execution Eligible | {status['execution_eligible']} |
| Activation Eligible | {status['activation_eligible']} |

## Chronology

- **Days Since Review**: {status['days_since_review'] if status['days_since_review'] is not None else 'N/A'}
- **Staleness Threshold**: {status['staleness_threshold']} days
- **Stale Reason**: {status['stale_reason'] or 'None'}

## Integrity

- **Stored Hash**: `{status['stored_hash'] or 'None'}`
- **Computed Hash**: `{status['computed_hash'] or 'None'}`
- **Mismatch**: {status['hash_mismatch']}
"""
    
    if status.get("refusal_reasons"):
        state_content += "\n## Refusal Reasons\n\n"
        for reason in status["refusal_reasons"]:
            state_content += f"- {reason}\n"
    
    state_file.write_text(state_content, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compute derived status flags for a task"
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
        help="Output as JSON"
    )
    parser.add_argument(
        "--no-write",
        action="store_true",
        help="Do not write 99_STATE.md"
    )

    args = parser.parse_args()
    task_dir = Path(args.task)

    if not task_dir.exists() or not task_dir.is_dir():
        print(f"Error: Invalid task directory: {task_dir}", file=sys.stderr)
        return 1

    task_file = task_dir / "00_TASK.md"
    if not task_file.exists():
        print(f"Error: 00_TASK.md not found in {task_dir}", file=sys.stderr)
        return 1

    try:
        frontmatter = read_frontmatter(task_file)
        status = compute_derived_status(task_dir, frontmatter)
        
        if not args.no_write:
            write_state_file(task_dir, status)
        
        if args.json:
            print(json.dumps(status, indent=2))
        else:
            print(f"Task: {status['task_id']}")
            print(f"  Epistemic: {status['epistemic_state']}")
            print(f"  Lifecycle: {status['lifecycle_state']}")
            print(f"  Stale: {status['is_stale']}")
            print(f"  Hash Mismatch: {status['hash_mismatch']}")
            print(f"  Needs Revalidation: {status['needs_revalidation']}")
            print(f"  Execution Eligible: {status['execution_eligible']}")
            if status.get("refusal_reasons"):
                print("  Refusal Reasons:")
                for reason in status["refusal_reasons"]:
                    print(f"    - {reason}")
        
        return 0

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
