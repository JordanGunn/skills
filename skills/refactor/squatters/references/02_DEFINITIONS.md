# Definitions

Vocabulary for squatters and namespace integrity violations.

## Squatter (n.)

A **squatter** is a module or package that occupies a namespace position it does not semantically own.

The term borrows from real estate: squatters occupy property without legal claim. In codebases, squatters occupy import paths without conceptual legitimacy.

### Why Squatters Emerge

Squatters are a signature failure mode of **agentic programming**:

1. **Velocity over placement** — agents optimize for "working code" not "well-placed code"
2. **Deferred domain modeling** — concepts land somewhere expedient, not somewhere correct
3. **Compensatory naming** — the module name absorbs context the path should carry
4. **Gravity wells** — once `common/` exists, everything homeless lands there

### The Core Problem

Squatters degrade **navigability**. A developer (or agent) cannot guess where code lives because the filesystem lies about ownership. Each squatter makes the next more likely.

---

## Core Concepts

### Namespace Integrity

The property that import paths faithfully represent semantic relationships. A codebase has namespace integrity when:

- A domain expert can guess where code lives from its responsibility
- Module names do not compensate for weak package structure
- Import graphs align with package hierarchy

### Homeless Concept

A responsibility that exists as code but lacks a named place in the package structure. Homeless concepts manifest as:

- Functions dumped into catch-all packages
- Modules with compensatory naming
- Logic split across multiple locations without explicit ownership

### Compensatory Naming

Names that embed context the path should carry. Examples:

- `las_fields.py` (compensates for not being in `las/`)
- `common_helpers.py` (compensates for unclear domain)
- `utils/validation_helpers.py` (double-compensation)

---

## Violation Patterns

### Utility Dump

A package named `common/`, `utils/`, `helpers/`, `core/`, `shared/`, or `misc/` that:

- Contains functions with mixed responsibilities
- Has no internal substructure
- Exists because domain ownership was unclear

**Why problematic:** Defers domain modeling. Becomes a gravity well for future homeless code.

### Stuttery Sibling

A module at directory level N that uses prefix/suffix naming to disambiguate from a sibling package at level N.

**Example:** `points/las_fields.py` beside `points/las/`

**Why problematic:** The module name compensates for not being inside the package. The filesystem lies about containment.

### Thin Wrapper Orphan

A module containing:

- One exported function
- That wraps a dependency from another layer
- Without adding meaningful abstraction

**Example:** A `fields.py` that only attaches a specific error type from `processor/`.

**Why problematic:** Exists only to glue layers together. The abstraction is fictional.

### Axis Violation

A module that breaks the directory's organizational principle.

**Example:** `load_plan.py` (noun) beside `read.py`, `write.py`, `open.py` (verbs)

**Why problematic:** Mixes organizational axes at the same level. Readers cannot predict what else belongs here.

### Semantic Diffusion

A concept split across multiple locations with:

- Similar names in different packages
- Subtly different interfaces or dependencies
- No explicit ownership boundary

**Example:** `data/points/fields.py` vs `io/driver/points/fields.py`

**Why problematic:** Creates shadowing risk. Unclear which location owns the concept.

### Layer Bleeding

An import that crosses architectural boundaries upward:

- Driver layer importing from processor layer
- Data layer importing from engine layer
- Any lower layer depending on a higher layer

**Why problematic:** Inverts dependency direction. Lower layers should not know about higher layers.

---

## Severity Classification

Follows shared refactor skillset severity levels:

| Severity | Criteria |
|----------|----------|
| **Blocker** | Public API violation, import cycle risk, shadowing that causes runtime errors |
| **Strongly Recommended** | Internal structure degradation, maintenance burden, drift risk |
| **Suggestion** | Minor improvements, acceptable patterns reviewed and confirmed |
