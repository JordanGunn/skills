# Output

Produce a single Markdown report with:

## 1. Scope

- What was audited (paths/files/diff)

## 2. Summary

- Counts by issue type:
  - Ontology category errors
  - Lexical-semantic mismatches
  - Semantic role ambiguity
  - Namespace integrity erosion

## 3. Findings (grouped)

For each finding:

- Identifier (and location)
- Implied role (from morphology)
- Actual role (from evidence)
- Why it’s a problem (1–2 lines)
- Recommended fix (rename/move/alias)
- Risk (low/med/high) + migration notes

## 4. Suggested conventions (codified)

- Class naming rule set
- Function naming rule set
- Morphology/role mapping cheatsheet

## 5. Quick wins

- 3–10 minimal changes with high impact

## 6. Optional: Refactor proposals

Only if repeated patterns exist:

- Proposed namespace splits
- Proposed directory renames
- Compatibility strategy (re-exports, deprecation window)
