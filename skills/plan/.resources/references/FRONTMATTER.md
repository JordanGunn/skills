# Frontmatter Taxonomy

Slim, deliberate metadata for machine-readable plan status.

## Task Files (`<letter>/<roman>.md`)

```yaml
---
status: pending | in_progress | complete
---
```

| Value | Meaning | Set by |
|-------|---------|--------|
| `pending` | Not started | `plan-create` |
| `in_progress` | Currently being executed | `plan-exec` |
| `complete` | Output and Handoff populated | `plan-exec` |

## Sub-plan Index (`<letter>/index.md`)

```yaml
---
status: pending | in_progress | complete
---
```

| Value | Meaning | Set by |
|-------|---------|--------|
| `pending` | No tasks started | `plan-create` |
| `in_progress` | At least one task started | `plan-exec` |
| `complete` | All tasks complete | `plan-exec` |

## Root Plan (`plan.md`)

```yaml
---
status: pending | in_progress | complete
---
```

| Value | Meaning | Set by |
|-------|---------|--------|
| `pending` | Plan created, no execution started | `plan-create` |
| `in_progress` | At least one sub-plan started | `plan-exec` |
| `complete` | All sub-plans complete, wrap-up done | `plan-exec` |

## Rules

1. **Immutable once complete**: Never change a `complete` status back.
2. **Cascading updates**: When a task becomes `in_progress`, its parent sub-plan becomes `in_progress`. When all tasks in a sub-plan are `complete`, the sub-plan becomes `complete`.
3. **Single in_progress task**: Only one task should be `in_progress` at a time.
