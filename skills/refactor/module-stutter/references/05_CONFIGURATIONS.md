# Configuration Knobs

The checker is intentionally conservative but configurable:

- Ignore modules by name (e.g., `api`, `core`, `utils`)
- Ignore symbols via regex (e.g., allow `LAS*` acronyms)
- Only enforce on exports:
  - If `__all__` exists, check only names listed
  - Otherwise check top-level non-underscore definitions
