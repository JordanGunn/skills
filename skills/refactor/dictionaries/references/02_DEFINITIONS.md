# Definitions

## Public API

Any function, method, or class interface that is:

- imported across modules
- exposed via a package `__init__.py`
- part of a documented or intended extension surface

## Improper dictionary usage

Any use of `dict` that:

- represents known structure
- crosses module or architectural boundaries
- obscures intent, ownership, or typing
- substitutes for a class, dataclass, or explicit type

## Permissible dictionary usage

Dictionary usage is acceptable only when:

- keys are truly dynamic or user-defined
- used as an internal, local implementation detail
- immediately converted to a structured object at boundaries

When in doubt, treat a suspect case as "Refactor recommended" rather than "rewrite everything".
