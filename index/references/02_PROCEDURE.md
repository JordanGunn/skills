# Procedure

## Automated (Preferred)

Run the index generator script:

### macOS / Linux / WSL

```bash
.codex/skills/index/scripts/index.sh
```

### Windows (PowerShell)

```powershell
.codex\skills\index\scripts\index.ps1
```

The script will:

1. Find all `SKILL.md` files under `.codex/skills/`
2. Parse YAML frontmatter for: `name`, `description`, `metadata.keywords`, `metadata.skillset`
3. Detect skillset orchestrators vs member skills vs standalone skills
4. Generate `.codex/skills/INDEX.md`

## Manual (Fallback)

If the script is unavailable or fails:

1. List all directories under `.codex/skills/`
2. For each directory containing `SKILL.md`:
   - Extract `name` from frontmatter
   - Extract first line of `description`
   - Extract `metadata.keywords` list
   - Check for `metadata.skillset` (indicates orchestrator)
3. Build the index following the output format in `03_OUTPUT.md`

## Validation

After generation, verify:

- All known skills appear in the Quick Reference Table
- Skillset orchestrators list their member skills
- No orphaned member skills (prefix matches a skillset but skillset missing)
- Keyword index has no empty entries
