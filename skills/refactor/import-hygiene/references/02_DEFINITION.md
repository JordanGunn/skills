# Definitions

## Namespace-first import

An import that preserves module context at the usage site.

Examples:

- `from pulsar.api.spatial import cache` → `cache.Metadata(...)`
- `import pulsar.api.spatial.cache as cache` → `cache.Metadata(...)`

## Symbol-hoisting import (context loss)

Directly importing a symbol so its name becomes unqualified in local scope.

Examples:

- `from pulsar.api.spatial.cache import Metadata` → `Metadata(...)`
- `from X import Config` → `Config(...)`

## Generic identifier

A name that is only meaningful within its namespace, e.g.:

- Metadata, Header, Payload, Spec, File, Config, Builder, Reader, Writer
