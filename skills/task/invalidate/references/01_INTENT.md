# Intent

## Purpose

Mark a task as no longer valid, removing its ability to influence execution.

## Philosophy

Tasks are **designed to die**. Invalidation is not failure - it is the correct response when:

- Requirements changed
- Assumptions proved false
- A better approach emerged
- The task became irrelevant

Invalidation preserves history while preventing stale intent from influencing future decisions.

## Inputs

Required:

- `task`: Path to task directory
- `invalidated_by`: Who is invalidating (human name or agent identifier)
- `invalidated_reason`: Why this task is being invalidated

Optional:

- `superseded_by`: Task ID that replaces this one

## Outputs

Updated `00_TASK.md` frontmatter with:

- `epistemic_state: invalidated`
- `invalidated_by: {who}`
- `invalidated_reason: {why}`
- `superseded_by: {task_id}` (if provided)
- `lifecycle_state: inactive` (if was active)
