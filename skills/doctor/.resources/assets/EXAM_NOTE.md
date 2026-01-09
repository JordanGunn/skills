# Exam Note

**Date:** {date}
**Patient:** {repository/system name}
**Exam Agent:** {agent identifier}
**Subject:** {hypothesis ID and brief description from triage}

---

## Exam Scope

**Suspect Zone:** {zone being examined}
**Hypothesis Under Test:** {H#: specific hypothesis}
**Initial Confidence:** {%}

### Scope Boundaries

This exam is limited to:

- {specific files, directories, or components}
- {specific time range if relevant}
- {specific conditions or scenarios}

This exam explicitly excludes:

- {what is NOT being examined}

---

## Evidence Gathered

### Confirming Evidence

Evidence that supports the hypothesis:

| # | Evidence | Location | Weight |
|---|----------|----------|--------|
| E1 | {what was found} | {file:line or command output} | {strong/moderate/weak} |
| E2 | {what was found} | {location} | {weight} |

### Disconfirming Evidence

Evidence that contradicts the hypothesis:

| # | Evidence | Location | Impact |
|---|----------|----------|--------|
| D1 | {what was found} | {file:line or command output} | {how it affects hypothesis} |
| D2 | {what was found} | {location} | {impact} |

### Neutral Observations

Observations that neither confirm nor disconfirm:

- {observation 1}
- {observation 2}

---

## New Findings

Discoveries not anticipated by triage:

| Finding | Relevance | Recommended Action |
|---------|-----------|-------------------|
| {finding 1} | {how it relates to symptoms} | {escalate/note/ignore} |
| {finding 2} | {relevance} | {action} |

---

## Confidence Update

**Initial Confidence:** {%}
**Updated Confidence:** {%}
**Delta:** {+/-}

### Rationale

{Why confidence changed (or didn't)}

### What Would Falsify This Hypothesis

- {condition 1 that would disprove}
- {condition 2 that would disprove}

---

## Alternative Explanations

Alternatives that remain plausible after this exam:

| Alternative | Confidence | Why Still Plausible |
|-------------|------------|---------------------|
| {alt 1} | {%} | {reason} |
| {alt 2} | {%} | {reason} |

---

## Exam Conclusion

**Status:** {confirmed / weakened / inconclusive / falsified}

{1-2 sentence summary of exam outcome}

---

## Handoff

This exam note is ready for:

- [ ] `doctor-treatment` — if diagnosis confidence is sufficient
- [ ] `doctor-triage` — if scope expansion needed (new suspects found)
- [ ] `doctor-exam` — if deeper examination of same area needed
- [ ] Human review — if judgment required

**Exam complete.** No fixes performed. No code modified.
