# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.
2. Determine the target plan `<N>`:
   - If the user specifies `<N>`, use it.
   - Otherwise, use the highest numbered `docs/planning/phase-*/` directory (prefer a script if present).

## Policies

### Always

1. Treat a task file as complete only if it contains non-empty **Output** and **Handoff**.
2. Execute in order:
   - sub-plans: a -> b -> c -> ...
   - tasks within a sub-plan: roman order listed in `index.md`
3. Each completed task file must end with:
   - **Output** (concrete results)
   - **Handoff** (explicit next step)
4. During task execution, only modify `docs/planning/phase-<N>/<active-letter>/<active-roman>.md`.
   Exceptions: scaffolding missing sub-plans/tasks per Procedure, updating the root
   Sub-plan Index when scope expands, and root plan updates during wrap-up.

### Never

1. Never rewrite previously completed task files.
2. Never work ahead on later sub-plans.
3. Never modify an existing `<letter>/index.md` while executing tasks.
4. Never finish the plan without performing the root wrap-up (success criteria check + Plan Summary).
