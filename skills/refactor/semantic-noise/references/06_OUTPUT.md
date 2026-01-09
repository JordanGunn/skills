# Output Format

Produce a single Markdown report with:

- Summary (1 paragraph)
- Findings grouped by severity:
  - Blockers (rare; only if the change introduces public API noise that will spread)
  - Strongly Recommended
  - Suggestions

For each finding:

- Location (file + symbol)
- Why it violates namespace integrity (1 sentence)
- Recommended fix (minimal viable refactor)
- If refactor is too large: a safe intermediate step

## Success Criteria

This workflow succeeds if it:

- Identifies concrete namespace boundaries that should exist
- Produces refactors that *reduce* naming complexity
- Avoids broad renaming churn
- Preserves readability and discoverability
