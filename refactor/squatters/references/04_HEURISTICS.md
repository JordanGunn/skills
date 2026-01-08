# Heuristics

Detection patterns and signals for namespace integrity violations.

## Filesystem Heuristics

### H-1: Utility Dump Detection

Scan for directories matching:

```
common/
utils/
helpers/
core/
shared/
misc/
internal/
lib/
```

For each match, check:

1. Does it contain only `__init__.py`? → Likely obsolete shim
2. Does `__init__.py` export functions with mixed responsibilities? → Utility dump
3. Does it have substructure? → May be legitimate (inspect further)

### H-2: Stuttery Sibling Detection

For each `.py` file at a directory level:

1. Extract any underscore-delimited prefix (e.g., `las_fields.py` → `las`)
2. Check if a sibling directory matches that prefix
3. If match exists → Stuttery sibling candidate

**Regex pattern:**
```
^([a-z]+)_[a-z]+\.py$  # Captures prefix
```

### H-3: Thin Wrapper Detection

For each `.py` file:

1. Count exported symbols in `__all__` or public names
2. If count == 1:
   - Check if the function body is < 10 lines
   - Check if it primarily wraps an import from another layer
   - If both true → Thin wrapper orphan candidate

### H-4: Axis Violation Detection

For each directory:

1. Classify each child by type:
   - **Verb:** `read`, `write`, `open`, `load`, `save`, `parse`, `build`
   - **Noun:** `schema`, `config`, `header`, `metadata`, `fields`
   - **Format:** matches known format names (`las`, `copc`, `laz`, `tiff`)
2. If directory contains mixed types at same level → Axis violation candidate

### H-5: Semantic Diffusion Detection

Search for modules with identical names in different packages:

```bash
find . -name "*.py" | xargs -I{} basename {} | sort | uniq -d
```

For each duplicate:

1. Compare their responsibilities (docstrings, exports)
2. Check if they have import relationships
3. If related but split → Semantic diffusion candidate

### H-6: Layer Bleeding Detection

Define layer order:

```python
LAYERS = ["data", "io", "engine", "processor", "cli"]
```

For each import statement:

1. Determine source layer (file location)
2. Determine target layer (import path)
3. If target layer index > source layer index → Layer bleeding

---

## Import Graph Heuristics

### H-7: Circular Conceptual Dependency

A package `A/common/` that:

1. Imports from `A/specific/`
2. Is imported by `A/specific/`

...has inverted its stated relationship. `common/` claims to be upstream but is actually downstream.

### H-8: Feature Envy

A module in package `A/` that:

1. Imports multiple symbols from `B/`
2. Exports functions that primarily operate on `B/` types
3. Has few or no imports from `A/`

...likely belongs in `B/`, not `A/`.

---

## Naming Heuristics

### H-9: Compensatory Prefix/Suffix Patterns

Watch for modules named:

- `{package}_helpers.py`
- `{package}_utils.py`
- `{package}_common.py`
- `{format}_fields.py`
- `{format}_schema.py`

Where `{package}` or `{format}` matches a sibling directory.

### H-10: Generic Names Requiring Context

Modules named:

- `helpers.py`
- `utils.py`
- `common.py`
- `misc.py`
- `base.py` (sometimes legitimate)

...are red flags unless the package name provides sufficient context.
