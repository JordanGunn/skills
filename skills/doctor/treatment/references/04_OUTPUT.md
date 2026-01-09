# Output

Output format and handoff for `doctor-treatment`.

## Output Artifact

The treatment skill produces a single artifact: **Treatment Note**.

Use the template at `../.resources/assets/TREATMENT_NOTE.md`.

## Required Sections

Every treatment note must include:

1. **Diagnosis** — Primary diagnosis with confidence
2. **Diagnostic Basis** — Evidence supporting diagnosis
3. **Alternative Diagnoses** — What else remains plausible
4. **Treatment Options** — At least 2 options with full assessment
5. **Recommended Treatment** — Which option and why
6. **Risk Assessment** — Risks and mitigations
7. **Open Questions** — Unanswered questions
8. **Handoff** — Next recommended action
9. **Signatures** — Confidence, readiness, next actor

## Completeness Criteria

A treatment note is complete when:

- [ ] Diagnosis is stated with confidence level
- [ ] Evidence is cited
- [ ] Alternatives are acknowledged
- [ ] At least 2 treatment options are presented
- [ ] Risks are assessed for each option
- [ ] A recommendation is made
- [ ] Handoff is specified

## Handoff Options

The treatment note can be handed off to:

1. **Human approval** — Required before implementation
2. **Planning skill** — For implementation sequencing
3. **Implementation agent** — After approval granted

## Readiness Levels

| Readiness | Meaning |
|-----------|---------|
| Ready for implementation | Diagnosis confident, treatment clear, approval needed |
| Needs more investigation | Diagnosis uncertain, recommend more exam |
| Blocked | Missing information or access prevents progress |

## Quality Checklist

Before completing the treatment note:

- [ ] Did I state diagnosis with appropriate uncertainty?
- [ ] Did I cite evidence for the diagnosis?
- [ ] Did I present multiple options?
- [ ] Did I assess risks for each option?
- [ ] Did I avoid executing any changes?
- [ ] Is this note consumable by a human reviewer?

## Final Statement

Every treatment note must end with:

```
Treatment note complete. No changes executed. Approval required before implementation.
```

This makes explicit that treatment is a proposal, not an action.
