# Task Skillset

A skillset for standardized task creation and lifecycle control.

## What is a Task?

A **task** is a bounded unit of intent represented as a directory. Tasks are designed to be:

- **Created** easily (low friction to capture intent)
- **Validated** explicitly (existence ≠ trust)
- **Questioned** continuously (staleness detection, hash verification)
- **Invalidated** gracefully (tasks are designed to die when wrong)

## Why Tasks are Directories

Tasks use the **task-as-directory** model for several reasons:

1. **Progressive Disclosure**: Core intent in `00_TASK.md`, optional context/notes in separate files
2. **Chunking**: Large tasks can be broken into sub-files without polluting the canonical intent
3. **Derived State**: Scripts can write computed state to `99_STATE.md` without modifying source intent
4. **Version Control**: Directory structure works well with git

## Task Directory Structure

```text
task-id/
├── 00_TASK.md       # Required: Canonical frontmatter + intent
├── 01_CONTEXT.md    # Optional: Background, research, related work
├── 02_NOTES.md      # Optional: Working notes, discoveries
├── 03_ACTIONS.md    # Optional: Append-only execution log
└── 99_STATE.md      # Optional: Derived state (computed by scripts)
```

Only `00_TASK.md` is required. Other files are created as needed.

## Core Concepts

### Epistemic State

Tasks have an `epistemic_state` that reflects their validation status:

| State | Meaning |
| ----- | ------- |
| `candidate` | Newly created, not yet reviewed |
| `draft` | Work in progress, not ready for validation |
| `validated` | Explicitly validated, trusted for activation |
| `invalidated` | Marked as no longer valid |

### Lifecycle State

Tasks have a `lifecycle_state` that reflects their execution status:

| State | Meaning |
| ----- | ------- |
| `inactive` | Not currently being worked on |
| `active` | Currently being executed |
| `blocked` | Waiting on dependencies or external factors |
| `completed` | Successfully finished |
| `abandoned` | Stopped without completion |

### Trust Gates

A task may only influence execution if it passes all trust gates:

1. **Epistemic Gate**: Must be `validated`
2. **Temporal Gate**: Must not be stale (based on `staleness_days_threshold`)
3. **Integrity Gate**: Intent hash must match (no unvalidated changes)

These gates are **deterministic** - computed by scripts, not judged by agents.

### Intent Hashing

Each task has an `intent_hash` computed from its canonical intent surface:

- Frontmatter fields (id, title, kind, scope, risk, etc.)
- Canonical body sections (Goal, Acceptance, Constraints, Dependencies)

The hash provides **meaning integrity**. If the canonical intent changes, the hash changes, signaling that revalidation is needed.

### Chronological Awareness

Tasks track time to prevent rot:

- `created_at`: When the task was created
- `last_reviewed_at`: When the task was last reviewed/validated
- `expires_at`: Optional hard expiry date
- `staleness_days_threshold`: Days before task is considered stale (default: 14)

Staleness is computed deterministically from these timestamps.

## Design Philosophy

### Existence ≠ Trust

Creating a task does not grant it influence. Tasks must be explicitly validated before activation.

### Tasks are Designed to Die

Invalidation is not failure - it's the correct response when intent becomes wrong. Tasks should be cheap to create and easy to discard.

### Deterministic Boundaries

Scripts compute objective truth (time, hashing, derived state). Agents perform qualitative judgment (goal clarity, invalidation reasoning, done-ness).

### Simple, Dependable, Boring

The implementation uses common tools and deterministic scripts. No clever prioritization. Chronological ordering only.

## Available Skills

| Skill | Purpose |
| ----- | ------- |
| `task-create` | Create a new task |
| `task-validate` | Validate a task (requires who/why) |
| `task-review` | Review without changing epistemic state |
| `task-activate` | Activate a validated task |
| `task-invalidate` | Invalidate a task (requires reason) |
| `task-status` | Display derived status |
| `task-list` | List tasks with filters |
| `task-next` | Navigate to next task |
| `task-prev` | Navigate to previous task |

## See Also

- [USAGE.md](./USAGE.md) - Quickstart and examples
- [task.frontmatter.schema.json](../assets/schemas/task.frontmatter.schema.json) - Frontmatter schema
- [task.schema.json](../assets/schemas/task.schema.json) - Directory structure schema
