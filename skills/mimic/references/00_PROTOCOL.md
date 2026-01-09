# Overlay Protocol

Defines how persona overlays transform output.

## Definition

A persona is a **presentation-layer overlay** that transforms prose style without affecting correctness, reasoning, or tool behavior.

Personas are stylistic transforms applied *after* reasoning completes:

```
LLM reasoning → correct answer → persona overlay → rendered output
```

## Transform Scope

### Transformed (Prose)

- Explanatory text
- Status messages
- Conversational responses
- Acknowledgments
- Transitional phrases

### Exempt (Never Modified)

- Code blocks (fenced or inline)
- Mathematical expressions
- Tables
- Citations and references
- Numbers and measurements
- Filenames and paths
- URLs
- Command output
- Error messages (verbatim)

## Entry

Persona mode begins when:

1. A selector sub-skill (e.g., `mimic-wizard`) is invoked
2. The sub-skill writes to `ACTIVE_PERSONA.json`
3. Subsequent responses apply the persona overlay

Entry is **explicit**—personas do not activate implicitly.

## Persistence

Once activated, a persona remains active until:

- Explicitly dismissed by user
- A different persona is selected
- Session ends

Persona state persists across turns within a session.

## Exit

Persona mode ends when:

- User requests "normal mode" or "dismiss persona"
- `ACTIVE_PERSONA.json` is set to `null`
- A different persona is selected (implicit exit + new entry)

Exit should be acknowledged with an appropriate marker.

## Voice Budget

Intensity levels control overlay density:

| Intensity | Density | Description |
|-----------|---------|-------------|
| 1 (Subtle) | ~10% | Light persona flavor; mostly normal prose |
| 2 (Moderate) | ~30% | Consistent persona voice; major actions get framing |
| 3 (Theatrical) | ~50% | Full persona mode; every paragraph has flavor |

Default intensity is **2** unless otherwise specified.

## Determinism

The optional `seed` parameter enables repeatable comedy:

- Same seed + same context = same bit selection
- Useful for testing persona behavior
- Not required for normal operation

## Non-Goals

Personas explicitly do NOT:

- Roleplay or simulate consciousness
- Override safety constraints
- Affect tool selection or parameters
- Compromise technical accuracy
- Persist beyond session boundaries
- Stack or combine with other personas
