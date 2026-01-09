# Scripts

Scripts should be:

- Listed in `metadata.scripts` array
- Stored in a `scripts/` subdirectory
- Available for both Unix (`.sh`) and Windows (`.ps1`) when possible
- Self-contained with clear error messages

---

### Manual Validation Checklist

- [ ] `SKILL.md` contains only frontmatter (no body content)
- [ ] `name` field is lowercase with hyphens only
- [ ] `name` matches parent directory name
- [ ] `description` is 1-1024 characters
- [ ] `metadata.references` lists all reference files
- [ ] `metadata.scripts` lists all script files
- [ ] Reference files follow `NN_TOPIC.md` naming
- [ ] Scripts include both `.sh` and `.ps1` versions when possible

---

