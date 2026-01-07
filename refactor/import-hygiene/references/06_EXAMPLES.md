# Examples

## Example 1 — Generic symbol hoisted (bad)

```py
from pulsar.api.spatial.cache import Metadata
meta = Metadata()
```

Fix:

```py
from pulsar.api.spatial import cache
meta = cache.Metadata()
```

## Example 2 — Long path, use module alias (good)

```py
import pulsar.api.spatial.cache.metadata as cache_metadata
meta = cache_metadata.Metadata()
```

## Example 3 — Specific symbol is okay

```py
from pulsar.api.index.morton.payload import BootstrapPayload
payload = BootstrapPayload(...)
```
