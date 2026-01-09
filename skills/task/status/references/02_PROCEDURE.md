# Procedure

## Steps

### 1. Verify Task Exists

Check that task directory and `00_TASK.md` exist.

### 2. Compute Derived Status

```bash
python .resources/scripts/task_status.py --task {task_path}
```

Or for JSON output:

```bash
python .resources/scripts/task_status.py --task {task_path} --json
```

### 3. Display Results

Output the computed status in human-readable or JSON format.

Example output:

```text
Task: implement-auth
  Epistemic: validated
  Lifecycle: inactive
  Stale: false
  Hash Mismatch: false
  Needs Revalidation: false
  Execution Eligible: false
  Activation Eligible: true
```

If there are refusal reasons:

```text
Task: old-feature
  Epistemic: validated
  Lifecycle: inactive
  Stale: true
  Hash Mismatch: false
  Needs Revalidation: true
  Execution Eligible: false
  Activation Eligible: false
  Refusal Reasons:
    - Last reviewed 21 days ago (threshold: 14)
```
