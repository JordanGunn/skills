---
name: adapter-windsurf
license: MIT
description: >
  Generate Windsurf workflows from agent skills. Creates thin workflow adapters
  that point to skill references, enabling Windsurf to invoke agent skills via
  slash commands.
metadata:
  author: Jordan Godau
  references:
    - 01_INTENT.md
    - 02_PROCEDURE.md
    - 03_OUTPUT.md
  scripts:
    - generate.sh
    - generate.ps1
  keywords:
    - adapter
    - windsurf
    - workflow
    - generate
    - slash command
---

# Instructions

Read all references in `references/` before using this skill.

## Signals

- A new agent skill was added and needs a Windsurf workflow
- The user asks to "sync workflows", "generate workflows", or "update windsurf"
- Windsurf workflows are out of sync with agent skills
- A skill's description or keywords changed

## References

**Directory:** `references/`

- `01_INTENT.md`
- `02_PROCEDURE.md`
- `03_OUTPUT.md`

## Scripts

**Directory:** `scripts/`

- `generate.sh`: Generates Windsurf workflows from all agent skills (macOS/Linux/WSL)
- `generate.ps1`: Generates Windsurf workflows from all agent skills (Windows)
