# Goal

Run a focused audit to detect inline complexity that obscures intent.

Specifically:

- Nested function calls in arguments
- Deep attribute access chains
- Compound logical or mathematical expressions

Then:

- Propose explicit variable extraction
- Keep logic flat and readable
- Preserve exact behavior

The output should be a single Markdown report.
