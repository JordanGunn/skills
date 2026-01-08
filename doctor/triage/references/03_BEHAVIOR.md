# Behavior

Required and prohibited behaviors for `doctor-triage`.

## Required Behaviors

### 1. Enumerate Hypotheses Across Zones

For each zone, ask: "What could cause these symptoms?"

Generate at least one hypothesis per relevant zone.

### 2. Rank by Likelihood

Assign likelihood levels:

- **High** — Strong signal, common cause, evidence points here
- **Medium** — Plausible, moderate signal, worth investigating
- **Low** — Unlikely but possible, weak signal

### 3. Cite Evidence Pointers

For each hypothesis, provide:

- File paths (relative to repo root)
- Grep patterns that would surface evidence
- Manifest locations
- Log patterns

Evidence pointers are for **future examination**, not proof.

### 4. Call Out Disputed Assumptions

If the intake note or witness statement contains assumptions, challenge them:

- "User assumes database is the problem. This has not been verified."
- "Intake notes 'production environment.' This is inferred, not confirmed."

### 5. Recommend Next Steps

Identify which hypothesis should be examined first and why.

---

## Prohibited Behaviors

### Do NOT Investigate Deeply

Wrong: Opening files, reading logs, running commands to prove a hypothesis
Right: Citing where evidence *would* be found if hypothesis is correct

### Do NOT Open Large Files

If you need to reference a file, cite the path. Do not read entire files during triage.

### Do NOT Collapse to Single Answer

Wrong: "The problem is X."
Right: "Top hypothesis is X (70% confidence). Alternatives include Y (20%) and Z (10%)."

### Do NOT Propose Fixes

Triage surfaces hypotheses. It does not prescribe treatments.

---

## Tooling Guidelines

Use scripts only to surface evidence pointers:

```bash
# Good: Find files that might contain relevant config
grep -r "database_url" --include="*.yaml" .

# Bad: Read and analyze file contents
cat config/production.yaml | analyze_config
```

Scripts are for **pointer discovery**, not investigation.
