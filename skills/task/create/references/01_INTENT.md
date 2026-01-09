# Intent

## Purpose

Create a new task as a bounded unit of intent that can be tracked, validated, and executed.

## Philosophy

Tasks are **designed to be questioned**. A newly created task is a `candidate` - an expression of intent that has not yet been validated. This is intentional:

- **Existence ≠ Trust**: Creating a task does not grant it influence over execution.
- **Validation is Explicit**: Tasks must be explicitly validated before activation.
- **Intent Integrity**: The initial hash captures the canonical intent at creation time.

## Inputs

Required:
- `id`: Unique identifier (lowercase, hyphens allowed)
- `title`: Human-readable title
- `kind`: Task category (feature, bugfix, refactor, research, documentation, maintenance, exploration, spike)
- `scope`: Size estimation (trivial, minor, moderate, major, epic)
- `risk`: Risk level (none, low, medium, high, critical)
- `origin`: Source of task (human, agent, mixed)

Optional:
- `goal`: Goal statement for the task
- `acceptance`: Acceptance criteria
- `constraints`: Boundaries and limitations
- `dependencies`: Task IDs this depends on
- `expires_at`: Optional expiry timestamp
- `staleness_days_threshold`: Override default staleness threshold

## Outputs

- Task directory at `{root}/{id}/`
- `00_TASK.md` with populated frontmatter and template sections
- Initial `intent_hash` computed and stored
