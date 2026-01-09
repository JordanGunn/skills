# Invariants

Use the following invariants when judging code:

## 1. Public APIs must be explicit

- Public functions must not return dictionaries.
- `Dict[str, Any]` is never acceptable in public signatures.

## 2. Known structure demands explicit types

If keys are known at design time, use:

- dataclasses
- typed objects
- enums
- `TypedDict` (only as a transitional or boundary type)

## 3. Dictionaries must not encode state

- Application or workflow state must be represented explicitly.
- Dictionaries must not be the system of record.

## 4. Dynamic means truly dynamic

- Aggregation, counting, grouping → acceptable
- Configuration, state, domain models → not acceptable
