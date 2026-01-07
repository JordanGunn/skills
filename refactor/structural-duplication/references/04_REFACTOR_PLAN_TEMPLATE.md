# Refactor Plan Template (Staged, Safe)

Use this when subtle abstraction is required.

## Plan principles

- Small PRs
- No behavior changes until parity tests exist
- Extract first, then generalize
- Preserve public entrypoints and semantics

## Stage 0 — Guardrails

- Add/identify tests that assert output equivalence for each pipeline.
- Add fixtures/snapshots for representative inputs.
- Confirm performance/memory expectations (if relevant).

## Stage 1 — Extract shared pure helpers

- Move obviously shared, pure computations (e.g., bounds selection, shape math) into a shared module.
- Keep call sites unchanged except imports.

## Stage 2 — Introduce seam interface

- Define minimal seam (strategy/hook) in the kernel module.
- Provide two concrete implementations (one per pipeline) without changing behavior.

## Stage 3 — Extract pipeline spine into kernel

- Move orchestration skeleton into one kernel function.
- Keep per-product facade calling the kernel with the appropriate strategy.

## Stage 4 — Cleanup and consolidate

- Remove duplicated local helpers now unused.
- Ensure no circular imports.
- Document kernel usage and seam responsibilities.

## Stage 5 — Optional: Performance polish (only if needed)

- Confirm chunking/reduction remains correct and efficient.
- Ensure lazy execution graph is preserved.
