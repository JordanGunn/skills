# Skills

## Overview

This repository contains a collection of agent skills designed to prevent typical issues that surface during agentic programming sessions. Each skill provides structured guidance, instructions, and references to help AI agents perform specific tasks more effectively and avoid common pitfalls.

## Repository Structure

```
skills/
├── README.md                          # This file
├── LICENSE                            # Repository license
├── SPEC.md                            # Formal specification for skills
├── audit/                             # Code quality audit skills
│   ├── inline-complexity/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── lexical-ontology/
│   │   ├── SKILL.md
│   │   └── references/
│   ├── module-stutter/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   ├── semantic-noise/
│   │   ├── SKILL.md
│   │   └── references/
│   └── structural-duplication/
│       ├── SKILL.md
│       └── references/
└── phase/                             # Development phase management skills
    ├── execute/
    │   ├── SKILL.md
    │   └── references/
    └── plan/
        ├── SKILL.md
        └── references/
```

## Skills Index

### Audit Skills

Code quality audit skills for identifying and preventing common issues:

- **[inline-complexity](./audit/inline-complexity/SKILL.md)** - Audit inline complexity and recommend variable extraction. Produces a report with flattening suggestions for nested expressions.
- **[lexical-ontology](./audit/lexical-ontology/SKILL.md)** - Audit lexical ontology for consistent and meaningful naming.
- **[module-stutter](./audit/module-stutter/SKILL.md)** - Detect module/package name stutter in Python public APIs. Produces a Markdown report and optional CI gate.
- **[semantic-noise](./audit/semantic-noise/SKILL.md)** - Audit semantic noise and recommend improvements for code clarity.
- **[structural-duplication](./audit/structural-duplication/SKILL.md)** - Identify structural duplication patterns and suggest refactoring opportunities.

### Phase Skills

Development phase management skills:

- **[execute](./phase/execute/SKILL.md)** - Execute development tasks within a planned phase.
- **[plan](./phase/plan/SKILL.md)** - Convert the current conversation into a new numbered planning phase. Creates docs/planning/phase-N/ with root and subphase plan.md scaffolds.

## Skill Structure

Each skill follows a canonical structure to ensure consistency and ease of use:

### Main Skill File (`SKILL.md`)

The main skill file is intentionally kept thin and serves as an entry point. It contains:

#### 1. Metadata (YAML Frontmatter)
- **Name**: The skill's name (in `name` field)
- **Description**: A brief description of the skill's purpose (in `description` field)

Example:
```yaml
---
name: audit-inline-complexity
description: |
  Audit inline complexity and recommend variable extraction.
  Produces a report with flattening suggestions for nested expressions.
---
```

#### 2. Instructions Section
High-level guidance on how to use the skill, with references to detailed documentation in the `references/` directory.

#### 3. Signals Section
Indicators or triggers that suggest when this skill should be applied during an agentic programming session.

#### 4. References Index
A list of links to detailed instruction files in the `references/` directory. Each reference provides in-depth guidance on specific aspects of the skill.

#### 5. Scripts Index
A list of any scripts or code examples that accompany the skill.

### References Directory

Detailed instruction files are kept separate from the main `SKILL.md` file in a `references/` subdirectory. This keeps the main skill file clean and allows for modular, detailed documentation.

**Naming Convention**: References follow the pattern `<NN>_<TOPIC>.md` where:
- `<NN>` is a zero-padded sequential number (01, 02, 03, ...)
- `<TOPIC>` is a descriptive name in uppercase with underscores (e.g., `GOAL`, `DEFINITIONS`, `PROCEDURE`)

**Example**:
```
references/
├── 01_INTENT.md
├── 02_PRECONDITIONS.md
├── 03_PROCEDURE.md
└── 04_OUTPUT.md
```

## Contributing

When adding new skills to this repository:

1. Choose or create an appropriate category directory (e.g., `audit/`, `phase/`)
2. Create a new directory for your skill within the category
3. Add a `SKILL.md` file following the canonical structure (see [SPEC.md](./SPEC.md))
4. Create a `references/` subdirectory for detailed documentation
5. Follow the `<NN>_<TOPIC>` naming convention for reference files (zero-padded numbers, uppercase topics)
6. Optionally add a `scripts/` directory if your skill includes executable scripts
7. Update the Skills Index section in this README

## License

See [LICENSE](./LICENSE) for details.
