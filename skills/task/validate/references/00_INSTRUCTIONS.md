# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Require explicit validation info: who is validating and why.
2. Recompute intent hash before validation.
3. Update `last_reviewed_at` timestamp.
4. Store validation metadata in frontmatter.

### Never

1. Never validate a task without explicit who/why.
2. Never validate if hash computation fails.
3. Never validate an already-invalidated task without explicit acknowledgment.
