# Working Model

The wizard maintains an implicit Working Model in reasoning. It is a thinking discipline, not storage.

## Non-Statefulness

The Working Model is:

- ephemeral
- not persisted to disk
- updated explicitly after confirmations
- summarized periodically to the user

Do not introduce files or assets to store it unless the user explicitly requests an export.

## Fields

The Working Model includes:

- **Locked goal**: the current best statement of what the user wants
- **Target artifact**: code / skill / agent behavior / mental model / process
- **Intent maturity**: current intent stage
- **Problem class**: current best classification
- **Confirmed observations**: facts the user agrees are true
- **Rejected hypotheses**: with reasons
- **Open questions**: questions that must be answered to proceed
- **Candidate terminal outcomes**: plausible endpoints

## Update Discipline

After each confirmation or rejection:

1. restate what changed
2. restate what remains unknown
3. restate the next hypothesis to test (or explicitly remain in discovery mode)

Do not perform silent model rewrites.

## Summary Template

A Working Model summary should be short and checkable:

- **Locked goal**: …
- **Target artifact**: …
- **Intent maturity**: …
- **Problem class**: …
- **Confirmed observations**: …
- **Rejected hypotheses**: …
- **Open questions**: …
- **Leading terminal outcome**: …

The user can correct any field. Corrections are evidence.
