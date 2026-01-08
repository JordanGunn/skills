# Procedure

Step-by-step audit process for namespace integrity.

## Phase 1: Scope Selection

### 1.1 Determine Target

If user specifies a path, use it. Otherwise:

```bash
# Default: scan primary source package
TARGET="pulsar/api"
```

### 1.2 Validate Target Exists

```bash
if [ ! -d "$TARGET" ]; then
    echo "Error: Target directory does not exist: $TARGET"
    exit 1
fi
```

---

## Phase 2: Structural Scan

Run detection scripts to identify candidates.

### 2.1 Utility Dump Scan

```bash
# Find catch-all package names
find "$TARGET" -type d \( \
    -name "common" -o \
    -name "utils" -o \
    -name "helpers" -o \
    -name "core" -o \
    -name "shared" -o \
    -name "misc" \
\) -print
```

### 2.2 Stuttery Sibling Scan

```bash
# Find modules with underscore prefixes matching sibling directories
for dir in $(find "$TARGET" -type d); do
    for file in "$dir"/*.py; do
        [ -f "$file" ] || continue
        base=$(basename "$file" .py)
        prefix=$(echo "$base" | cut -d'_' -f1)
        if [ -d "$dir/$prefix" ]; then
            echo "Stuttery sibling: $file (sibling: $dir/$prefix/)"
        fi
    done
done
```

### 2.3 Thin Wrapper Scan

```bash
# Find single-export modules
for file in $(find "$TARGET" -name "*.py" -type f); do
    exports=$(grep -E "^__all__\s*=" "$file" 2>/dev/null | grep -oE '\["[^"]+"\]' | tr -cd ',' | wc -c)
    if [ "$exports" -eq 0 ]; then
        # Check if file has only one public function
        public_funcs=$(grep -cE "^def [a-z]" "$file" 2>/dev/null || echo 0)
        if [ "$public_funcs" -eq 1 ]; then
            echo "Thin wrapper candidate: $file"
        fi
    fi
done
```

### 2.4 Axis Violation Scan

Manual inspection required. For each directory:

1. List immediate children (files and directories)
2. Classify each by organizational type
3. Flag directories with mixed types

### 2.5 Semantic Diffusion Scan

```bash
# Find duplicate module names across packages
find "$TARGET" -name "*.py" -exec basename {} \; | sort | uniq -d
```

### 2.6 Layer Bleeding Scan

```bash
# Search for upward imports (requires import graph analysis)
# Example: driver importing from processor
grep -r "from pulsar.api.processor" "$TARGET/io" 2>/dev/null
grep -r "from pulsar.api.engine" "$TARGET/io" 2>/dev/null
```

---

## Phase 3: Analysis

For each candidate identified in Phase 2:

### 3.1 Read the Module

Inspect contents to understand:

- What responsibilities does it have?
- What does it depend on?
- Who depends on it?

### 3.2 Classify the Violation

Assign one of:

- Utility dump
- Stuttery sibling
- Thin wrapper orphan
- Axis violation
- Semantic diffusion
- Layer bleeding

### 3.3 Identify Homeless Concept

Ask:

- What concept is present but unnamed?
- What responsibility is this code actually serving?
- Which part of the system would miss this code if it disappeared?

### 3.4 Assess Severity

Apply severity heuristics from `SEVERITY_LEVELS.md`:

- **Blocker**: Public API violation, import cycle risk
- **Strongly Recommended**: Internal structure degradation
- **Suggestion**: Minor improvement opportunity

---

## Phase 4: Remediation Hypotheses

For each finding, propose **multiple** plausible directions:

### 4.1 Standard Remediation Patterns

| Violation | Remediation Options |
|-----------|---------------------|
| Utility dump | Collapse into caller, extract domain package, promote to protocol |
| Stuttery sibling | Move into sibling package, rename to express domain |
| Thin wrapper | Delete and inline, move to owning layer, extract policy |
| Axis violation | Move to appropriate layer, create new organizational level |
| Semantic diffusion | Consolidate to single location, make split explicit |
| Layer bleeding | Invert dependency, introduce interface |

### 4.2 Risk Assessment

For each option, note:

- Migration complexity (files affected)
- Breaking change risk (public API impact)
- Intermediate steps (if large refactor)

---

## Phase 5: Report Generation

Produce Markdown report following `07_OUTPUT.md` format:

1. Summary
2. Findings by severity
3. Remediation hypotheses
4. Open questions
