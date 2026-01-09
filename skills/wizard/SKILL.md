---
name: wizard
description: >
  Orchestrator skill for the `wizard` skillset. A deterministic, idempotent
  decision portal for skill creation. Decides whether a single skill, multiple
  skills, no skill, or an alternative solution should exist. Refusal is a valid
  and successful outcome.
metadata:
  author: Jordan Godau
  version: 0.1.0
  license: MIT

  skillset:
    name: wizard
    schema_version: 1
    skills:
      - wizard
      - wizard-banish

    resources:
      root: .resources
      scripts:
        - wizard_status.sh
        - wizard_init.sh
        - wizard_close.sh
        - wizard_destroy.sh
      templates:
        - SESSION_TEMPLATE.md
      references: []

    pipelines:
      default:
        - wizard
      allowed:
        - [wizard]
        - [wizard-banish]
        - [wizard, wizard-banish]

    requires: []

  keywords:
    - wizard
    - skill-creation
    - decision
    - session
    - refusal
    - banish
---

# Wizard Skillset

A **deterministic, idempotent decision portal** for skill creation.

## Purpose (Narrow and Explicit)

The wizard exists to answer **one question**:

> Should a skill exist, and if so, what kind?

Valid outcomes:

| Decision | Meaning |
|----------|---------|
| `single-skill` | One skill should be created |
| `multi-skill` | Multiple skills (skillset) should be created |
| `reject-skill` | No skill should exist; alternative artifact preferred |
| `other-solution` | Something else entirely is appropriate |

**Refusal is success.** Not every problem needs a skill.

---

## Member Skills

| Skill | Purpose |
| ----- | ------- |
| `wizard` | Orchestrator — idempotent portal that resumes or initializes, runs the interview loop, and closes politely on completion |
| `wizard-banish` | Safety knob — forceful hard reset that exorcises all wizard state |

The orchestrator (`wizard`) is the **canonical route**. Normal wizard usage never requires `wizard-banish`.

---

## Behavioral Invariants (Non-Negotiable)

> **Wizard behavior is activated only on turns that explicitly invoke `/wizard`.**
>
> Wizard *state* may persist via `.rune`, but wizard *behavior* must never persist across turns implicitly.

### Per-Invocation Semantics

| Concept | Scope | Persists? |
| ------- | ----- | --------- |
| Wizard **behavior** | Single `/wizard` invocation | ❌ No |
| Wizard **state** | Session (until closed or banished) | ✅ Yes |
| Wizard **cleanup** | Automatic on natural completion | ✅ Yes |
| Hard reset | `wizard-banish` (state only) | ✅ Yes |

### Rules

1. **`/wizard` is a per-call portal** — Each invocation is behaviorally independent.
2. **State may be resumed, but only when `/wizard` is explicitly invoked** — The agent does not "remain in wizard mode."
3. **Normal chat must ignore wizard state entirely** — If the user sends a message without `/wizard`, the agent responds normally. The existence of `.rune` has no effect on non-wizard turns.
4. **No "poof", "exit", or teardown required** — Wizard behavior stops automatically when the turn ends. `wizard-banish` destroys *state*, not *behavior*.

### What This Means

- A wizard session can exist without affecting normal chat.
- Wizard behavior **never** occurs without explicit `/wizard` invocation.
- Multiple `/wizard` calls safely resume the same session.
- `wizard-banish` is for **state destruction only**, not behavior control.

---

## Session Model

### Two-File Architecture

#### 1. Environment Pointer (`.rune`)

- **Location:** User cache directory (e.g., `$XDG_STATE_HOME/lask/` or `~/.local/state/lask/`)
- **Purpose:** Points to active session
- **Format:**

```ini
SESSION_ID=<uuid>
SESSION_PATH=<absolute-path-to-session-md>
```

> ⚠️ `.rune` lives **outside the repo**. Session state is ephemeral, not versioned.

#### 2. Session Log (Markdown)

- **Location:** Resolved from `SESSION_PATH` in `.rune`
- **Purpose:** Working state for one wizard invocation
- **Lifecycle:** Created on init, deleted or archived on close

### Session Frontmatter Schema

```yaml
---
wizard_version: "0.1.0"
session_id: "<uuid>"
status: active              # active | closed
artifact_target: unknown    # skill | skillset | other
decision: undecided         # undecided | single-skill | multi-skill | reject-skill | other-solution
export_on_close: false
---
```

No additional frontmatter fields. This schema is frozen.

---

## Lifecycle

### On Every `/wizard` Invocation

```text
┌─────────────────────────────────────────────────────────────┐
│  1. Check for .rune                                         │
│     ├─ Present?                                             │
│     │   ├─ Load SESSION_PATH                                │
│     │   ├─ If status: active → RESUME (no re-init)          │
│     │   └─ If status: closed → treat as no session          │
│     └─ Absent? → INITIALIZE                                 │
└─────────────────────────────────────────────────────────────┘
```

### Initialization (Once Per Session)

Performed by `wizard_init.sh`:

1. Mint new `SESSION_ID`
2. Create `.rune` with pointer
3. Create session markdown from `SESSION_TEMPLATE.md`

Agent behavior on fresh session:

- **One brief absurdist wizard entry flourish** (never repeated on resume)
- Then proceed to reasoning

### Resume Behavior

On resume:

- **No re-introduction**
- **No "you are in a wizard" explanation**
- Read session state, continue from where left off

### Natural Completion (Polite Automatic Disappearance)

When the wizard concludes naturally—i.e., converges on a decision—it closes itself. No external command required.

Agent must verify closure conditions:

1. `decision` is set to a terminal value
2. Rationale exists (2–5 bullets)
3. Next action is concrete
4. Unknowns acknowledged or dismissed

On natural completion:

- Write final decision, rationale, and next actions to session file
- Update frontmatter: `status: closed`, `decision: <final>`
- Run `wizard_close.sh` to delete `.rune`
- **One brief absurdist wizard exit flourish**

The wizard **disappears politely on its own**. `wizard-banish` is **not** required for normal completion.

---

## Scripts (Lifecycle Ownership)

| Script | Purpose |
|--------|---------|
| `wizard_status.sh` | Check if active session exists, print status |
| `wizard_init.sh` | Create `.rune` and session file |
| `wizard_close.sh` | Finalize session, delete `.rune` |
| `wizard_destroy.sh` | Abort session without closure, delete `.rune` |

**Scripts own lifecycle. The agent must not simulate these steps in text.**

---

## Agent Reasoning Rules

During an active session, the agent must:

### 1. Maintain a Working Model

In the session markdown body, track:

- **Locked goal** — What the user is trying to achieve
- **Observations** — Evidence gathered
- **Rejected interpretations** — With explicit reason
- **Open questions** — What remains unclear
- **Emerging constraints** — Non-negotiables surfaced

### 2. Minimize Questions

Ask only questions that **move toward convergence**. Avoid:

- Exploratory tangents
- Repeated clarifications
- Questions answerable from context

### 3. Detect Premature Crystallization

If the user rushes to "just make a skill":

- Push back explicitly
- Name the uncertainty
- Refuse to proceed until grounded

### 4. Never Assume a Skill Must Exist

The wizard's job is to **discover** whether a skill is appropriate, not to manufacture one.

---

## Closure Checklist

Before calling `wizard_close.sh`, the agent must confirm:

| Condition | Required |
|-----------|----------|
| `decision` is terminal (`single-skill`, `multi-skill`, `reject-skill`, `other-solution`) | ✓ |
| Rationale: 2–5 bullet summary | ✓ |
| Next action is concrete (skeleton, split plan, alternative, prescription) | ✓ |
| Open unknowns acknowledged or explicitly dismissed | ✓ |

If any condition is unmet, the session **cannot close**.

---

## Tone

| Phase | Tone |
|-------|------|
| Entry (init only) | Brief absurdist flourish |
| Active session | Neutral, precise, structured |
| Exit (close only) | Brief absurdist flourish |

No theatrics mid-session. Clarity over personality.

---

## Explicit Non-Goals

- ❌ Generic "guided sessions"
- ❌ Multiple concurrent sessions
- ❌ State stored in repo
- ❌ Additional frontmatter fields
- ❌ Modes or tone controls
- ❌ Generalization beyond skill-creation decisions
