# Invariants

Use the following invariants when judging code:

## 1. Hierarchy should carry meaning

- Prefer `namespace.Symbol` over `LongSymbolName` when the namespace provides context.
- Avoid names that restate their container.

## 2. Prefixes and suffixes are structural smells

- Repeated prefixes/suffixes in the same domain usually indicate a missing module boundary.
- Names should describe role, not location.

## 3. Imports should read like sentences, not stutters

- Prefer imports that leverage parent modules for semantic context.
- Avoid importing symbols whose names redundantly encode their namespace.

## 4. Avoid defensive verbosity

- Do not add words solely to avoid potential naming conflicts.
- Resolve conflicts structurally: via namespace, module split, or scoped import.
