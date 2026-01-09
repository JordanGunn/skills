# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Require an invalidation reason.
2. Record who invalidated and why.
3. Update derived state after invalidation.
4. If task was active, set lifecycle_state to inactive.

### Never

1. Never invalidate without a reason.
2. Never leave an active task in invalidated epistemic state.
