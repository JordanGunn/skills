# Output

Output format and handoff for `doctor-triage`.

## Output Artifact

The triage skill produces a single artifact: **Triage Report**.

Use the template at `../.resources/assets/TRIAGE_REPORT.md`.

## Required Sections

Every triage report must include:

1. **Symptom Recap** — Summary from intake or witness statement
2. **Hypothesis Enumeration** — Hypotheses by zone
3. **Ranked Hypotheses** — Top 3+ ranked by likelihood
4. **Assumptions Under Dispute** — Challenged assumptions
5. **Zones Not Considered** — Explicitly excluded zones with reasons
6. **Recommended Next Steps** — Which hypothesis to examine first
7. **Handoff** — Next recommended action

## Completeness Criteria

A triage report is complete when:

- [ ] All mandatory zones have been considered (or explicitly excluded)
- [ ] At least 3 hypotheses are ranked
- [ ] Evidence pointers are cited for each hypothesis
- [ ] Disputed assumptions are called out
- [ ] A clear next step is recommended
- [ ] Handoff is specified

## Handoff Options

The triage report can be handed off to:

1. **`doctor-exam`** — For focused examination of top hypothesis
2. **Human review** — If hypothesis ranking is disputed or unclear

## Quality Checklist

Before completing the triage report:

- [ ] Did I consider all zones (not just the obvious one)?
- [ ] Did I avoid collapsing to a single answer?
- [ ] Did I cite evidence pointers (not conclusions)?
- [ ] Did I challenge assumptions from the intake?
- [ ] Is this report consumable by an agent with no prior context?
