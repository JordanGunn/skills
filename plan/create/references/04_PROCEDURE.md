# Procedure

Execute these steps literally, in order.

## Dry-run / no-files mode

If the user explicitly requests a dry-run or no files to be written:

- Do not run scripts.
- Do not create or edit any files.
- Provide an in-chat walk-through and overall impression only.
- Stop after responding in-chat.

## Step 1 - Create the plan directory (prefer scripts)

Preferred: use a script if available.

### macOS / Linux / WSL (bash)

If `scripts/dirs.sh` exists:

- Run: `bash scripts/dirs.sh`
- Capture the printed output path as `PLAN_DIR`
- Derive `<N>` from that path (e.g., `docs/planning/phase-30/` -> N=30)

### Windows (PowerShell)

If `scripts/dirs.ps1` exists:

- Run: `powershell -ExecutionPolicy Bypass -File scripts/dirs.ps1`
- Capture the printed output path as `PLAN_DIR`
- Derive `<N>` from that path

### Fallback (scripts missing)

Create:

- `docs/planning/phase-<N>/`

(Use `<N>` computed per Preconditions.)

## Step 2 - Write the root plan

Create and write:

- `docs/planning/phase-<N>/plan.md`

Use the template from `05_TEMPLATES.md` and **fully populate** from the current conversation.

### Content requirements

- All angle-bracket placeholders (`<...>`) MUST be replaced with concrete content.
- Purpose, Context, Constraints, and Success Criteria MUST contain real text derived from the conversation.
- The root plan frontmatter MUST include `status: pending`.

### Rules for Sub-plan Index

- Sub-plans MUST be derived from the discussion (no "filler tasks").
- Each sub-plan should be independently completable and produce a tangible output.

## Step 3 - Create sub-plan directories and scaffolds

For each listed letter in the Sub-plan Index:

Create:

- `docs/planning/phase-<N>/<letter>/`
- `docs/planning/phase-<N>/<letter>/index.md`
- Task files `docs/planning/phase-<N>/<letter>/i.md`, `ii.md`, `iii.md`, ...
  as needed

Populate each `index.md` using the Sub-plan Index Template from `05_TEMPLATES.md`.

Populate each task file using the Task Template from `05_TEMPLATES.md`.

### Task content requirements (critical)

For each task file, `plan-create` MUST fully populate:

- **Focus**: Concrete description of what the task accomplishes (not a placeholder)
- **Inputs**: Specific artifacts, files, or context required (not generic text)
- **Work**: At least one actionable step that can be executed

Leave empty (for `plan-exec` to populate):

- **Output**: Will contain execution results
- **Handoff**: Will contain instruction for next task

All angle-bracket placeholders (`<...>`) MUST be replaced with real content.

### Task scoping

- Derive the tasks required for each sub-plan from the conversation and list them
  in `index.md` with brief descriptions.
- Use roman numeral ordering only (`i`, `ii`, `iii`, `iv`, `v`, ...).
- Only create task files that are listed in the sub-plan's `index.md`.

### Dependency rule

The output of the last completed task in `<N>/a/` becomes an input to
`<N>/b/index.md`, etc., in alphabetical order.

## Output checklist

Confirm on disk before finishing:

- `docs/planning/phase-<N>/plan.md` exists with `status: pending` frontmatter
- Each listed sub-plan directory exists
- Each sub-plan has `index.md` with `status: pending` frontmatter
- Each task file has `status: pending` frontmatter
- Root plan has Sub-plan Index matching created sub-plan folders

## Readiness check (required)

Before declaring completion, verify:

- [ ] No angle-bracket placeholders remain in any file
- [ ] Every task's Focus section contains a concrete goal
- [ ] Every task's Work section contains at least one actionable step
- [ ] Output and Handoff sections are empty (reserved for `plan-exec`)
