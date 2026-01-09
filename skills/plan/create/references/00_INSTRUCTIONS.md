# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.

## Policies

### Always

1. Prefer scripts for deterministic filesystem steps when not in dry-run mode.
  a. If running on Windows, run `scripts/dirs.ps1`.
  b. Otherwise, run `scripts/dirs.sh`.

### Never

1. Never guess the next phase number `<N>`; it must be produced by the script or computed from the filesystem per Preconditions.
2. Never create root plan files other than `plan.md`.
