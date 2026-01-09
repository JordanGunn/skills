# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Use the `create.py` script for deterministic task creation.
2. Generate `created_at` timestamp using the shared `time.py` script.
3. Compute initial intent hash after template population.
4. Directory name must match the task `id` field.

### Never

1. Never create a task directory without a valid `id`.
2. Never skip hash computation on creation.
3. Never set initial `epistemic_state` to anything other than `candidate`.
4. Never set initial `lifecycle_state` to anything other than `inactive`.
