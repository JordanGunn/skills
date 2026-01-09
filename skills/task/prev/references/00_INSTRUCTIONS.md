# Instructions

## Usage

Navigate to the previous task using the `task_nav.py` script:

```bash
python .resources/scripts/task_nav.py --root tasks/ --prev <task-id>
```

## Behavior

- Tasks are ordered by `created_at` descending (newest first)
- "Previous" means the next newer task in the list
- Returns empty if at the first (newest) task

## Output Formats

- Default: Task ID only
- `--path`: Full path to task directory
- `--json`: JSON object with id, path, created_at

## Examples

```bash
# Get task before fix-login-bug
python .resources/scripts/task_nav.py --root tasks/ --prev fix-login-bug
# Output: implement-auth

# Get path instead of ID
python .resources/scripts/task_nav.py --root tasks/ --prev fix-login-bug --path
# Output: tasks/implement-auth

# Get last (oldest) task
python .resources/scripts/task_nav.py --root tasks/ --last
```
