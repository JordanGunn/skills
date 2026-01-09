# Task Skillset Usage

Quickstart guide and examples for the task skillset.

## Quickstart

### 1. Create a Task

```bash
# Using the skill (agent-assisted)
task-create --id implement-auth --title "Implement authentication" \
  --kind feature --scope moderate --risk medium --origin human

# Result: tasks/implement-auth/00_TASK.md created
```

### 2. Edit the Task

Open `tasks/implement-auth/00_TASK.md` and fill in:

- Goal section
- Acceptance criteria
- Constraints
- Dependencies

### 3. Validate the Task

```bash
task-validate --task tasks/implement-auth \
  --validated-by "Jordan" \
  --validated-reason "Requirements confirmed with stakeholder"
```

### 4. Activate the Task

```bash
task-activate --task tasks/implement-auth
```

### 5. Check Status

```bash
task-status --task tasks/implement-auth
```

## Example Task Directory

```text
tasks/implement-auth/
├── 00_TASK.md
├── 01_CONTEXT.md    # (optional)
└── 99_STATE.md      # (auto-generated)
```

## Example 00_TASK.md

```yaml
---
id: implement-auth
title: "Implement authentication system"
kind: feature
scope: moderate
risk: medium
epistemic_state: validated
confidence: high
origin: human
lifecycle_state: active
created_at: "2026-01-09T10:30:00Z"
last_reviewed_at: "2026-01-09T14:00:00Z"
staleness_days_threshold: 14
intent_hash: "a1b2c3d4e5f6..."
intent_hash_algo: sha256-v1
intent_hash_scope: canonical-intent
validated_by: "Jordan"
validated_reason: "Requirements confirmed with stakeholder"
---

# Implement authentication system

## Goal

Implement JWT-based authentication with refresh token support.
Users should be able to log in, receive tokens, and access protected routes.

## Acceptance

- [ ] User can log in with email/password
- [ ] JWT access token issued on successful login
- [ ] Refresh token rotation implemented
- [ ] Protected routes validate tokens
- [ ] Token expiry handled gracefully

## Constraints

- Must use existing user database schema
- No third-party auth providers (internal only)
- Tokens must expire within 1 hour

## Dependencies

- database-schema-v2 (completed)

## Evidence

- (To be filled upon completion)
```

## Script Examples

### Time Scripts

```bash
# Get current UTC time
python .resources/scripts/time.py
# Output: 2026-01-09T17:23:10Z

# Compute future time
python .resources/scripts/timedelta.py --now --days 14
# Output: 2026-01-23T17:23:10Z
```

### Hash Scripts

```bash
# Compute hash without updating
python .resources/scripts/task_hash.py --task tasks/implement-auth
# Output: a1b2c3d4e5f6...

# Check if hash matches
python .resources/scripts/task_hash.py --task tasks/implement-auth --check
# Output: MATCH: a1b2c3d4... or MISMATCH: stored=... computed=...

# Update hash in frontmatter
python .resources/scripts/task_hash.py --task tasks/implement-auth --update
```

### Status Scripts

```bash
# Get status summary
python .resources/scripts/task_status.py --task tasks/implement-auth

# Get status as JSON
python .resources/scripts/task_status.py --task tasks/implement-auth --json
```

### List Scripts

```bash
# List all tasks
python .resources/scripts/task_list.py --root tasks/

# List stale tasks only
python .resources/scripts/task_list.py --root tasks/ --stale

# List validated active tasks
python .resources/scripts/task_list.py --root tasks/ --validated --active

# Output as JSON
python .resources/scripts/task_list.py --root tasks/ --json
```

### Navigation Scripts

```bash
# Get next task after implement-auth
python .resources/scripts/task_nav.py --root tasks/ --next implement-auth

# Get previous task
python .resources/scripts/task_nav.py --root tasks/ --prev implement-auth

# Get first (newest) task
python .resources/scripts/task_nav.py --root tasks/ --first

# Get last (oldest) task
python .resources/scripts/task_nav.py --root tasks/ --last
```

## Example task-list Output

```text
ID                   EPIST  LIFE     CREATED      STATUS   TITLE
--------------------------------------------------------------------------------
implement-auth       vali   active   2026-01-09            Implement authentication system
fix-login-bug        vali   inactive 2026-01-08            Fix login redirect bug
add-user-profile     cand   inactive 2026-01-07   [STALE]  Add user profile page
research-caching     draft  inactive 2026-01-05   [STALE]  Research caching strategies

Total: 4 task(s)
```

## Example task-status Output

```text
Task: implement-auth
  Epistemic: validated
  Lifecycle: active
  Stale: false
  Hash Mismatch: false
  Needs Revalidation: false
  Execution Eligible: true
```

With refusal reasons:

```text
Task: add-user-profile
  Epistemic: candidate
  Lifecycle: inactive
  Stale: true
  Hash Mismatch: false
  Needs Revalidation: true
  Execution Eligible: false
  Activation Eligible: false
  Refusal Reasons:
    - Task not validated (state: candidate)
    - Last reviewed 16 days ago (threshold: 14)
```

## Common Workflows

### Daily Review

```bash
# List stale tasks that need attention
python .resources/scripts/task_list.py --root tasks/ --stale

# Review each stale task
task-review --task tasks/{task-id}

# Decide: revalidate or invalidate
task-validate --task tasks/{task-id} --validated-by "You" --validated-reason "Still relevant"
# OR
task-invalidate --task tasks/{task-id} --invalidated-by "You" --invalidated-reason "No longer needed"
```

### Task Lifecycle

```text
[create] → candidate/inactive
    ↓
[validate] → validated/inactive
    ↓
[activate] → validated/active
    ↓
[complete] → validated/completed
```

### Handling Intent Changes

If you modify the Goal, Acceptance, Constraints, or Dependencies sections:

1. The hash will mismatch on next status check
2. Task will show `needs_revalidation: true`
3. Activation will be refused until revalidated
4. Run `task-validate` with reason explaining the change
