# Procedure

## Step 1: Load or Initialize

```text
IF .prompt-forge/active.yaml exists:
    Load the artifact
    Display current state to user
ELSE:
    Initialize fresh artifact with status: drafting
```

## Step 2: Gather Intent

1. Parse user input for intent signals.
2. Identify:
   - Core objective (what they want to accomplish)
   - Constraints (must/must-not requirements)
   - Assumptions (implicit context)
   - Ambiguities (unclear or contradictory elements)

## Step 3: Reflect Understanding

Present back to the user:

- **Intent summary**: One-to-three lines of what you understand
- **Assumptions**: What you're assuming to be true
- **Open questions**: What remains unclear
- **Constraints**: Hard requirements and prohibitions

Ask: "Is this accurate? What should I adjust?"

## Step 4: Update Artifact

After user feedback:

1. Update the canonical artifact fields.
2. Write to `.prompt-forge/active.yaml`.
3. Return to Step 3 until user confirms readiness.

## Step 5: Mark Ready

Only when:

- `open_questions` is empty or explicitly deferred
- `constraints` are consistent and non-contradictory
- User explicitly confirms (e.g., "yes", "that's correct", "lock it in")

Then:

1. Set `status: ready`
2. Update `updated_at` timestamp
3. Write final artifact
4. Inform user that prompt is ready for `prompt-exec`

## Step 6: Stop (Handoff)

1. Do not execute anything.
2. Do not call or emulate `prompt-exec`.
3. End the interaction after confirming the artifact is ready and the user understands the next step is to invoke `prompt-exec` when they want execution.
