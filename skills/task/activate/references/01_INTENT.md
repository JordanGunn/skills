# Intent

## Purpose

Transition a task from `inactive` to `active` lifecycle state, enabling it to influence execution.

## Philosophy

Activation is the **trust gate**. A task may only become active if it passes all deterministic eligibility checks:

1. **Epistemic Gate**: Must be `validated` (not `candidate`, `draft`, or `invalidated`)
2. **Temporal Gate**: Must not be stale or expired
3. **Integrity Gate**: Intent hash must match (no unvalidated content changes)

These gates are **deterministic** - computed by scripts, not judged by agents.

## Trust Gates

| Gate | Check | Script |
|------|-------|--------|
| Epistemic | `epistemic_state == validated` | frontmatter read |
| Temporal | `is_stale == false` | `task_status.py` |
| Integrity | `hash_mismatch == false` | `task_hash.py --check` |

## Inputs

Required:

- `task`: Path to task directory

## Outputs

On success:

- `lifecycle_state: active` in frontmatter
- Updated `99_STATE.md`

On failure:

- Clear refusal message with specific reasons
- No state changes
