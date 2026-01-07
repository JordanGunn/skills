---
name: index
license: MIT
description: >
  Generate a hierarchical index of all skills from SKILL.md files.
  Produces a Markdown index optimized for agent lookup with skillsets,
  member skills, keywords, and pipelines.
metadata:
  author: Jordan Godau
  references:
    - 01_INTENT.md
    - 02_PROCEDURE.md
    - 03_OUTPUT.md
  scripts:
    - index.sh
    - index.ps1
  keywords:
    - index
    - skill
    - skills
    - discovery
    - lookup
    - catalog
    - registry
    - skillset
    - perform
    - capability
---

# Instructions

Read all references in `references/` before using this skill.

## Signals

- A new skill or skillset was added
- The user asks to "index skills", "update skill catalog", or "regenerate skill index"
- An agent needs to discover available skills
- Skills are not being utilized passively

## References

**Directory:** `references/`

- `01_INTENT.md`
- `02_PROCEDURE.md`
- `03_OUTPUT.md`

## Scripts

**Directory:** `scripts/`

- `index.sh`: Scans `.codex/skills/` and generates `INDEX.md` (macOS/Linux/WSL)
- `index.ps1`: Scans `.codex/skills/` and generates `INDEX.md` (Windows)
