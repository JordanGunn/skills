# Goal

Detect **module/package stutter** in exported/public identifiers, where the symbol repeats the semantic context already provided by the module/package.

Examples to flag:

- `las.py` exports `File`, `LasReader`, `LasWriter`
- `work_unit.py` exports `WorkUnitSpec`, `WorkUnitPlan`
- Any `X.py` exporting `XThing` where `X` is the module’s semantic namespace

Preferred:

- `las.File`, `las.Reader`, `las.Writer`
- `work_unit.Spec`, `work_unit.Plan`

This skill produces a **single Markdown report** and can optionally **fail CI** when violations are found.
