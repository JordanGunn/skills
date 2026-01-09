# Protocol

The wizard operates as a guided sensemaking loop. It is a discovery process, not a production pipeline.

## Inputs

Wizard can start from any of:

- a vague request ("make a skill for this")
- a discomfort signal ("something feels wrong")
- a confusing behavior ("the agent does the wrong thing")
- an existing artifact (code, skill, workflow, prompt)

## Loop

### Step 1: Establish the Target

Ask:

- What is the target artifact?
- What is the user trying to improve: speed, correctness, clarity, safety, or autonomy?

Record the answer in the Working Model.

### Step 2: Classify (Taxonomy)

Classify the situation across three axes:

- Intent maturity
- Problem class
- Artifact target

If the user disagrees with a classification, treat that disagreement as signal and update.

### Step 3: Form One Hypothesis

Propose exactly one hypothesis at a time:

- "I think the problem is primarily semantic drift"
- "I think the intent is proto-intent, not operational intent"
- "I think the target should be process/workflow, not a skill"

A hypothesis must be falsifiable by user confirmation or rejection.

### Step 4: Ask Calibrating Questions

Ask a small set of questions that collapse uncertainty. Prefer questions that:

- distinguish observation from belief
- surface hidden constraints
- reveal the user's definition of success

Stop after each question block and wait for confirmation.

### Step 5: Update the Working Model

Explicitly update:

- confirmed observations
- rejected hypotheses (with reasons)
- open questions

Do not silently revise.

### Step 6: Decide Whether to Converge

Converge only when:

- intent is at least operational intent, or the user explicitly chooses to proceed anyway
- the problem class is stable enough to name
- the target artifact is agreed upon

If convergence criteria are not met, remain in discovery mode.

### Step 7: Select One Terminal Outcome

Choose exactly one terminal outcome from `05_TERMINAL_OUTCOMES.md`.

Refusal is acceptable and sometimes correct.

## Convergence Guardrails

- Do not produce a plan to create a skill unless the user explicitly requests it and intent is stabilized.
- Do not rename the user's concept to make it fit a schema.
- Do not translate uncertainty into complexity (more files, more structure, more automation).

## Periodic Summary Requirement

At any point the conversation becomes long or multi-threaded, summarize:

- the Working Model
- the current hypothesis under test
- what is needed to proceed

The summary is a calibration tool, not a status update.
