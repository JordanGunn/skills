# Templates

## Root Plan Template

```md
# Phase <N> — <derived title>

## Purpose
(One or two sentences summarizing the user's objective)

## Context
(Extract key reasoning from the conversation so intent/rationale is preserved)

## Objectives
* [ ] Identify subtasks necessary to resolve this phase
* [ ] Execute subtasks in sequence
* [ ] Produce measurable outputs

## Constraints
(Include relevant technical/architectural rules mentioned in the discussion)

## Success Criteria
(Concrete closure conditions for this phase)

## Subphase Index
* a — <generated subtask name>
* b — <generated subtask name>
* c — ...
```

## Subphase Plan Template

```md
# Phase <N><letter> — <Subtask Name>

## Focus
(What this subphase is doing and why)

## Inputs
(Artifacts or reasoning from prior subphases or root context)

## Work
(Steps/decisions needed; include any checks or validations)

## Output
(Clear conclusion or artifact reference)

## Handoff
(Explicit instruction for the next subphase)
```

If a subphase is split into roman numerals, apply the same template to each
`i.md`, `ii.md`, `iii.md`, and `iv.md` file in that subphase folder.
