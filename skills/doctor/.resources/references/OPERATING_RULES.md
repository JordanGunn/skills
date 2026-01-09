# Operating Rules

Non-negotiable constraints for Doctor Protocol skills.

## Rule 1: No Side Effects

Skills produce **artifacts**, not changes.

- No file modifications
- No command executions (except read-only evidence gathering)
- No API calls that mutate state
- No fixes, refactors, or implementations

**Violation:** Proposing a fix and implementing it in the same turn.

## Rule 2: Explicit Uncertainty

All claims must include uncertainty bounds.

- State confidence levels (percentage or qualitative)
- List what would falsify the hypothesis
- Acknowledge alternative explanations

**Violation:** "The bug is in X" without confidence or alternatives.

## Rule 3: Scope Boundaries

Each skill has a defined scope. Do not exceed it.

| Skill | Scope | Out of Scope |
|-------|-------|--------------|
| `intake` | Capture and normalize symptoms | Propose causes |
| `triage` | Surface hypotheses across layers | Deep investigation |
| `exam` | Gather evidence for ONE suspect | Broaden scope |
| `treatment` | Propose options | Execute changes |

**Violation:** `doctor-triage` reading entire files to prove a hypothesis.

## Rule 4: Artifact Completeness

Every skill invocation must produce a complete artifact.

- Use the provided templates
- Fill all required sections
- Mark optional sections as "N/A" if not applicable

**Violation:** Producing a partial intake note that requires re-running intake.

## Rule 5: Evidence Traceability

All claims must cite evidence.

- File paths with line numbers when possible
- Grep patterns that can be re-run
- Log snippets with timestamps
- Command outputs (verbatim)

**Violation:** "The config is wrong" without citing which config file or line.

## Rule 6: Handoff Readiness

Artifacts must be consumable by:

- Another agent (with no prior context)
- A human reviewer (with system knowledge)
- A planning skill (for action sequencing)

**Violation:** Artifacts that assume the reader has seen the conversation.

## Rule 7: No Implicit Chains

Skills do not assume other skills have run.

- `doctor-triage` does not require `doctor-intake`
- `doctor-exam` does not require `doctor-triage`
- `doctor-treatment` does not require `doctor-exam`

Each skill should gather minimal context it needs from available sources.

**Violation:** `doctor-exam` failing because no triage report exists.

## Rule 8: Scope Escalation Protocol

If investigation reveals the problem is larger than expected:

1. Document the finding in the current artifact
2. Recommend escalation to a different skill or human
3. Do NOT expand scope within the current skill

**Violation:** `doctor-exam` discovering 3 new suspects and investigating all of them.

---

## The Final Rule

> If the problem feels confusing, contradictory, or nonsensical —
> **assume the mental model is wrong, not the system.**

Your job is to restore epistemic clarity before action.
