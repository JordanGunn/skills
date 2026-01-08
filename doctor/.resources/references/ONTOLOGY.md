# Ontology (Shared Vocabulary)

The Doctor Protocol uses medical terminology intentionally. It gives agents *permission* to challenge assumptions without being adversarial.

## Core Terms

| Term | Definition | Software Analog |
|------|------------|-----------------|
| **Patient** | The codebase or system under examination | Repository, service, cluster |
| **Symptom** | Observed failure, error, or misbehavior | Exception, timeout, wrong output |
| **Witness statement** | The user's narrative description | Bug report, Slack message, ticket |
| **Clinical record** | A structured artifact produced by a skill | Intake note, triage report |
| **Triage** | Breadth-first hypothesis surfacing and prioritization | Initial investigation |
| **Exam** | Focused evidence gathering in one area | Deep dive |
| **Treatment** | A proposed response plan (not execution) | Fix proposal, remediation plan |

## Why Medical Framing?

### 1. It separates observation from interpretation

A doctor does not assume the patient's self-diagnosis is correct. Similarly, we do not assume the user's framing is correct.

### 2. It normalizes uncertainty

Medicine operates with probabilistic reasoning. So should debugging. "Likely cause" is not "definite cause."

### 3. It prevents premature action

Doctors follow protocols before prescribing treatment. We follow protocols before writing code.

### 4. It creates reviewable artifacts

Medical records exist for handoff, audit, and continuity. Our clinical records serve the same purpose.

## Usage Guidelines

When writing clinical records:

- Use "symptom" instead of "bug" or "issue"
- Use "witness statement" when quoting user descriptions
- Use "patient" when referring to the system holistically
- Use "treatment" for proposed fixes, never "solution" (implies certainty)
- Use "confidence: X%" to quantify uncertainty

## Confidence Levels

| Level | Meaning |
|-------|---------|
| **>90%** | Strong evidence, few alternative explanations |
| **70-90%** | Good evidence, some alternatives remain |
| **50-70%** | Moderate evidence, multiple plausible causes |
| **<50%** | Weak evidence, requires more investigation |

Always state what would falsify your hypothesis.
