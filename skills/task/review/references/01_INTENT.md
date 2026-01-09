# Intent

## Purpose

Perform a lightweight review of a task without changing its epistemic state. Updates temporal markers and recomputes derived status.

## Philosophy

Review is **observation without judgment**. It refreshes the temporal anchor (`last_reviewed_at`) and surfaces any drift signals (staleness, hash mismatch) without making trust decisions.

Use cases:

- Periodic task audits
- Pre-activation checks
- Staleness prevention
- Drift detection

## Inputs

Required:

- `task`: Path to task directory

## Outputs

- Updated `last_reviewed_at` in frontmatter
- Updated `99_STATE.md` with derived status
- Report of findings (stale, hash mismatch, etc.)
