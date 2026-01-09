# Purpose

The `doctor-treatment` skill produces a treatment note with diagnosis, confidence, and proposed options.

## Why Treatment Matters

After examination, we have evidence. But evidence is not action.

Treatment translates evidence into **actionable proposals** while preserving:

- Uncertainty about the diagnosis
- Multiple paths forward
- Risk assessment for each path
- Approval requirements

## What Treatment Does

1. **States** the primary diagnosis with confidence
2. **Cites** supporting evidence
3. **Presents** multiple treatment options
4. **Assesses** risks for each option
5. **Recommends** a path forward (but does not execute)

## What Treatment Does NOT Do

- Execute changes
- Assume diagnosis is certain
- Present only one option
- Skip risk assessment

## The Treatment Mindset

Think of treatment as a **medical prescription**:

- The prescription is based on best available evidence
- It is not guaranteed to work
- It has known risks and side effects
- The patient (or human reviewer) must approve it
- Implementation is a separate step

## Success Criteria

A successful treatment note:

- States diagnosis with confidence level
- Cites supporting evidence
- Presents at least 2 options (including "do nothing" when appropriate)
- Assesses risks for each option
- Recommends a path without executing it
- Is consumable by planning skills or human reviewers
