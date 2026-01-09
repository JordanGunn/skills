# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Compute derived status before activation check.
2. Verify all trust gates pass before activation.
3. Write clear refusal reasons if activation is blocked.
4. Update `99_STATE.md` after activation.

### Never

1. Never activate an invalidated task.
2. Never activate a stale task without explicit revalidation.
3. Never activate if hash mismatch exists without revalidation.
4. Never silently skip trust gate checks.
