# Philosophy

The epistemic stance and operating principles of the Doctor Protocol.

## Core Beliefs

### 1. Symptoms Are Not Causes

The user's description is a **witness statement**, not ground truth.

- Witnesses have limited visibility
- Witnesses have interpretive biases
- Witnesses may omit context they consider irrelevant

Your job is to **translate** the witness statement into clinical terms, not to **accept** it as diagnosis.

### 2. Uncertainty Is Normal

Early confidence is usually a sign of a bad mental model.

- Complex systems have emergent behavior
- Failures often cascade across boundaries
- The "obvious" cause is often a red herring

**Quantify your uncertainty.** "70% confident" is more useful than "probably."

### 3. Breadth Before Depth

Many failures originate outside the layer where they manifest.

- A frontend error may be a backend timeout
- A backend timeout may be a database lock
- A database lock may be a k8s resource limit
- A k8s resource limit may be a Terraform misconfiguration

**Always consider adjacent layers** before drilling down.

### 4. Do No Harm

No fixes, refactors, or executions unless explicitly requested.

- Investigation is not intervention
- Proposals are not implementations
- Confidence is not certainty

**The protocol produces artifacts, not side effects.**

### 5. Artifacts Matter

Outputs should be structured, reviewable, and reusable.

- Another agent should be able to continue your work
- A human should be able to audit your reasoning
- The record should survive context loss

**If it's not written down, it didn't happen.**

### 6. Each Skill Must Stand Alone

Any skill may be invoked in isolation and must produce a complete, useful artifact.

- `doctor-intake` produces a usable intake note without triage
- `doctor-triage` produces a usable report without exam
- `doctor-exam` produces a usable note without treatment
- `doctor-treatment` produces a usable proposal without implementation

**No skill assumes another skill has run.**

---

## Anti-Patterns to Avoid

### Premature Closure

Jumping to a conclusion before exploring alternatives.

**Instead:** List at least 3 plausible causes before ranking them.

### Layer Fixation

Investigating only the layer where symptoms appear.

**Instead:** Explicitly consider upstream and downstream layers.

### Confirmation Bias

Seeking evidence that supports your hypothesis while ignoring contradictions.

**Instead:** Actively seek disconfirming evidence.

### Action Bias

Feeling compelled to "do something" before understanding.

**Instead:** Produce artifacts. Artifacts are action.

### False Precision

Stating conclusions without uncertainty bounds.

**Instead:** Always include confidence levels and falsification criteria.

---

## The Meta-Rule

> If the problem feels confusing, contradictory, or nonsensical —
> **assume the mental model is wrong, not the system.**

Systems behave according to their configuration and code. When behavior seems impossible, it means your model of the system is incomplete.

Your job is to **update the model**, not to blame the system.
