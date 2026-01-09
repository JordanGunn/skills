# Procedure

## Steps

### 1. Load Task

Read `00_TASK.md` frontmatter from the task directory.

### 2. Generate Timestamp

```bash
python .resources/scripts/time.py
```

### 3. Update last_reviewed_at

Update the `last_reviewed_at` field in frontmatter.

### 4. Recompute Hash

```bash
python .resources/scripts/task_hash.py --task {task_path} --check
```

Note any mismatch but do not update the stored hash.

### 5. Compute Derived Status

```bash
python .resources/scripts/task_status.py --task {task_path}
```

### 6. Report Findings

Output review summary including:

- Current epistemic and lifecycle state
- Staleness status
- Hash mismatch status
- Any refusal reasons that would block activation
