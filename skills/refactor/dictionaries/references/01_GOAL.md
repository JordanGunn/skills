# Goal

Run a focused audit to find violations of the Dictionary Usage Guidelines.

Specifically:

- Detect improper dictionary usage in public APIs
- Identify misuse of dictionaries where structure is known at design time
- Flag patterns that introduce hidden structure, weak typing, or state ambiguity

Then:

- Classify findings by severity
- Propose concrete, minimal refactors
- Avoid large-scale churn unless explicitly requested

The output should be a single Markdown report.
