# Instructions

## Usage

Navigate to the next task using the `task_nav.py` script:

```bash
python .resources/scripts/task_nav.py --root tasks/ --next <task-id>
```

## Behavior

- Tasks are ordered by `created_at` descending (newest first)
- "Next" means the next older task in the list
- Returns empty if at the last (oldest) task

## Output Formats

- Default: Task ID only
- `--path`: Full path to task directory
- `--json`: JSON object with id, path, created_at

## Examples

```bash
# Get task after implement-auth
python .resources/scripts/task_nav.py --root tasks/ --next implement-auth
# Output: fix-login-bug

# Get path instead of ID
python .resources/scripts/task_nav.py --root tasks/ --next implement-auth --path
# Output: tasks/fix-login-bug

# Get first (newest) task
python .resources/scripts/task_nav.py --root tasks/ --first
```
