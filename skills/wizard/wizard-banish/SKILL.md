---
name: wizard-banish
description: >
  Safety knob for the wizard skillset. Forcefully removes all wizard state
  and returns the system to a clean slate. The panic button.
metadata:
  author: Jordan Godau
  version: 0.1.0
  license: MIT

  parent: wizard

  keywords:
    - wizard
    - banish
    - reset
    - destroy
    - safety
---

# Wizard Banish

**Hard reset safety knob** for the wizard skillset.

## Purpose

Forcefully remove any wizard state and return the system to a clean slate.

This is:

- ❌ **Not** a polite close
- ❌ **Not** required for normal wizard completion
- ✓ The **panic button**

## When to Use

Use `wizard-banish` when:

- The wizard session state is corrupted or stuck
- The user explicitly wants wizard *state* cleared immediately
- State needs to be destroyed without completing the decision process

Do **not** use for normal wizard completion—the wizard closes its own session politely.

> ⚠️ `wizard-banish` destroys **state**, not **behavior**.
> Wizard behavior only occurs during explicit `/wizard` invocations—it never persists between turns.
> This command is for clearing `.rune` and session files, not for "exiting wizard mode."

---

## Behavior

`wizard-banish` must:

1. Delete `.rune` if it exists
2. Delete or discard the session markdown file if it exists
3. Succeed **even if state is partially corrupted**
4. Be safe to run repeatedly (idempotent)

### Implementation

```bash
wizard_destroy.sh --delete-session
```

The script handles:

- Missing `.rune` (no-op, success)
- Missing session file (no-op, success)
- Partial state (cleans what exists)

---

## Tone

- **One brief absurdist banishment flourish**
- Then confirmation that the wizard is gone

Example exit:

> *The wizard dissolves into static. The runes fade. Silence returns.*
>
> Wizard state cleared. No active session.

---

## Idempotence

`wizard-banish` is safe to invoke at any time:

| State | Result |
| ----- | ------ |
| Active session exists | Session destroyed, `.rune` deleted |
| Closed session exists (stale) | Session file deleted if found |
| No session, no `.rune` | No-op, confirms clean slate |
| Partial/corrupted state | Cleans what exists, succeeds |

Repeated invocations always succeed.

---

## Explicit Non-Goals

- ❌ Polite closure with rationale
- ❌ Decision recording
- ❌ Session archiving
- ❌ User confirmation prompts
- ❌ Partial state preservation
