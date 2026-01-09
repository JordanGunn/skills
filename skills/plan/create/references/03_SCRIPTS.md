# Scripts

This skill prefers deterministic scripts for filesystem operations.

## `dirs.sh`

Purpose:

- Ensure `docs/planning/` exists
- Compute next phase number as `max(existing phase-N) + 1` (or 1 if none)
- Create `docs/planning/phase-N/`
- Print the created directory path

Run (macOS/Linux/WSL):

- `bash scripts/dirs.sh`

## `dirs.ps1`

Same behavior for Windows PowerShell.

Run (Windows):

- `powershell -ExecutionPolicy Bypass -File scripts/dirs.ps1`

## Policy

- If scripts exist, use them.
- If scripts do not exist, follow manual preconditions/procedure.
- Scripts must be treated as the source of truth for `<N>` selection.
