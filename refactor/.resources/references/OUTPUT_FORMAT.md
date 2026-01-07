# Output Format (Shared)

All refactor skills produce a single Markdown report following this structure:

## Report Structure

1. **Summary** (1 paragraph)
   - Scope of audit
   - Number of findings by severity
   - High-level recommendation

2. **Findings** (grouped by severity)
   - Blockers
   - Strongly Recommended
   - Suggestions / Informational

## Finding Template

For each finding:

- **Location:** `file:line` or `file → symbol`
- **Issue:** Why it violates the relevant doctrine (1 sentence)
- **Fix:** Recommended minimal refactor
- **Risk:** Migration risk or breaking change notes (if applicable)

## Style Guidelines

- Avoid moralizing language
- Focus on clarity and structure
- Prefer minimal viable refactors over sweeping changes
- If a refactor is too large, propose a safe intermediate step
