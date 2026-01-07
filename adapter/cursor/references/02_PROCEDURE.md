# Procedure

## Automated (Preferred)

Run the generator script:

### macOS / Linux / WSL

```bash
.codex/skills/adapter/cursor/scripts/generate.sh
```

### Windows (PowerShell)

```powershell
.codex\skills\adapter\cursor\scripts\generate.ps1
```

The script will:

1. Find all SKILL.md files under `.codex/skills/`
2. For each skill (excluding meta-skills like `index-skills` and adapters):
   - Extract name, description, and references
   - Generate a command file at `.cursor/<name>.md`

## Manual (Fallback)

If the script is unavailable:

1. For each skill in `.codex/skills/`:
   - Read the `SKILL.md` frontmatter
   - Create `.cursor/<skill-name>.md`
   - Use the template from `03_OUTPUT.md`

## Regeneration Policy

Regenerate commands when:

- A new skill is added
- A skill's description or references change
- The skill index is updated

The generator is idempotent.
