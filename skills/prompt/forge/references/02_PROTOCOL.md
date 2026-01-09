# Protocol

## Epistemic Safety Protocol

The forge skill exists to protect humans from premature or misaligned execution.

### Principle: Intent is Discovered

Human intent is rarely fully formed at the start of a conversation. The agent's role is to:

1. **Surface** what the user might mean
2. **Clarify** ambiguities through dialogue
3. **Stabilize** intent into an unambiguous artifact
4. **Confirm** before allowing execution

### Principle: Skeptical Refinement

Treat every user statement with constructive skepticism:

- "Do you mean X or Y?"
- "This seems to contradict your earlier constraint..."
- "I'm assuming Z—is that correct?"
- "What happens if W occurs?"

### Signals to Detect

| Signal               | Response                                  |
| -------------------- | ----------------------------------------- |
| Ambiguity            | Ask clarifying question                   |
| Contradiction        | Surface the conflict explicitly           |
| Misuse of terms      | Offer precise alternatives                |
| Shifting constraints | Acknowledge change, update artifact       |
| Vague scope          | Propose boundaries, ask for confirmation  |
| Missing edge cases   | Raise them proactively                    |

### Reflection Format

Each iteration should present:

```markdown
## Current Understanding

**Intent**: <one-to-three line summary>

**Assumptions**:
- <assumption 1>
- <assumption 2>

**Open Questions**:
- <question 1>
- <question 2>

**Constraints**:
- Must: <requirement>
- Must not: <prohibition>

---

Is this accurate? What should I adjust?
```

## State Transitions

```text
[No artifact] --forge--> [drafting] --refine--> [drafting] --confirm--> [ready]
```

The only valid transition to `ready` is through explicit user confirmation.

## Skill Boundary

`prompt-forge` is responsible for moving the canonical artifact toward `status: ready`.

- `prompt-forge` ends after writing the artifact.
- `prompt-exec` is the only skill allowed to execute the forged prompt.
- No implicit execution. No combined forge+exec in a single invocation.

## Quality Rubric (Optional)

Grade the forged prompt before marking `ready`:

- **A**: unambiguous, testable, constraints explicit, failure modes covered, safe to execute verbatim
- **B**: mostly clear; minor ambiguity or missing edge case that is low-risk
- **C**: material ambiguity remains; execution likely to diverge from intent
- **D**: contradictory or underspecified; requires more refinement before execution
