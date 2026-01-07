# Intent

Prevent codebase spiral caused by **parallel pipeline infrastructure** implemented independently across multiple domain products.

This skill assumes:

- domain-facing concepts can be legitimately distinct (ontologically separate),
- but their pipelines can still be structurally equivalent underneath.

The objective is to identify duplication at the **pipeline spine** level and propose a unification path that preserves semantics while eliminating duplicated infrastructure.
