# Procedure

## Steps

### 1. Load Task

Read `00_TASK.md` frontmatter from the task directory.

### 2. Verify Invalidation Info

Ensure both `invalidated_by` and `invalidated_reason` are provided and non-empty.

### 3. Check Current State

If already `invalidated`:

- Update reason if different
- Output: "Task already invalidated, updating reason"

### 4. Update Frontmatter

Update the following fields in `00_TASK.md`:

- `epistemic_state`: `invalidated`
- `invalidated_by`: provided value
- `invalidated_reason`: provided value
- `superseded_by`: provided value (if given)

If `lifecycle_state` was `active`:

- Set `lifecycle_state`: `inactive`

### 5. Update Derived State

```bash
python .resources/scripts/task_status.py --task {task_path}
```

### 6. Confirm

Output invalidation confirmation:

```text
Invalidated task: {id}
  Reason: {reason}
  By: {who}
  Superseded by: {superseded_by or "None"}
```
