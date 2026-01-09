# Intent

This skill "materializes" the current discussion into a **new planning phase** on disk:

- Creates `docs/planning/phase-<N>/`
- Writes `docs/planning/phase-<N>/plan.md` summarizing the current discussion
  (purpose, context, objectives, constraints, success criteria)
- Derives *only* the necessary sub-plans and tasks from the conversation and scaffolds:
  - `docs/planning/phase-<N>/<letter>/index.md` for each sub-plan (a, b, c, ...)
  - `docs/planning/phase-<N>/<letter>/<roman>.md` task files per sub-plan
- Ensures **all outputs are written to the filesystem** (not just in-chat)

Use this whenever the conversation reaches a new direction, architecture decision, or a "we should plan this" moment.
