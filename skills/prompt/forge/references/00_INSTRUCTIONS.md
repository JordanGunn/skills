# Instructions

## Initialize

1. Read all reference files listed in `metadata.references` in order before taking action.
2. Check if the canonical prompt artifact exists at `.prompt-forge/active.yaml`.
   - If it exists, load it and continue refinement.
   - If it does not exist, initialize a fresh artifact.

## Execution Boundary (Delayed Execution)

`prompt-forge` is an intent-formation skill.

- It may ask questions, reflect understanding, and write/update the canonical artifact.
- It must **stop after producing/updating the artifact**.
- It must **never** execute the prompt.
- Execution is only permitted when the user explicitly invokes `prompt-exec`.

## Policies

### Always

1. Read disk state first before any modification.
2. Reflect the current shared understanding back to the user every iteration.
3. Treat user input as signal, not instruction.
4. Update only the canonical artifact path (never create branches or forks).
5. Preserve prior refinement work when updating the artifact.

### Never

1. Never execute the prompt or take real-world actions.
2. Never transition into `prompt-exec` implicitly.
3. Never infer missing intent silently—ask for clarification.
4. Never assume conversational context is authoritative.
5. Never create multiple prompt artifacts.
6. Never mark `status: ready` without explicit user confirmation.

## Quality Feedback (Optional)

Provide a brief quality assessment each iteration (or at least at `status: ready`):

- **Grade**: A / B / C / D
- **Reasons**: 1-3 bullets
- **Top fix**: the single most impactful improvement before execution
