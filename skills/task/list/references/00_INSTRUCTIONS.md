# Instructions

## Usage

List tasks using the `task_list.py` script:

```bash
python .resources/scripts/task_list.py --root tasks/
```

## Available Filters

- `--stale`: Show only stale tasks
- `--validated`: Show only validated tasks
- `--invalidated`: Show only invalidated tasks
- `--active`: Show only active tasks
- `--inactive`: Show only inactive tasks
- `--blocked`: Show only blocked tasks
- `--completed`: Show only completed tasks
- `--kind <kind>`: Filter by kind (feature, bugfix, etc.)

## Sorting

- `--sort <field>`: Sort by field (default: created_at)
- `--asc`: Ascending order
- Default is descending (newest first)

## Output Formats

- Default: Human-readable table
- `--json`: JSON array
- `--count`: Just the count

## Examples

```bash
# All tasks, newest first
python .resources/scripts/task_list.py --root tasks/

# Stale tasks needing attention
python .resources/scripts/task_list.py --root tasks/ --stale

# Validated but not yet active
python .resources/scripts/task_list.py --root tasks/ --validated --inactive

# Active feature tasks
python .resources/scripts/task_list.py --root tasks/ --active --kind feature
```
