# Preconditions

## Inputs (minimum)

- A target scope, one of:
  - a directory/package subtree
  - a set of files
  - a diff/PR/commit range
  - a list of problematic identifiers

## Assumptions

- Names should be interpreted in *their namespace context* (directory/module/class).
- If intent is ambiguous, prefer the smallest safe change:
  - rename identifiers
  - add alias exports
  - keep backwards compatible import paths if feasible

## Optional helpful context

- Existing naming conventions / style guide
- Whether public APIs are involved (breaking changes risk)
- Whether the language is Python/Go/TS (minor differences in conventions)

## Stop conditions

- Do not propose large directory reshuffles unless there is a clear repeated pattern
  and the report includes a minimal migration plan.
