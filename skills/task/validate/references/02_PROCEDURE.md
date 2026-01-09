# Procedure

## Steps

### 1. Load Task

Read `00_TASK.md` frontmatter from the task directory.

### 2. Check Current State

If `epistemic_state` is `invalidated`:

- Require `--force` flag
- Warn user that they are re-validating an invalidated task

### 3. Verify Validation Info

Ensure both `validated_by` and `validated_reason` are provided and non-empty.

### 4. Compute Hash

Run hash computation:

```bash
python .resources/scripts/task_hash.py --task {task_path}
```

### 5. Generate Timestamp

```bash
python .resources/scripts/time.py
```

### 6. Update Frontmatter

Update the following fields in `00_TASK.md`:

- `epistemic_state`: `validated`
- `validated_by`: provided value
- `validated_reason`: provided value
- `last_reviewed_at`: generated timestamp
- `intent_hash`: recomputed hash

### 7. Update Derived State

Run status computation:

```bash
python .resources/scripts/task_status.py --task {task_path}
```

### 8. Confirm

Output validation confirmation with hash and timestamp.
