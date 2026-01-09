# Intake Note

**Date:** {date}
**Patient:** {repository/system name}
**Intake Agent:** {agent identifier}

---

## Witness Statement (Verbatim)

> {User's original description, preserved exactly}

---

## Symptom Summary

### Primary Symptoms

| Symptom | Verbatim Evidence | Category |
|---------|-------------------|----------|
| {symptom 1} | {exact error string, log line, etc.} | {error/timeout/wrong-output/crash/etc.} |
| {symptom 2} | {exact evidence} | {category} |

### Secondary Observations

- {Any additional observations from the witness statement}

---

## Clinical Context (Inferred)

### Environment

- **Context:** {local / dev / staging / prod / unknown}
- **Manifestation:** {CI / runtime / browser / cluster / CLI / unknown}
- **Recency:** {new regression / chronic / first occurrence / unknown}

### Scope Assessment

- **Scope:** {single component / multiple components / systemic / unknown}
- **Affected Area:** {service name, module, endpoint, etc.}

---

## Observation vs. Belief Separation

### What Was Observed (Facts)

- {Fact 1: directly observable, no interpretation}
- {Fact 2}

### What User Believes (Interpretation)

- {Belief 1: user's hypothesis or assumption}
- {Belief 2}

**Note:** User beliefs are recorded for context, not accepted as diagnosis.

---

## Triage-Ready Tokens

Searchable terms for investigation:

### Error Strings

```
{exact error substrings}
```

### Identifiers

- **Services:** {service names}
- **Endpoints:** {API paths, URLs}
- **Jobs:** {CI job names, cron names}
- **Resources:** {k8s resources, cloud resources}
- **Env Vars:** {relevant environment variables mentioned}

---

## Missing Information

Information that would improve triage but was not provided:

- [ ] {Missing item 1}
- [ ] {Missing item 2}

---

## Handoff

This intake note is ready for:

- [ ] `doctor-triage` — breadth-first hypothesis surfacing
- [ ] Human review — if additional context needed

**Intake complete.** No causes proposed. No fixes suggested.
