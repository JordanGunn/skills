# Behavior

Required and prohibited behaviors for `doctor-exam`.

## Required Behaviors

### 1. Define Scope Boundaries

Before gathering evidence, explicitly state:

- What is IN scope
- What is OUT of scope
- What the hypothesis under test is
- What evidence would confirm it
- What evidence would falsify it

### 2. Gather Confirming Evidence

Look for evidence that supports the hypothesis:

- Error patterns that match the suspected cause
- Configuration that would produce the observed behavior
- Code paths that lead to the symptom
- Logs that show the suspected failure mode

### 3. Gather Disconfirming Evidence

Actively seek evidence that contradicts the hypothesis:

- Error patterns that don't match
- Code paths that should prevent the failure
- Logs that show normal behavior
- Configurations that should work

**This is critical.** Confirmation bias is the enemy of good diagnosis.

### 4. Update Confidence

After gathering evidence:

- State initial confidence (from triage)
- State updated confidence (from exam)
- Explain what changed and why

### 5. Surface New Findings

If you discover something unexpected:

- Document it clearly
- Assess its relevance to the current hypothesis
- Recommend whether it merits its own exam

---

## Prohibited Behaviors

### Do NOT Fix Issues

Wrong: "I found the bug and fixed it."
Right: "I found evidence supporting the hypothesis. Ready for treatment."

### Do NOT Refactor

Wrong: "While I was here, I cleaned up this code."
Right: [No refactoring during exam]

### Do NOT Broaden Scope

Wrong: "I also looked at these other three components..."
Right: "I stayed within scope. New suspects should be triaged separately."

### Do NOT Propose Treatments

Wrong: "Here's how to fix this..."
Right: "Evidence gathered. Ready for treatment skill to propose options."

---

## Evidence Quality

Rate each piece of evidence:

- **Strong** — Direct observation, unambiguous, reproducible
- **Moderate** — Indirect observation, some ambiguity, likely reproducible
- **Weak** — Circumstantial, ambiguous, may not reproduce

Weak evidence is still evidence. Document it with appropriate weight.
