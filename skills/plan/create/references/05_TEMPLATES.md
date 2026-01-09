# Templates

All templates include YAML frontmatter with `status` for machine-readable tracking.
See `.resources/references/FRONTMATTER.md` for the full taxonomy.

## Root Plan Template

```md
---
status: pending
---

# Phase <N> — <derived title>

## Purpose

<One or two sentences summarizing the user's objective>

## Context

<Extract key reasoning from the conversation so intent/rationale is preserved>

## Objectives

* [ ] Identify tasks necessary to resolve this plan
* [ ] Execute tasks in sequence
* [ ] Produce measurable outputs

## Constraints

<Include relevant technical/architectural rules mentioned in the discussion>

## Success Criteria

<Concrete closure conditions for this plan>

## Sub-plan Index

* a — <generated sub-plan name>
* b — <generated sub-plan name>
* c — ...
```

## Sub-plan Index Template (`index.md`)

```md
---
status: pending
---

# Phase <N><letter> — <Sub-plan Name>

## Brief

<One or two sentences describing this sub-plan>

## Tasks

* i — <task name> — <brief description>
* ii — <task name> — <brief description>
* iii — <task name> — <brief description>

(Add or remove task lines as needed.)
```

## Task Template (`i.md`, `ii.md`, `iii.md`, `iv.md`)

```md
---
status: pending
---

# Phase <N><letter><roman> — <Task Name>

## Focus

<What this task is doing and why — MUST be concrete, not a placeholder>

## Inputs

<Specific artifacts or context from prior tasks — MUST reference real files/decisions>

## Work

<Actionable steps to complete this task — MUST contain at least one concrete step>

## Output

<!-- Populated by plan-exec -->

## Handoff

<!-- Populated by plan-exec -->
```

## Section Ownership

| Section | Owner | Requirement |
|---------|-------|-------------|
| Focus | `plan-create` | Concrete goal, no placeholders |
| Inputs | `plan-create` | Specific references to artifacts/context |
| Work | `plan-create` | At least one actionable step |
| Output | `plan-exec` | Results of execution |
| Handoff | `plan-exec` | Instruction for next task |
