# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.
2. Check if the canonical prompt artifact exists at `.codex/skills/prompt/.prompt/active.yaml`.

## Policies

### Always

1. Read disk state first—the canonical artifact is the only source of truth.
2. Verify `status: ready` before proceeding.
3. Quote the exact prompt before executing (quote-before-execute).
4. Delete the canonical artifact after successful execution.
5. Write an execution receipt for auditability.

### Never

1. Never execute without an artifact on disk.
2. Never execute without explicit user consent.
3. Never modify the prompt during execution.
4. Never leave a live prompt behind after successful execution.
5. Never reinterpret, optimize, or clean up the prompt text.
