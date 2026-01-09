# Output

Output format and handoff for `doctor-exam`.

## Output Artifact

The exam skill produces a single artifact: **Exam Note**.

Use the template at `../.resources/assets/EXAM_NOTE.md`.

## Required Sections

Every exam note must include:

1. **Exam Scope** — What was examined and what was excluded
2. **Evidence Gathered** — Confirming, disconfirming, and neutral
3. **New Findings** — Unexpected discoveries
4. **Confidence Update** — Initial vs updated confidence with rationale
5. **Alternative Explanations** — What else remains plausible
6. **Exam Conclusion** — Status (confirmed/weakened/inconclusive/falsified)
7. **Handoff** — Next recommended action

## Completeness Criteria

An exam note is complete when:

- [ ] Scope is clearly defined
- [ ] Both confirming and disconfirming evidence is documented
- [ ] Confidence is updated with rationale
- [ ] Falsification criteria are stated
- [ ] New findings are surfaced
- [ ] Handoff is specified

## Handoff Options

The exam note can be handed off to:

1. **`doctor-treatment`** — If diagnosis confidence is sufficient (>70%)
2. **`doctor-triage`** — If scope expansion needed (new suspects found)
3. **`doctor-exam`** — If deeper examination of same area needed
4. **Human review** — If judgment required

## Confidence Thresholds

- **>90%** — Strong diagnosis, ready for treatment
- **70-90%** — Good diagnosis, treatment can proceed with caveats
- **50-70%** — Moderate, consider additional exam or alternative hypotheses
- **<50%** — Weak, recommend re-triage or alternative exam

## Quality Checklist

Before completing the exam note:

- [ ] Did I stay within scope?
- [ ] Did I seek disconfirming evidence?
- [ ] Did I update confidence based on findings?
- [ ] Did I state what would falsify the hypothesis?
- [ ] Is this note consumable by an agent with no prior context?
