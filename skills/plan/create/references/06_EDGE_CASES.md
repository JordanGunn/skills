# Edge Cases

## Missing planning directory

Handled by scripts. If scripts are missing, create `docs/planning/` then proceed.

## Non-standard folders

Handled by scripts. Ignore anything not matching `phase-<number>`.

## Gaps in numbering

Handled by scripts. If phase-1 and phase-3 exist, still pick `max + 1` (phase-4).

## Ambiguous subtasks

Derive the smallest reasonable set from the conversation. Prefer fewer, clearer
sub-plans over many vague ones.

## User wants no files

If the user asks for planning but explicitly wants no files written, follow the
Dry-run / no-files mode in the Procedure and avoid all filesystem changes.

## Examples

### Existing phases

If `docs/planning/phase-29/` exists, create:

- `docs/planning/phase-30/`
- `docs/planning/phase-30/plan.md`
- `docs/planning/phase-30/a/index.md`, `b/index.md`, ...
- `docs/planning/phase-30/a/i.md`, `a/ii.md`, ...

### No phases yet

If `docs/planning/` exists but contains no `phase-*` directories, create:

- `docs/planning/phase-1/` and scaffolds
