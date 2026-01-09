# Working Definition

**Module stutter**: A public class/function name contains the module's basename (or its CamelCase/snake_case equivalent) as a **prefix, infix, or suffix**.

The module path already carries semantic context. Repeating it in the symbol is noise.

## Stutter Patterns

### Prefix stutter (symbol starts with module name)

- `las.py` → `File`, `LasReader` → prefer `File`, `Reader`
- `work_unit.py` → `WorkUnitSpec` → prefer `Spec`

### Infix stutter (module name embedded in symbol)

- `fragment.py` → `write_from_batch` → prefer `write_from_batch`
- `fragment.py` → `ProcessFragmentData` → prefer `ProcessData`

### Suffix stutter (symbol ends with module name)

- `batch.py` → `WriteBatch` → prefer `Write` or restructure
- `fragment.py` → `create_fragment` → prefer `create`

## Module Name Normalization

- `las.py` → prefix `Las`, snake `las`
- `work_unit.py` → prefix `WorkUnit`, snake `work_unit`
- `geo-tiff.py` → prefix `GeoTiff`, snake `geo_tiff`
