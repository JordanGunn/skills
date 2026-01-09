# Examples

## Prefix stutter

If `las.py` defines:

```py
class File: ...
class LasReader: ...
```

Report suggests:

- Rename `File` → `File`
- Rename `LasReader` → `Reader`
- Keep module context: `import las; las.File.open()`

## Infix stutter (function names)

If `fragment.py` defines:

```py
def write_from_batch(batch): ...
def write_from_batches(batches): ...
def process_fragment_data(data): ...
```

Report suggests:

- Rename `write_from_batch` → `write_from_batch`
- Rename `write_from_batches` → `write_from_batches`
- Rename `process_fragment_data` → `process_data`
- Usage: `fragment.write_from_batch(batch)`

## Infix stutter (CamelCase)

If `fragment.py` defines:

```py
class WriteFragmentBatch: ...
```

Report suggests:

- Rename `WriteFragmentBatch` → `WriteBatch`

## Suffix stutter

If `fragment.py` defines:

```py
def create_fragment(data): ...
def build_fragment(spec): ...
```

Report suggests:

- Rename `create_fragment` → `create`
- Rename `build_fragment` → `build`
- Usage: `fragment.create(data)`

## Preferred import style

When stutter is removed, prefer qualified imports:

```py
# Good
import fragment
fragment.write_from_batch(batch)

# Avoid (loses context)
from fragment import write_from_batch
write_from_batch(batch)
```

## Shim module example (disallowed by default)

Legacy file:

```py
# pulsar/api/spatial/format.py
from pulsar.api.spatial.cache.metadata import Metadata
__all__ = ["Metadata"]

