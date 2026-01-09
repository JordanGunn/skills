# Preconditions

Before writing any files for a new plan:

1. Verify the repository contains (or can create) `docs/planning/`.
2. Determine the next plan number `<N>` from the filesystem.

## Deterministic path (preferred)

If `scripts/dirs.sh` or `scripts/dirs.ps1` exists, run it to:

- ensure `docs/planning/` exists
- compute `N = max(existing) + 1` (or 1 if none)
- create `docs/planning/phase-N/`
- print the created directory path

### Manual fallback (only if scripts are unavailable)

1. Ensure `docs/planning/` exists (create if missing).
2. List existing `phase-<number>` dirs under `docs/planning/` (ignore non-matching).
3. Set `<N> = max(existing) + 1`, or `1` if none.

**Do not guess N.** Always compute it from the filesystem.
