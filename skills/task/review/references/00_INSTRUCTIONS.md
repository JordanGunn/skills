# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Update `last_reviewed_at` to current timestamp.
2. Recompute derived status via `task_status.py`.
3. Recompute hash and flag mismatches.
4. Report all findings clearly.

### Never

1. Never change `epistemic_state` during review (use `task-validate` or `task-invalidate`).
2. Never silently ignore hash mismatches.
