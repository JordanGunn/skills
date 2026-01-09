# Canonical Prompt Artifact Schema

The canonical prompt artifact is stored at `.codex/skills/prompt/.prompt/active.yaml`.

## Schema Definition

```yaml
# Status of the prompt artifact
# - drafting: Intent is being refined, not ready for execution
# - ready: Intent is stabilized and confirmed, ready for execution
status: drafting | ready

# ISO 8601 timestamp of last update
updated_at: "2024-01-09T12:00:00Z"

# Short human-readable title (max 100 chars)
title: "Refactor authentication module"

# One-to-three line summary of stabilized human intent
intent_summary: |
  Restructure the authentication module to separate concerns between
  token validation, session management, and user lookup.

# The exact prompt text to be executed verbatim
# This is what prompt-exec will use - no modifications allowed
refined_prompt: |
  Refactor pulsar/api/auth/ to:
  1. Extract token validation into tokens.py
  2. Move session logic into sessions.py
  3. Keep user lookup in users.py
  4. Update all imports throughout the codebase
  5. Ensure all tests pass

# Explicit assumptions the agent is making
# These should be confirmed during forging
assumptions:
  - "The existing tests provide adequate coverage"
  - "No external services depend on the current module structure"

# Unresolved ambiguities
# Must be empty or explicitly deferred before status can be 'ready'
open_questions:
  - "Should we also update the CLI entry points?"

# Hard requirements and prohibitions
constraints:
  must:
    - "Preserve all existing functionality"
    - "Maintain backward compatibility for public APIs"
  must_not:
    - "Delete any test files"
    - "Modify the database schema"
```

## Field Requirements

| Field | Required | Notes |
|-------|----------|-------|
| `status` | Yes | Must be `drafting` or `ready` |
| `updated_at` | Yes | ISO 8601 format |
| `title` | Yes | Short, descriptive |
| `intent_summary` | Yes | 1-3 lines |
| `refined_prompt` | Yes | Verbatim execution text |
| `assumptions` | Yes | May be empty list |
| `open_questions` | Yes | Must be empty for `ready` status |
| `constraints.must` | Yes | May be empty list |
| `constraints.must_not` | Yes | May be empty list |

## Invariants

1. **Single file**: Only one `active.yaml` may exist at a time
2. **No branching**: All refinement is in-place
3. **Deletion on success**: File is deleted after successful execution
4. **Status gate**: `status: ready` requires empty `open_questions`
