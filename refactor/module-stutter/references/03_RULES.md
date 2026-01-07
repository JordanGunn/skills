# Scope Rules

Default to auditing only:

- Changed files in the current diff (preferred)
- Newly introduced modules/files
- `__init__.py` exports / public API surfaces

Avoid repo-wide churn unless asked.

## R1: Refactor completion is mandatory (no re-export shims by default)

When resolving module stutter by moving code into a new namespace (e.g., introducing `cache/`),
the refactor is not considered complete if the legacy module remains as a re-export shim.

**Disallowed patterns** (unless explicitly requested by the user):

- A legacy module that exists only to `from new.path import X` and re-export via `__all__`
- Docstrings stating "this module re-exports canonical definitions from ..."
- Forwarding modules that preserve old import paths "just in case"

**Required outcome (default):**

- Update internal callsites to import from the new canonical namespace
- Remove the legacy module entirely
- If a file must remain temporarily (rare), it must hard-fail with a clear error and an explicit removal deadline

### Rationale

Re-export shims preserve legacy paths and create long-term drift by keeping two “authoritative” entry points alive.

## R2: Stutter removal implies namespace-qualified usage, not symbol hoisting

Removing stutter typically produces intentionally generic identifiers (e.g., `Metadata`, `Header`, `Spec`, `File`)
that only have meaning when namespaced.

Therefore, prefer usage patterns like:

- `from pulsar.api.spatial import cache; cache.Metadata(...)`
- `import pulsar.api.spatial.cache as cache; cache.Metadata(...)`

Avoid:

- `from pulsar.api.spatial.cache import Metadata; Metadata(...)`

### Rationale

Namespace-qualified usage preserves meaning, reduces shadowing risk, and keeps refactors localized to import declarations.
