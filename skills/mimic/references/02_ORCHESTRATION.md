# Orchestration

Defines the mimic orchestrator's runtime behavior.

## Invocation

The `mimic` orchestrator is invoked when:

- User explicitly calls `mimic` or `/mimic`
- A persona selector sub-skill is invoked (e.g., `mimic-wizard`)

## State Reading

On each invocation, the orchestrator:

1. Reads `ACTIVE_PERSONA.json` from `.resources/state/`
2. Extracts `active`, `intensity`, and `seed` fields
3. Proceeds based on `active` value

## Resolution Protocol

```
1. Read ACTIVE_PERSONA.json
2. If active is null/empty/missing → True Form Resolution (§3.4)
3. If active is set → Registry Resolution
   a. Look up ID in REGISTRY.json
   b. If found → load PERSONALITY.md from path
   c. If not found → warning + no overlay
4. Merge: guardrails > protocol > persona laws
5. Apply overlay to prose output
```

## Registry Resolution

The orchestrator **never scans the filesystem**.

All persona resolution flows through `REGISTRY.json`:

```json
{
  "personas": {
    "<id>": {
      "path": "<relative-path-to-PERSONALITY.md>",
      "name": "<display-name>",
      "tagline": "<one-line-description>"
    }
  }
}
```

If persona ID is not in registry: emit warning, proceed without overlay.

## Law Merging

Order of precedence (highest first):

1. **Guardrails** — Constitutional rules, never overridden
2. **Protocol** — Shared overlay mechanics
3. **Persona Laws** — Character-specific behavior

## Overlay Application

After resolution:

1. Generate response content normally (reasoning, tools, etc.)
2. Apply persona overlay to prose sections only
3. Respect exempt content rules from guardrails
4. Use intensity level to control overlay density

## Dismissal Handling

When user requests dismissal:

1. Set `ACTIVE_PERSONA.active` to `null`
2. Emit exit marker appropriate to dismissed persona
3. Resume normal operation
4. Confirm dismissal briefly

## No Active Persona Resolution

When `mimic` is invoked and no persona is active:

→ See `03_TRUE_FORM.md` for full specification.

Summary:

1. Render true form response (one-time, absurd, PG-13)
2. List available personas from registry
3. Prompt user to select
4. Do not persist true form as state

## Edge Cases

| Condition | Behavior |
|-----------|----------|
| `ACTIVE_PERSONA.json` missing | True Form Resolution |
| `ACTIVE_PERSONA.json` malformed | True Form Resolution + warning |
| `REGISTRY.json` missing | Fatal error—skillset misconfigured |
| Persona ID not in registry | Warning + no overlay |
| `PERSONALITY.md` unreadable | Warning + no overlay |
| Intensity out of range | Clamp to 1-3 |
| Seed invalid | Ignore seed, proceed |

## State Mutation

Only selector sub-skills mutate `ACTIVE_PERSONA.json`.

The orchestrator **reads** state but does **not write** it,
except for dismissal (setting `active` to `null`).
