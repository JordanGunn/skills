---
name: adapter-cursor
license: MIT
description: >
  Generate Cursor commands from agent skills. Creates plain markdown command files
  that delegate to skill references, enabling Cursor to invoke agent skills.
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
    - cursor
    - command
    - generate
---

# Instructions

Read all references in `references/` before using this skill.

## Signals

- A new agent skill was added and needs a Cursor command
- The user asks to "sync cursor commands", "generate cursor", or "update cursor"
- Cursor commands are out of sync with agent skills
- A skill's description or references changed

## References

**Directory:** `references/`

- `01_INTENT.md`
- `02_PROCEDURE.md`
- `03_OUTPUT.md`

## Scripts

**Directory:** `scripts/`

- `generate.sh`: Generates Cursor commands from all agent skills (macOS/Linux/WSL)
- `generate.ps1`: Generates Cursor commands from all agent skills (Windows)
