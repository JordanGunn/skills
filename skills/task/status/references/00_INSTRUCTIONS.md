# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Use `task_status.py` for deterministic status computation.
2. Display all derived flags clearly.
3. Show refusal reasons if task cannot be activated.

### Never

1. Never modify task state when checking status.
2. Never skip hash verification.
