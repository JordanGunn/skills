# Checks

Run these checks systematically:

## 1. Public API Return Types (Blocker)

Flag any public function or method that:

- returns `dict`, `Dict[...]`, or `Mapping[...]`
- returns untyped dictionary literals
- returns `Dict[str, Any]` in any form

For each finding:

- Identify the public boundary
- Propose a structured replacement (dataclass, object)
- If conversion is non-trivial, propose an intermediate wrapper

## 2. Dictionary Parameters Used as Configuration (Blocker)

Flag functions where:

- dictionaries are used to pass configuration options
- behavior is controlled via string keys
- defaults or optional behavior is encoded via dict lookup

Recommend:

- explicit parameters
- configuration objects
- dataclasses

## 3. Deep or Nested Dictionaries (Strongly Recommended)

Flag dictionary literals or structures with nesting depth > 2.

Assess whether:

- the structure is fixed
- keys are known
- the dictionary is acting as a hidden schema

Recommend:

- flattening
- conversion to structured types
- `TypedDict` as a temporary boundary type

## 4. Magic String Keys (Strongly Recommended)

Flag dictionary usage where:

- keys are inline string literals
- no constants or enums define the key space

Recommend:

- key constants
- enums
- structured objects

## 5. Permitted Uses (No Action / Informational)

Do not flag:

- internal caches
- counters or aggregations
- serialization intermediates that immediately convert to objects
- truly dynamic, user-defined key-value storage

Explicitly note when dictionary usage is acceptable, to avoid false positives.
