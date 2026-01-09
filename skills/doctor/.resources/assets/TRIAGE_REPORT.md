# Triage Report

**Date:** {date}
**Patient:** {repository/system name}
**Triage Agent:** {agent identifier}
**Source:** {intake note reference or direct witness statement}

---

## Symptom Recap

{Brief summary of symptoms from intake or witness statement}

---

## Hypothesis Enumeration

Hypotheses are enumerated **breadth-first** across ownership zones.

### Zone: Application Code (Backend)

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H1 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: Application Code (Frontend)

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H2 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: CI/CD Pipeline

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H3 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: Container / Build

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H4 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: Kubernetes / Orchestration

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H5 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: Cloud Infrastructure (IaC)

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H6 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: Configuration / Environment

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H7 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

### Zone: Dependencies / Versions

| # | Hypothesis | Likelihood | Evidence Pointer |
|---|------------|------------|------------------|
| H8 | {hypothesis} | {high/medium/low} | {file:line or grep pattern} |

---

## Ranked Hypotheses

| Rank | Hypothesis | Confidence | Rationale |
|------|------------|------------|-----------|
| 1 | {H#: brief description} | {%} | {why this ranks highest} |
| 2 | {H#: brief description} | {%} | {why this ranks second} |
| 3 | {H#: brief description} | {%} | {why this ranks third} |

---

## Assumptions Under Dispute

Assumptions from the witness statement that may be incorrect:

- **Assumption:** {what user assumed}
  **Dispute:** {why it might be wrong}

---

## Zones Not Considered

Zones explicitly excluded and why:

- {Zone}: {reason for exclusion}

---

## Recommended Next Steps

### Primary Recommendation

**Examine:** {H# — hypothesis to investigate first}
**Reason:** {why this merits focused examination}

### Alternative Path

If primary exam is negative:
**Examine:** {H# — fallback hypothesis}

---

## Handoff

This triage report is ready for:

- [ ] `doctor-exam` — focused examination of ranked suspect
- [ ] Human review — if hypothesis ranking is disputed

**Triage complete.** No deep investigation performed. No fixes proposed.
