# Enforcement Options

## Option A: AST Report + CI Gate (recommended)

Run the script:

- Changed files only:
  - `python scripts/ast.py --changed-only`
- Specific paths:
  - `python scripts/ast.py path/to/file.py other.py`

### Outputs

- A Markdown report to stdout (or `--out report.md`)
- Exit code `1` if violations found unless `--no-fail`

## Option B: Pylint Plugin (optional)

If you already use Pylint (or want lint-level enforcement), use the plugin in `scripts/pylint.py`.

## Option C: Shim Detection (Refactor Completion Gate)

In addition to stutter detection, the audit must flag *legacy shim modules* introduced during stutter refactors.

A module is considered a shim if:

- It contains mostly imports from a new canonical namespace
- It defines no substantial logic beyond re-exports
- It has `__all__` mirroring those imports
- It advertises itself as a re-export layer

### Default policy

- Shims are **Strongly Recommended** findings (or **Blockers** if they re-export public API)
- The recommended fix is to migrate callsites and delete the shim
