# Goal

Prevent semantic context loss caused by import style.

Prefer import patterns that keep identifiers meaningfully namespaced, especially when symbols are
intentionally generic outside their module.

## Outcome

- Imports read like “sentences with context”
- Low risk of shadowing common nouns (Metadata, Config, Spec, File)
- Refactors stay localized to import declarations instead of rippling through code
