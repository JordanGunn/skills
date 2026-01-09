# Output Format

Report structure for namespace integrity audits.

## Report Template

```markdown
# Namespace Integrity Audit: {scope}

**Date:** {date}
**Scope:** {target_path}
**Findings:** {blocker_count} blockers, {recommended_count} recommended, {suggestion_count} suggestions

## Summary

{1-2 paragraph overview of findings and high-level recommendations}

---

## Blockers

{For each blocker finding, use Finding Template below}

---

## Strongly Recommended

{For each recommended finding, use Finding Template below}

---

## Suggestions

{For each suggestion finding, use Finding Template below}

---

## Remediation Hypotheses

{For major findings, list plausible refactoring directions}

---

## Open Questions

{List any ambiguities that require human judgment}
```

---

## Finding Template

```markdown
### {Pattern Type}: `{location}`

**Violation:** {INV-N reference from 03_INVARIANTS.md}

**Issue:** {1-2 sentences explaining why this is problematic}

**Evidence:**
- {Import graph observation}
- {Naming observation}
- {Structural observation}

**Homeless Concept:** {What responsibility lacks a named home}

**Severity:** {Blocker | Strongly Recommended | Suggestion}

**Remediation Options:**
1. {Option A with brief rationale}
2. {Option B with brief rationale}

**Risk:** {Migration complexity and breaking change notes}
```

---

## Example Finding

```markdown
### Stuttery Sibling: `pulsar/api/io/driver/points/las_fields.py`

**Violation:** INV-2 (Module Names Must Not Compensate for Path)

**Issue:** Module name `las_fields` includes prefix `las_` to disambiguate from sibling package `las/`. The module belongs inside `las/`, not beside it.

**Evidence:**
- Sibling package exists: `pulsar/api/io/driver/points/las/`
- Module imports from `las/`: `from pulsar.api.io.driver.points.fields import validate_fields`
- Consumers are LAS-specific: `las/selective_reader.py`, `copc/selective_reader.py`

**Homeless Concept:** LAS field mapping contract (canonical ↔ laspy dimension names)

**Severity:** Strongly Recommended

**Remediation Options:**
1. Move to `las/fields.py` — natural home, aligns with sibling `las/schema.py`
2. Move to `las/mapping.py` — expresses the bidirectional mapping responsibility

**Risk:** Medium — requires import updates in `las/selective_reader.py` and `copc/selective_reader.py`. No public API impact.
```

---

## Severity Assignment

Use the shared severity levels from `.resources/references/SEVERITY_LEVELS.md`:

| Severity | Criteria |
|----------|----------|
| Blocker | Public API violation, import cycle risk, shadowing causing runtime errors |
| Strongly Recommended | Internal structure degradation, maintenance burden, drift risk |
| Suggestion | Minor improvements, acceptable patterns confirmed safe |

---

## Report Filename Convention

```
docs/audit/refactor-namespace-integrity-{scope}.md
```

Where `{scope}` is the target path with slashes replaced by dashes.

Example: `docs/audit/refactor-namespace-integrity-pulsar-api-io.md`
