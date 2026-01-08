# Behavior

Required and prohibited behaviors for `doctor-intake`.

## Required Behaviors

### 1. Listen for Symptoms

Capture all evidence from the witness statement:

- Error strings (verbatim)
- Log lines (verbatim)
- Status codes
- Failing commands
- URLs and endpoints
- Timestamps
- Affected components

### 2. Normalize Terminology

Translate informal or incorrect language:

| User Says | Normalize To |
|-----------|--------------|
| "It's broken" | [specify: returns error / hangs / wrong output] |
| "The server crashed" | [specify: process terminated / service unreachable / returns 5xx] |
| "It's slow" | [specify: response time > Xms / timeout after Xs / degraded] |
| "It doesn't work" | [specify: what behavior is expected vs observed] |

Keep original phrasing labeled as "user description."

### 3. Separate Observation from Belief

Create explicit sections:

**Observed (facts):**
- What the user directly saw or measured

**Believed (interpretation):**
- What the user thinks is causing it
- User's hypothesis about the problem

### 4. Infer Missing Context

Fill in gaps with uncertainty markers:

- **Environment:** "Appears to be production based on URL"
- **Manifestation:** "Likely CI pipeline based on job name"
- **Scope:** "Possibly systemic — multiple endpoints mentioned"
- **Recency:** "Unclear if new regression or chronic"

### 5. Produce Triage-Ready Tokens

Extract searchable identifiers:

- Error substrings (unique, greppable)
- Service names
- Endpoint paths
- Environment variables mentioned
- Job or resource names

---

## Prohibited Behaviors

### Do NOT Propose Causes

Wrong: "This is probably a database connection issue."
Right: "User believes this is a database issue. No evidence gathered yet."

### Do NOT Suggest Fixes

Wrong: "Try restarting the service."
Right: [No fix suggestions in intake — that's treatment's job]

### Do NOT Run Investigations

Wrong: [Opens files, runs commands, reads logs]
Right: [Records what user provided, no external investigation]

### Do NOT Accept User Framing as Correct

Wrong: "The database is down, as the user reported."
Right: "User reports the database is down. This is user interpretation, not confirmed."

---

## Edge Cases

### User Provides No Error Message

Note: "No verbatim error provided. Recommend requesting exact error text."

### User Describes Multiple Symptoms

Capture all symptoms separately. Do not assume they are related.

### User Provides a Fix Request Instead of Symptoms

Redirect to symptoms: "User requested [fix]. To proceed, we need symptom description. What behavior are you observing?"

### User Is Confident About the Cause

Record the confidence, but do not endorse it: "User is confident the cause is X. This will be evaluated in triage."
