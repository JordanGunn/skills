# Procedure

## Automated (Preferred)

Run the generator script:

### macOS / Linux / WSL

```bash
.codex/skills/adapter/windsurf/scripts/generate.sh
```

### Windows (PowerShell)

```powershell
.codex\skills\adapter\windsurf\scripts\generate.ps1
```

The script will:

1. Read `.codex/skills/INDEX.md` for the skill catalog
2. For each skill (excluding `index-skills` and adapters):
   - Extract name, description, and skill path
   - Generate a workflow file at `.windsurf/workflows/<name>.md`
3. Skip skills that already have hand-written workflows (optional override)

## Manual (Fallback)

If the script is unavailable:

1. For each skill in `.codex/skills/`:
   - Read the `SKILL.md` frontmatter
   - Create `.windsurf/workflows/<skill-name>.md`
   - Use the template from `03_OUTPUT.md`

## Regeneration Policy

Regenerate workflows when:

- A new skill is added
- A skill's description changes
- The skill index is updated
- Windsurf workflows appear stale

The generator is idempotent — safe to run repeatedly.
