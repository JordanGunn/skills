# Procedure

## Section ownership (critical)

`plan-exec` does NOT populate Focus, Inputs, or Work — those are `plan-create` artifacts.

`plan-exec` ONLY populates:

- **Output**: Results of executing the Work steps
- **Handoff**: Instruction for the next task

If Focus, Inputs, or Work are incomplete or contain placeholders, the plan is
malformed. Do not proceed — notify the user that `plan-create` did not complete properly.

## Legacy plans

Plans created before the frontmatter convention may lack `status` fields or have
Output/Handoff sections containing placeholder descriptions rather than actual results.

For legacy plans:

- Treat missing `status` as `pending`
- Treat Output/Handoff containing descriptions (not concrete results) as incomplete
- Add frontmatter and update status as you execute

## Step 1 - Determine active task

A task file is considered complete if:

- Frontmatter `status: complete`
- Non-empty **Output** section
- Non-empty **Handoff** section

1. Starting from sub-plan `a`, read `<letter>/index.md` to identify the ordered
   task list (roman numerals).
2. Scan tasks in order for the first task with `status: pending` or `status: in_progress`.
3. If all tasks under the current sub-plan are complete, move to the next letter.
4. The first non-complete task file is the active task.
5. If all sub-plans are complete, proceed to Plan wrap-up (Step 5).

If `index.md` does not specify tasks, default to scanning roman numeral task
files present in the sub-plan folder in ascending order.

## Step 2 - Load and validate

Read:

- Root: `docs/planning/phase-<N>/plan.md`
- Sub-plan: `docs/planning/phase-<N>/<letter>/index.md`
- Active: `docs/planning/phase-<N>/<letter>/<roman>.md`
- Any referenced artifacts mentioned in Inputs (only as needed)

### Validation

Before executing, verify the active task has:

- Non-placeholder Focus (concrete goal)
- Non-placeholder Inputs (specific references)
- Non-placeholder Work (actionable steps)

If any are missing or contain `<...>` placeholders, halt and notify the user.

## Step 3 - Execute the active task

### Status update (start)

Update the active task's frontmatter: `status: in_progress`

If this is the first task in the sub-plan, also update the sub-plan's `index.md`
frontmatter to `status: in_progress`.

If this is the first task in the entire plan, also update the root `plan.md`
frontmatter to `status: in_progress`.

### Execution

- Follow the steps in **Work** exactly as written.
- Perform the steps.
- Record the results under **Output**.
- Write a clear **Handoff** for the next task.

Do not perform steps that belong to later sub-plans.

### Status update (complete)

Update the active task's frontmatter: `status: complete`

If this was the last task in the sub-plan, also update the sub-plan's `index.md`
frontmatter to `status: complete`.

## Step 4 - Advance to the next task

After completing `<roman>`:

- Move to the next task within the same sub-plan.
- If the current task is the last in the sub-plan, move to the next letter in
  the root Sub-plan Index.
- Repeat Steps 2-4.

If the next sub-plan folder does not exist but the index includes it:

- Create it and scaffold `index.md` and task files using the same template
  structure already present in the plan and listed in the new `index.md`.

## Step 5 - Plan wrap-up

When all sub-plans in the root Sub-plan Index are complete:

1. Update `docs/planning/phase-<N>/plan.md`:
   - Update frontmatter: `status: complete`
   - Check off the root Success Criteria that were met.
   - If any success criteria were not met, add a short note explaining what remains.
2. Append a short **Plan Summary** section at the end of the root plan:
   - What was done
   - Key decisions
   - Links/paths to produced artifacts
   - Any follow-up plan suggestion if needed
