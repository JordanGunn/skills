# Procedure

## Steps

### 1. Validate Inputs

Verify all required fields are provided:
- `id` must be valid (lowercase, hyphens, no leading/trailing hyphens)
- `title` must be non-empty
- `kind`, `scope`, `risk`, `origin` must be valid enum values

### 2. Check for Conflicts

Ensure no existing task directory with the same `id` exists under the root.

### 3. Generate Timestamps

Use `time.py` to generate `created_at` in RFC3339 UTC format:

```bash
python .resources/scripts/time.py
```

### 4. Create Directory

Create the task directory at `{root}/{id}/`.

### 5. Populate Template

Copy the template from `.resources/assets/schemas/task.00_TASK.template.md` and replace placeholders:

| Placeholder | Value |
|-------------|-------|
| `{{ID}}` | Task ID |
| `{{TITLE}}` | Task title |
| `{{KIND}}` | Task kind |
| `{{SCOPE}}` | Task scope |
| `{{RISK}}` | Task risk |
| `{{ORIGIN}}` | Task origin |
| `{{CREATED_AT}}` | Generated timestamp |
| `{{GOAL}}` | Goal statement (or placeholder text) |
| `{{ACCEPTANCE_CRITERION_1}}` | First acceptance criterion |
| `{{ACCEPTANCE_CRITERION_2}}` | Second acceptance criterion |
| `{{CONSTRAINT_1}}` | First constraint |

### 6. Compute Intent Hash

Run `task_hash.py` to compute and store the initial intent hash:

```bash
python .resources/scripts/task_hash.py --task {root}/{id} --update
```

### 7. Verify Creation

Confirm:
- Directory exists
- `00_TASK.md` exists with valid frontmatter
- `intent_hash` is populated (not placeholder)
- `epistemic_state` is `candidate`
- `lifecycle_state` is `inactive`
