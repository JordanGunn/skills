# Edge Cases

## No artifact exists

**Scenario**: User invokes `prompt-exec` but no `active.yaml` exists.

**Response**: 
> "No active prompt found. Use `prompt-forge` to create one first."

Do NOT attempt to infer what the user wanted.

## Artifact exists but status is drafting

**Scenario**: User invokes `prompt-exec` but `status: drafting`.

**Response**:
> "The prompt is still in draft status (not yet confirmed as ready). Would you like to continue refinement with `prompt-forge`?"

Do NOT execute draft prompts under any circumstances.

## User tries to modify prompt during execution

**Scenario**: User says "execute but change X to Y".

**Response**:
> "Execution must use the prompt exactly as forged. To make changes, return to `prompt-forge` first, then execute the updated prompt."

Do NOT modify and execute in one step.

## Execution partially succeeds

**Scenario**: Some actions complete, others fail.

**Response**:
1. Report what succeeded and what failed.
2. Do NOT delete the artifact (execution was not fully successful).
3. Offer options:
   - Retry the failed portions
   - Return to `prompt-forge` to adjust scope
   - Manually intervene

## Receipts directory doesn't exist

**Scenario**: First execution, `receipts/` directory is missing.

**Response**: Create the directory before writing the receipt:
```
.codex/skills/prompt/.prompt/receipts/
```

## Receipt write fails

**Scenario**: Cannot write receipt (permissions, disk full, etc.).

**Response**:
1. Still delete the canonical artifact (execution succeeded).
2. Warn user that receipt could not be saved.
3. Include receipt content in the response for manual preservation.

## User immediately wants to execute again

**Scenario**: After successful execution, user says "do it again".

**Response**:
> "The previous prompt was cleared after execution. To run something new, start with `prompt-forge`."

Receipts are historical records, not re-executable prompts.

## Artifact is valid but constraints are impossible

**Scenario**: The `refined_prompt` asks for something that cannot be done (e.g., "delete the internet").

**Response**:
1. Quote the prompt (quote-before-execute).
2. Explain why it cannot be executed.
3. Do NOT delete the artifact.
4. Suggest returning to `prompt-forge` to adjust.

## Multiple users / concurrent access

**Scenario**: Another process modified `active.yaml` mid-execution.

**Response**: This skillset assumes single-user, single-agent operation. If detected:
1. Abort execution.
2. Reload artifact.
3. Ask user to verify the current state.
