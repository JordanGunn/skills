# Intent

## Purpose

Display the current derived status of a task without modifying its state.

## Philosophy

Status is **observation**. It surfaces the deterministic truth about a task's current state:

- Is it stale?
- Does the hash match?
- Can it be activated?
- Why or why not?

This information is computed, not judged.

## Inputs

Required:

- `task`: Path to task directory

Optional:

- `--json`: Output as JSON
- `--no-write`: Do not update 99_STATE.md

## Outputs

Status summary including:

- Task ID and title
- Epistemic state
- Lifecycle state
- Staleness status and reason
- Hash mismatch status
- Needs revalidation flag
- Execution eligibility
- Activation eligibility
- Refusal reasons (if any)
