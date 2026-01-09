# Goal

Detect and report modules and packages where the filesystem path does not accurately express the concept's domain ownership.

## Why This Matters

Package structure is the **primary carrier of meaning** in a codebase. When structure degrades:

1. **Import paths become misleading** — developers cannot guess where code lives
2. **Domain concepts become homeless** — responsibilities scatter without named containers
3. **Maintenance burden increases** — changes require archaeology instead of navigation
4. **Naming compensates for structure** — modules grow prefixes/suffixes that the path should carry

## What This Skill Detects

This skill identifies five categories of namespace integrity violations:

| Pattern | Signal | Risk |
|---------|--------|------|
| **Utility dump** | `common/`, `utils/`, `helpers/` packages | Low cohesion, deferred domain modeling |
| **Stuttery sibling** | `las_fields.py` beside `las/` package | Namespace violation, wrong home |
| **Thin wrapper orphan** | Single-function module wrapping foreign dependency | Fragmentation, layer bleeding |
| **Axis violation** | Noun module among verb modules | Mixed organizational principles |
| **Semantic diffusion** | Same concept split across layers | Shadowing risk, unclear ownership |

## What This Skill Does NOT Do

- **Does not auto-refactor** — produces hypotheses, not mandates
- **Does not enforce style** — focuses on structural semantics, not formatting
- **Does not replace domain expertise** — surfaces candidates for human judgment

## Success Criteria

A successful audit:

1. Identifies all structural smells in the target scope
2. Classifies each by pattern type and severity
3. Proposes plausible remediation directions
4. Preserves ambiguity where domain intent is unclear
