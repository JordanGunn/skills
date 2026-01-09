# Persona Activation

Deterministic activation flow for the mimic skill.

## Slot State Machine

```
┌─────────────┐     validate.sh     ┌─────────────┐
│    EMPTY    │ ──────────────────► │   PROMPT    │
│  (no spec)  │      exit 2         │  (ask user) │
└─────────────┘                     └─────────────┘

┌─────────────┐     validate.sh     ┌─────────────┐
│   INVALID   │ ──────────────────► │  TRUE FORM  │
│ (bad spec)  │      exit 1         │  (comedy)   │
└─────────────┘                     └─────────────┘

┌─────────────┐     validate.sh     ┌─────────────┐
│    VALID    │ ──────────────────► │   OVERLAY   │
│ (good spec) │      exit 0         │  (persona)  │
└─────────────┘                     └─────────────┘
```

## Activation Procedure

1. **Run**: `scripts/validate.sh`
2. **Branch** on exit code:
   - `exit 2` (empty): Prompt user → `scripts/list.sh` → `scripts/load.sh <persona>`
   - `exit 1` (invalid): Apply true form from `references/03_TRUE_FORM.md`
   - `exit 0` (valid): Read `assets/persona/spec.yaml`, apply overlay

## Scripts

| Script | Purpose |
|--------|---------|
| `validate.sh` | Check slot state (empty/invalid/valid) |
| `list.sh` | List available personas in library |
| `load.sh <name>` | Copy spec from library to slot |
| `eject.sh` | Clear slot (triggers prompt on next activation) |

## Example Flow

```bash
# Check state
$ scripts/validate.sh
empty

# User prompted, chooses wizard
$ scripts/load.sh wizard
✨ Loaded 'wizard' into slot.

# Validate again
$ scripts/validate.sh
valid: wizard
```

## Character Reference

Persona specs are stored in `assets/library/`. The loaded spec lives at `assets/persona/spec.yaml`.
