---
name: adapter
description: >
  Regenerate IDE adapter files (Windsurf workflows and Cursor commands) from
  agent skills. Runs both adapters by default to keep all IDE integrations in sync.
metadata:
  author: Jordan Godau
  skillset:
    skills:
      - adapter-windsurf
      - adapter-cursor
    pipelines:
      default:
        - adapter-windsurf
        - adapter-cursor
      allowed:
        - adapter-windsurf
        - adapter-cursor
  keywords:
    - adapter
    - generate
    - windsurf
    - cursor
    - workflow
    - workflows
    - command
    - commands
    - instruction
    - instructions
    - skill
    - skills
    - sync
---

# Instructions

This is an orchestrator skillset. Read member skill manifests before proceeding.

## Default Behavior

When invoked without arguments, runs the **default pipeline**:

1. `adapter-windsurf` — Regenerate `.windsurf/workflows/`
2. `adapter-cursor` — Regenerate `.cursor/commands/`

## Member Skills

| Skill | Purpose |
|-------|---------|
| `adapter-windsurf` | Generate Windsurf workflow files |
| `adapter-cursor` | Generate Cursor command files |

## When to Use

- After adding, modifying, or removing skills
- After changing skill metadata (name, description, keywords)
- To ensure IDE integrations are in sync with skill definitions

## Quick Run

### macOS / Linux / WSL

```bash
.codex/skills/adapter/windsurf/scripts/generate.sh && \
.codex/skills/adapter/cursor/scripts/generate.sh
```

### Windows (PowerShell)

```powershell
.codex\skills\adapter\windsurf\scripts\generate.ps1
.codex\skills\adapter\cursor\scripts\generate.ps1
```
