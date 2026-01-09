# Procedure

## Step 1: Load Artifact

1. Read `.codex/skills/prompt/.prompt/active.yaml`
2. Parse YAML content
3. Verify all preconditions (see `01_PRECONDITIONS.md`)

## Step 2: Quote Before Execute

Present the exact prompt to the user:

```markdown
## Executing Prompt

**Title**: <title from artifact>

**Prompt** (verbatim):

---
<refined_prompt from artifact, exactly as written>
---

Proceeding with execution...
```

This ensures transparency and allows last-moment abort.

## Step 3: Execute

1. Use `refined_prompt` verbatim as the instruction.
2. No optimization, cleanup, or reinterpretation.
3. Execute according to the prompt's requirements.
4. Track success/failure state.

## Step 4: Handle Outcome

### On Success

1. Generate execution receipt:

```yaml
executed_at: <ISO 8601 timestamp>
title: <copied from prompt artifact>
intent_summary: <copied from prompt artifact>
refined_prompt: |
  <verbatim copy>
result_summary: <brief description of what was accomplished>
```

2. Write receipt to `.codex/skills/prompt/.prompt/receipts/<timestamp>-<hash>.yaml`

3. **Delete the canonical prompt artifact** (`.codex/skills/prompt/.prompt/active.yaml`)

4. Confirm to user:
> "Execution complete. The prompt has been cleared. Receipt saved to `receipts/<filename>`."

### On Failure

1. Do NOT delete the canonical prompt artifact.
2. Optionally annotate the artifact with failure details.
3. Inform user:
> "Execution failed: <reason>. The prompt remains active. You can retry or return to `prompt-forge` to adjust."

## Step 5: Verify Clean State

After successful execution, confirm:

- [ ] `active.yaml` no longer exists
- [ ] Receipt was written (if receipts enabled)
- [ ] No active prompt remains in the system
