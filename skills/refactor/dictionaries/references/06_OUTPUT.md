# Output Format

Produce a single Markdown report with:

- Summary (1 paragraph)
- Findings grouped by severity:
  - Blockers
  - Strongly Recommended
  - Informational / Acceptable Uses

For each finding:

- Location (file + function/class)
- Why it violates the dictionary doctrine (1 sentence)
- Recommended fix (minimal viable refactor)
- Notes on migration risk (if applicable)

Avoid moralizing language. Focus on clarity and structure.

## Success Criteria

This workflow succeeds if it:

- Prevents dictionaries from leaking into public APIs
- Makes hidden structure explicit
- Improves type safety and IDE support
- Reduces long-term maintenance and refactor risk
