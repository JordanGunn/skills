# Scope

Boundary constraints for `doctor-exam`.

## Single Suspect Rule

Each exam examines **ONE** suspect area.

If you need to examine multiple areas:

1. Complete the current exam
2. Hand off to triage for re-prioritization
3. Run a new exam on the next suspect

Do not expand scope within an exam.

## Defining the Suspect Area

The suspect area should be:

- **Specific** — "The database connection pool in `src/db/pool.py`"
- **Bounded** — A defined set of files, components, or configurations
- **Testable** — Observable evidence exists

Bad suspect definitions:

- "The backend" (too broad)
- "Something in the code" (too vague)
- "Whatever is causing this" (not testable)

## What to Include in Scope

- Files directly related to the hypothesis
- Configuration that affects the suspect component
- Logs from the relevant time window
- Metrics from the relevant service
- Dependencies of the suspect component

## What to Exclude from Scope

- Unrelated components (even if interesting)
- Historical context beyond what's needed
- Alternative hypotheses (those are other exams)
- Fixes or improvements (that's treatment)

## Scope Escalation

If during exam you discover:

- The scope needs to expand → Document and recommend re-triage
- A new suspect emerges → Document and recommend new exam
- The hypothesis is falsified → Document and conclude exam

Never silently expand scope.
