# Output Format

A single Markdown report:

- Summary (1 paragraph)
- Findings grouped by severity:
  - Strongly Recommended (generic symbols imported directly)
  - Suggestions (style improvements, alias consistency)

For each finding:

- Location (file + line)
- Current import statement
- Why it loses context (1 sentence)
- Recommended replacement import
- Required callsite edits (example)
