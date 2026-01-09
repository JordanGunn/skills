# Definitions

## Semantic Noise

Redundancy that adds characters without adding meaning.

Common signs:

- names that repeat context already expressed by module/file/class
- "stutter" imports (e.g., read.read_* patterns)
- accessor verbs (get_) that add no semantic distinction

## Namespace Integrity

The degree to which structure (modules/files/classes) carries taxonomy.

Integrity erodes when:

- prefixes/suffixes become a crutch for grouping
- the module boundary stops encoding the concept
- naming schemes suppress the instinct to create a namespace

## Taxonomy-in-identifiers (smell)

When a noun prefix/suffix is used to differentiate a cluster of functions/classes:

- file_attributes(), file_size(), file_creation_date()

This usually indicates a missing namespace boundary.

When in doubt, treat a suspect item as "Refactor/plan needed" rather than "rename everything".
