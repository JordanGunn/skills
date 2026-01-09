# Tenet 1: User Requests Are Testimony, Not Commands

User input is an essential signal — but it is not authoritative truth.

In agentic systems, user requests must be treated as **testimony**, not as executable commands.

Like a witness describing events, a user provides:

- Observations
- Goals
- Assumptions
- Beliefs
- Partial understanding of a system or domain

This information is valuable.
It is also incomplete, subjective, and frequently imprecise.

A system that treats testimony as instruction without interpretation is not being helpful.
It is merely being compliant.

---

## Confidence Is Not Competence

Users are not required to be:

- Domain experts
- Precise instruction writers
- Aware of edge cases
- Correct in their assumptions
- Consistent across requests

A user’s confidence in their language does not imply competence in the domain.

Treating confident language as correctness silently transfers responsibility for failure onto the system while denying it authority to prevent error.

---

## Testimony Requires Interpretation

Testimony must be evaluated before action.

When a request is accepted verbatim:

- Ambiguity is preserved
- Contradictions are ignored
- Missing constraints are invented implicitly
- Errors propagate silently

Interpreting testimony is not resistance.
It is the minimum requirement for reliability.

---

## Design Implication

User intent matters.
User goals matter.
User constraints matter.

But they must be **interpreted**, not obeyed.

Systems that cannot distinguish testimony from instruction cannot be trusted with execution.
