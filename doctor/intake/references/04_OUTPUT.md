# Output

Output format and handoff for `doctor-intake`.

## Output Artifact

The intake skill produces a single artifact: **Intake Note**.

Use the template at `../.resources/assets/INTAKE_NOTE.md`.

## Required Sections

Every intake note must include:

1. **Witness Statement (Verbatim)** — User's original description
2. **Symptom Summary** — Categorized symptoms with evidence
3. **Clinical Context** — Environment, manifestation, scope, recency
4. **Observation vs. Belief** — Explicit separation
5. **Triage-Ready Tokens** — Searchable identifiers
6. **Missing Information** — Gaps that would improve triage
7. **Handoff** — Next recommended action

## Completeness Criteria

An intake note is complete when:

- [ ] All verbatim evidence is captured
- [ ] Terminology is normalized
- [ ] Observations and beliefs are separated
- [ ] Context is inferred (with uncertainty markers)
- [ ] Tokens are extracted
- [ ] Missing information is noted
- [ ] Handoff recommendation is provided

## Handoff Options

The intake note can be handed off to:

1. **`doctor-triage`** — For breadth-first hypothesis surfacing
2. **Human review** — If additional context is needed before triage

## Quality Checklist

Before completing the intake note:

- [ ] Did I preserve verbatim evidence exactly?
- [ ] Did I avoid proposing causes?
- [ ] Did I separate observation from belief?
- [ ] Did I mark inferences with uncertainty?
- [ ] Is this note consumable by an agent with no prior context?

## Example Handoff Statement

```
This intake note is ready for:
- [x] doctor-triage — breadth-first hypothesis surfacing
- [ ] Human review — if additional context needed

Intake complete. No causes proposed. No fixes suggested.
```
