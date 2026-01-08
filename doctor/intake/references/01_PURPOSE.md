# Purpose

The `doctor-intake` skill exists to convert raw user descriptions into clinically precise intake notes.

## Why Intake Matters

When a user describes a problem, they are providing a **witness statement**:

- They describe what they observed
- They often include what they *think* is wrong
- They may omit context they consider irrelevant
- They may use incorrect or imprecise terminology

The intake skill's job is to **capture** this information accurately while **separating** observation from interpretation.

## The Intake Note

The intake note is a **clinical record** that:

1. Preserves the user's exact words where relevant
2. Translates terminology to system-accurate terms
3. Explicitly separates facts from beliefs
4. Infers missing context where possible
5. Produces searchable tokens for triage

## What Intake Is NOT

Intake is **not** diagnosis. The intake agent:

- Does not propose causes
- Does not suggest fixes
- Does not run investigations
- Does not accept user framing as correct

Intake produces a **clean handoff artifact** for triage or human review.

## Success Criteria

A successful intake note:

- Contains verbatim evidence (error strings, logs)
- Has normalized terminology
- Clearly separates observation from belief
- Includes inferred context with uncertainty markers
- Provides triage-ready tokens
- Is consumable by another agent with no prior context
