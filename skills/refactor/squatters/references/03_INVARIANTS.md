# Invariants

Rules that determine namespace integrity violations.

## Primary Invariant

> **Every module should be importable from a path that a domain expert would guess correctly.**

If you must explain why a module lives where it does, the structure is wrong.

## Structural Invariants

### INV-1: Package Names Must Not Be Semantic Voids

Package names like `common`, `utils`, `helpers`, `core`, `shared`, `misc` are **semantic voids** — they describe relationship to other code, not domain responsibility.

**Test:** Can you describe what the package contains without using words like "shared", "common", or "various"?

### INV-2: Module Names Must Not Compensate for Path

If a module name includes a prefix/suffix that matches a sibling package, the module belongs inside that package.

**Test:** Does removing the prefix/suffix make the module name ambiguous only because of its location?

- `points/las_fields.py` → `las_fields` is unambiguous only because it's not in `las/`
- Should be: `points/las/fields.py` → `fields` is unambiguous by path

### INV-3: Directory Levels Must Not Mix Organizational Axes

Each directory level should follow one organizational principle:

- **By format:** `las/`, `copc/`, `laz/`
- **By verb:** `read.py`, `write.py`, `open.py`
- **By noun:** `schema.py`, `header.py`, `vlr.py`

**Test:** Can you state the principle that determines what belongs at this level?

### INV-4: Import Direction Must Respect Layer Boundaries

Lower layers must not import from higher layers:

```
data → io → engine → processor → cli
  ↑      ↑      ↑         ↑
  │      │      │         │
  └──────┴──────┴─────────┘
     Imports flow this direction only
```

**Test:** Does any import path cross a boundary rightward?

### INV-5: Single-Function Modules Must Justify Existence

A module with one exported function is acceptable only if:

1. It is an intentional API boundary (e.g., facade)
2. It has meaningful internal state or configuration
3. It represents a distinct domain concept

**Test:** Could this function live in an existing module without violating cohesion?

## Corollaries

### COR-1: Homeless Concepts Become Utility Dumps

When a concept lacks a named home, it lands in `common/` or similar. Each addition makes the next more likely.

### COR-2: Compensatory Naming Propagates

One stuttery sibling (`las_fields.py`) invites more (`las_schema.py`, `las_helpers.py`). The pattern becomes "how we do things here."

### COR-3: Layer Bleeding Creates Circular Dependencies

If `io/driver/` imports from `processor/`, eventually `processor/` will need something from `io/driver/`. The cycle is latent.
