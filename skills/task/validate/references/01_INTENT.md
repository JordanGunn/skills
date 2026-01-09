# Intent

## Purpose

Explicitly validate a task, marking it as trusted for potential execution.

## Philosophy

Validation is a **deliberate act of trust**. It transforms a `candidate` or `draft` task into a `validated` task that may influence execution.

Key principles:

- **Explicit Accountability**: Validation requires who and why.
- **Hash Lock**: The intent hash at validation time becomes the trusted baseline.
- **Temporal Anchor**: `last_reviewed_at` marks when the task was deemed valid.

## Inputs

Required:

- `task`: Path to task directory
- `validated_by`: Who is performing validation (human name or agent identifier)
- `validated_reason`: Why this task is being validated

Optional:

- `--force`: Validate even if task is currently invalidated (requires acknowledgment)

## Outputs

Updated `00_TASK.md` frontmatter with:

- `epistemic_state: validated`
- `validated_by: {who}`
- `validated_reason: {why}`
- `last_reviewed_at: {timestamp}`
- `intent_hash: {recomputed_hash}`
