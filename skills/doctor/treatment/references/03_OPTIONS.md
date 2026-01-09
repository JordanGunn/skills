# Options

How to formulate and present treatment options in `doctor-treatment`.

## Multiple Options Required

Always present at least 2 options, typically 3:

1. **Primary recommendation** — Best path based on evidence
2. **Alternative approach** — Different strategy with different tradeoffs
3. **Do nothing / watchful waiting** — When appropriate

## Option Structure

For each option, include:

### Approach

Brief description of what the treatment involves.

### Steps

High-level steps (not implementation details):

1. Step 1
2. Step 2
3. Step 3

### Pros

- Advantage 1
- Advantage 2

### Cons

- Disadvantage 1
- Disadvantage 2

### Risk Assessment

- **Blast radius** — What could break?
- **Reversibility** — Easy / Moderate / Difficult / Irreversible
- **Estimated effort** — Trivial / Small / Medium / Large

## The "Do Nothing" Option

Always consider whether doing nothing is viable:

**When "Do Nothing" is appropriate:**

- Issue is cosmetic or low-impact
- Risk of intervention exceeds risk of inaction
- Issue may self-resolve
- More information is needed before acting

**When "Do Nothing" is NOT appropriate:**

- Active data loss or corruption
- Security vulnerability being exploited
- Production outage
- Cascading failure in progress

## Recommendation

After presenting options:

1. State which option you recommend
2. Explain why (based on evidence and risk)
3. List prerequisites before implementation
4. Describe how to verify success

## Implementation Is Separate

Treatment produces a **proposal**.

Implementation happens only after:

- Human approval (or explicit automation policy)
- Prerequisites are met
- Verification plan is in place

Do not conflate treatment with implementation.
