# Definitions

## Structural Duplication (Pipeline-Spine Duplication)

Duplication where code is not necessarily identical, but multiple implementations share the same orchestration skeleton:

- input filtering / selection
- bounds derivation
- grid shape computation
- chunking / partition orchestration
- reduction / combination logic
- validation / nodata handling
- wrapping results into common output containers

Key trait: the *shape of the work* matches, even if the operator differs.

## Domain Boundary (Semantic Boundary)

A module/function boundary that exists because names and entrypoints carry meaning for domain users.
This skill does NOT recommend collapsing or renaming those boundaries.
It focuses on unifying infrastructure beneath them.

## Kernel Candidate

A shared internal module/function that would own extracted pipeline spine logic.
Kernel candidates should be named after the *mechanism* (e.g., "rasterize", "grid_reduce", "tile_pipeline"),
not after a specific domain product.

## Abstraction Seam

The minimal interface needed to unify pipelines without merging domain meaning.
Typical seams:

- aggregator strategy (count/min/max/mean/custom)
- reduction strategy (fmin/fmax/sum/merge)
- nodata policy
- postprocess hook (optional)
- per-chunk transform hook
