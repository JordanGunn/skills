# Rules

## R1: Prefer namespace-first imports for generic identifiers

If a symbol name is generic, it should remain qualified.

Preferred:

- `from pulsar.api.spatial import cache` + `cache.Metadata()`

Avoid:

- `from pulsar.api.spatial.cache import Metadata` + `Metadata()`

## R2: Direct symbol imports allowed only for globally specific names

Acceptable:

- `from pulsar.api.index.morton.payload import BootstrapPayload`
- `from pulsar.math.linalg import OrthogonalProcrustes`

Heuristic: if the identifier would still be unambiguous in an unrelated file, it may be directly imported.

## R3: Prefer module aliasing over symbol hoisting

If the canonical module path is long, alias the module/package:

- `import pulsar.api.spatial.cache as cache`
- `import pulsar.api.index.morton.payload as morton_payload`

Do not shorten meaning by importing generic symbols directly.

## R4: Minimize local shadowing

Avoid introducing locals that shadow imported namespaces or common symbols:

- avoid `cache = ...` when `import ... as cache` is in scope
- avoid redefining `Metadata`, `Config`, `Spec` in local scope

## R5: Refactor compatibility does not justify import hygiene regressions

When migrating callsites after refactors, fix import style at the same time.
Import style is part of the refactor completion.
