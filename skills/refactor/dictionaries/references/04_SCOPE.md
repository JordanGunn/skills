# Audit Scope

Prefer to audit only:

- Newly introduced or modified public APIs
- Changed function signatures and return types
- New configuration or state-like structures
- Areas where dictionaries cross module boundaries

Avoid auditing untouched legacy code unless explicitly requested.
