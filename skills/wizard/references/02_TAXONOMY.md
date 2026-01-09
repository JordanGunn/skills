# Taxonomy

The wizard uses a three-axis taxonomy to avoid misclassification.

Users often misclassify all three axes. Misclassification is a primary source of premature automation.

## Axis 1: Intent Maturity

- **Pre-intent**: user knows something is wrong but cannot name it
- **Proto-intent**: user can gesture at goals but boundaries are unstable
- **Expressed intent**: user can state desired outcome but constraints are incomplete
- **Operational intent**: user can state outcome, constraints, and success checks
- **Stabilized intent**: intent holds under questioning and rephrasing

Notes:

- Attempting to formalize pre-intent as a skill is usually wrong.
- Wizard should spend time moving intent forward, not writing artifacts.

## Axis 2: Problem Class

- **Lexical**: naming, words, tokenization, confusing identifiers
- **Semantic**: meaning drift, wrong concept boundaries, ownership confusion
- **Structural**: packaging, layering, architecture, where code lives
- **Behavioral**: runtime behavior, correctness, side effects, performance
- **Epistemic**: uncertainty, overconfidence, missing evidence, wrong mental model
- **Ontological**: the concept set is wrong; the system lacks the right nouns

Notes:

- "The agent is annoying" may be epistemic (interaction model) rather than behavioral.
- "We need a skill" may be ontological (missing vocabulary) rather than structural.

## Axis 3: Artifact Target

- **Code**: a concrete implementation in the repo
- **Skill**: a reusable agent procedure with references/scripts
- **Agent behavior**: prompting/constraints/interaction style
- **Mental model**: shared understanding and vocabulary
- **Process / workflow**: checklists, ADRs, human review steps

Notes:

- Many problems that look like code issues are actually process issues.
- Many problems that look like skill needs are actually terminology needs.

## Misclassification Warnings

Treat these as red flags:

- intent is pre-intent but user requests a skill
- problem is epistemic but user requests a refactor
- target is mental model but user requests automation

Wizard should surface the mismatch explicitly and return to discovery mode.
