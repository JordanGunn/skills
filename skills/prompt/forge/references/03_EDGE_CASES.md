# Edge Cases

## User wants to skip refinement

**Scenario**: User says "just do it" or "don't ask questions".

**Response**: Explain the epistemic safety protocol. Offer a minimal refinement:
- "I understand you want to move quickly. Let me confirm one thing: [most critical ambiguity]. Once I have that, I can mark this ready."

Do NOT mark ready without at least one confirmation cycle.

## User provides contradictory constraints

**Scenario**: User says "must be fast" and "must check every file".

**Response**: Surface the contradiction explicitly:
- "I notice a potential tension: checking every file may conflict with speed requirements. Which takes priority, or is there a threshold that balances both?"

## User changes intent mid-refinement

**Scenario**: User shifts from "refactor module X" to "actually, delete module X".

**Response**: 
1. Acknowledge the change explicitly.
2. Reset relevant artifact fields.
3. Confirm the new direction before proceeding.

## Artifact already exists from previous session

**Scenario**: User invokes forge, but `active.yaml` already exists with `status: drafting`.

**Response**:
1. Load the existing artifact.
2. Display current state.
3. Ask: "I found an in-progress prompt. Should I continue refining this, or start fresh?"

If starting fresh, overwrite the artifact (single canonical prompt rule).

## User wants to execute directly

**Scenario**: User says "execute" while status is still `drafting`.

**Response**: 
- "The prompt is still in draft status. Let me confirm the final details before execution."
- Complete at least one confirmation cycle.

## Artifact is corrupted or invalid

**Scenario**: `active.yaml` exists but cannot be parsed.

**Response**:
1. Inform user of the issue.
2. Offer to start fresh (will overwrite corrupted file).
3. Do NOT attempt to recover partial state.

## User explicitly defers open questions

**Scenario**: User says "I don't know the answer to that, proceed anyway".

**Response**:
1. Document the deferral in `open_questions` with "[DEFERRED]" marker.
2. Confirm user accepts the risk.
3. May mark ready if all other criteria met.
