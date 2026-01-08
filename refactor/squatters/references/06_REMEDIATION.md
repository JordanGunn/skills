# Remediation

Refactoring directions for namespace integrity violations.

These are **hypotheses, not mandates**. Each finding requires human judgment to select the appropriate direction.

---

## Utility Dump Remediation

### Option A: Collapse Into Caller

If the utility package serves a single consumer:

1. Inline functions into the consuming module
2. Delete the utility package
3. Update imports

**When to use:** Low reuse, high coupling to one consumer.

### Option B: Extract Domain Package

If functions share a coherent responsibility:

1. Identify the unnamed concept
2. Create a new package with a domain-aligned name
3. Move functions to appropriate modules within the new package
4. Update imports

**When to use:** Functions have hidden cohesion that deserves a name.

### Option C: Promote to Protocol

If functions define a cross-cutting interface:

1. Define an abstract protocol/interface
2. Move implementations to format-specific packages
3. Keep protocol in a shared location
4. Update imports to use protocol

**When to use:** Functions are called polymorphically across formats.

---

## Stuttery Sibling Remediation

### Option A: Move Into Sibling Package

The obvious fix:

1. Move `las_fields.py` to `las/fields.py`
2. Update all imports
3. Verify no circular dependencies introduced

**When to use:** Almost always the right answer.

### Option B: Rename to Express Domain

If the module truly belongs at the parent level:

1. Rename to remove the compensatory prefix
2. Ensure the new name is unambiguous
3. Update imports

**When to use:** Rare—only when the concept genuinely spans siblings.

---

## Thin Wrapper Remediation

### Option A: Delete and Inline

If the wrapper adds no value:

1. Replace all imports with the wrapped function directly
2. Delete the wrapper module
3. Accept the layer coupling (or address separately)

**When to use:** Wrapper exists only due to historical accident.

### Option B: Move to Owning Layer

If the wrapper belongs with its primary dependency:

1. Move the function to the layer that owns the wrapped type
2. Update imports
3. Eliminate cross-layer coupling

**When to use:** Wrapper is conceptually part of the foreign layer.

### Option C: Extract Policy

If the wrapper encapsulates a decision point:

1. Make the wrapped behavior configurable
2. Move configuration to appropriate location
3. Keep the function as a policy application point

**When to use:** Wrapper represents a real abstraction that was poorly expressed.

---

## Axis Violation Remediation

### Option A: Move to Appropriate Layer

If the module belongs elsewhere:

1. Identify the correct layer based on responsibility
2. Move the module
3. Update imports

**When to use:** Module is clearly misplaced.

### Option B: Create New Organizational Level

If the module represents a new axis:

1. Create a subdirectory for the new axis
2. Move the module and any related siblings
3. Update imports

**When to use:** The axis is legitimate but wasn't expressed structurally.

---

## Semantic Diffusion Remediation

### Option A: Consolidate to Single Location

If one location is clearly authoritative:

1. Merge functionality into the authoritative location
2. Update all imports to the single location
3. Delete the redundant module

**When to use:** One copy is a subset of the other.

### Option B: Make Split Explicit

If the split is intentional:

1. Rename modules to express the distinction
2. Document why both exist
3. Ensure no shadowing risk remains

**When to use:** Different layers legitimately need different interfaces.

---

## Layer Bleeding Remediation

### Option A: Invert Dependency

Move responsibility to respect layer direction:

1. Identify which layer should own the shared concept
2. Move the concept to the appropriate layer
3. Update imports to flow downward

**When to use:** The dependency direction is clearly wrong.

### Option B: Introduce Interface

Decouple layers via abstraction:

1. Define a protocol/interface at the lower layer
2. Have the higher layer implement or provide the interface
3. Lower layer depends only on the interface

**When to use:** Coupling is fundamental but direction must be preserved.

---

## Migration Risk Matrix

| Remediation | Files Affected | Breaking Change Risk | Recommended Approach |
|-------------|----------------|----------------------|----------------------|
| Collapse into caller | Low | None (internal) | Direct refactor |
| Extract domain package | Medium | Low | Alias-first migration |
| Move into sibling | Low | Medium (import paths) | Alias-first migration |
| Delete and inline | Low | None (internal) | Direct refactor |
| Consolidate locations | Medium | Medium | Alias-first migration |
| Invert dependency | High | High | Phased extraction |

### Alias-First Migration Pattern

For changes that affect import paths:

1. Add new location as the canonical home
2. Create re-export alias at old location
3. Migrate consumers incrementally
4. Remove alias after all consumers updated
