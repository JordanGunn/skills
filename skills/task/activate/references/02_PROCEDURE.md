# Procedure

## Steps

### 1. Load Task

Read `00_TASK.md` frontmatter from the task directory.

### 2. Check Current Lifecycle State

If `lifecycle_state` is already `active`:

- Output: "Task is already active"
- Exit with success (idempotent)

If `lifecycle_state` is `completed` or `abandoned`:

- Output: "Cannot activate a {state} task"
- Exit with error

### 3. Compute Derived Status

```bash
python .resources/scripts/task_status.py --task {task_path} --json
```

### 4. Check Trust Gates

Parse the derived status and verify:

- `epistemic_state == validated`
- `is_stale == false`
- `hash_mismatch == false`

If any gate fails, collect all refusal reasons.

### 5. Handle Refusal

If any trust gate failed:

- Output all refusal reasons
- Suggest remediation (e.g., "Run task-validate to revalidate")
- Exit with error (do not change state)

### 6. Activate

Update `lifecycle_state` to `active` in frontmatter.

### 7. Update Derived State

```bash
python .resources/scripts/task_status.py --task {task_path}
```

### 8. Confirm

Output activation confirmation:

```text
Activated task: {id}
  Lifecycle: active
  Epistemic: validated
```
