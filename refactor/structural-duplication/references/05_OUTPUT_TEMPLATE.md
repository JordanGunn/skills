# Structural Duplication Audit Report

## Summary

- Duplication groups found:
- Highest-risk drift points:
- Recommended kernel extraction targets:

## Candidate inventory

For each candidate:

- Location:
- Purpose (1 sentence):
- Pipeline skeleton (stages in order):
- Distribution model (chunks/partitions/reduction style):
- Notes:

## Structural duplication map

### Group A: `<short name>`

- Members:
- Shared spine stages:
- Divergent stages (operator differences):
- Drift risk notes:

(Repeat per group)

## Proposed unification (preserving semantic boundaries)

For each group:

- Domain boundaries to preserve:
- Kernel candidate module:
- Minimal abstraction seam:
- Strategy/hook responsibilities:
- Expected call shape (pseudocode-level, not full code):

## Subtle abstraction assessment

- Is subtle abstraction required? (Yes/No)
- Why:
- If yes: include a staged refactor plan below.

## Staged plan (if required)

(Insert plan using `references/04_REFACTOR_PLAN_TEMPLATE.md`)

## Risks and non-goals

- What we are NOT changing:
- Potential pitfalls:
- Follow-ups (optional):
