# Skills

## Overview

This repository contains a collection of agent skills designed to prevent typical issues that surface during agentic programming sessions. Each skill provides structured guidance, instructions, and references to help AI agents perform specific tasks more effectively and avoid common pitfalls.

## Repository Structure

```
skills/
├── README.md                          # This file
├── INDEX.md                           # Auto-generated skill index
├── LICENSE                            # Repository license
├── SPEC.md                            # Formal specification for skills
├── adapter/                           # Adapter skills for IDE/tools
│   ├── cursor/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   └── windsurf/
│       ├── SKILL.md
│       ├── assets/
│       ├── references/
│       └── scripts/
├── index/                             # Skill indexing and discovery
│   ├── SKILL.md
│   ├── references/
│   └── scripts/
├── plan/                              # Planning and execution skillset
│   ├── SKILL.md                       # Skillset orchestrator
│   ├── create/
│   │   ├── SKILL.md
│   │   ├── references/
│   │   └── scripts/
│   └── exec/
│       ├── SKILL.md
│       └── references/
└── refactor/                          # Code refactoring skillset
    ├── SKILL.md                       # Skillset orchestrator
    ├── dictionaries/
    │   ├── SKILL.md
    │   └── references/
    ├── import-hygiene/
    │   ├── SKILL.md
    │   └── references/
    ├── inline-complexity/
    │   ├── SKILL.md
    │   └── references/
    ├── lexical-ontology/
    │   ├── SKILL.md
    │   └── references/
    ├── module-stutter/
    │   ├── SKILL.md
    │   ├── references/
    │   └── scripts/
    ├── semantic-noise/
    │   ├── SKILL.md
    │   └── references/
    └── structural-duplication/
        ├── SKILL.md
        └── references/
```

## Skills Index

### Adapter Skills

Adapter skills for generating IDE and tool integrations:

- **[cursor](./adapter/cursor/SKILL.md)** - Generate Cursor commands from agent skills. Creates plain markdown command files that delegate to skill references, enabling Cursor to invoke agent skills.
- **[windsurf](./adapter/windsurf/SKILL.md)** - Generate Windsurf workflows from agent skills. Creates thin workflow adapters that point to skill references, enabling Windsurf to invoke agent skills via slash commands.

### Index Skill

Skill indexing and discovery:

- **[index](./index/SKILL.md)** - Generate a hierarchical index of all skills from SKILL.md files. Produces a Markdown index optimized for agent lookup with skillsets, member skills, keywords, and pipelines.

### Plan Skillset

Development phase management skills:

- **[plan](./plan/SKILL.md)** - Orchestrator skill for the `plan` skillset. Dispatches to member skills in a safe, predictable order.
  - **[create](./plan/create/SKILL.md)** - Materialize the current conversation into a new docs/planning/phase-N plan (root plan plus sub-plans and task files).
  - **[exec](./plan/exec/SKILL.md)** - Execute an existing docs/planning/phase-N plan sequentially by completing subtasks.

### Refactor Skillset

Code quality audit and refactoring skills:

- **[refactor](./refactor/SKILL.md)** - Orchestrator skill for the `refactor` skillset. Dispatches to member skills for code quality audits and structural improvements.
  - **[dictionaries](./refactor/dictionaries/SKILL.md)** - Audit dictionary usage against the Dictionary Usage Doctrine. Produces a severity-grouped report with minimal refactor suggestions.
  - **[import-hygiene](./refactor/import-hygiene/SKILL.md)** - Audit Python imports to preserve semantic context and prevent shadowing after refactors.
  - **[inline-complexity](./refactor/inline-complexity/SKILL.md)** - Audit inline complexity and recommend variable extraction. Produces a report with flattening suggestions for nested expressions.
  - **[lexical-ontology](./refactor/lexical-ontology/SKILL.md)** - Audit identifiers and namespaces for lexical-semantic and ontological correctness.
  - **[module-stutter](./refactor/module-stutter/SKILL.md)** - Detect module/package name stutter in Python public APIs. Produces a Markdown report and optional CI gate.
  - **[semantic-noise](./refactor/semantic-noise/SKILL.md)** - Audit semantic noise and namespace integrity.
  - **[structural-duplication](./refactor/structural-duplication/SKILL.md)** - Identify structurally duplicate logic (pipeline-spine duplication) across semantically distinct modules.

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

1. Choose or create an appropriate category directory (e.g., `adapter/`, `index/`, `plan/`, `refactor/`)
2. Create a new directory for your skill within the category
3. Add a `SKILL.md` file following the canonical structure (see [SPEC.md](./SPEC.md))
4. Create a `references/` subdirectory for detailed documentation
5. Follow the `<NN>_<TOPIC>` naming convention for reference files (zero-padded numbers, uppercase topics)
6. Optionally add a `scripts/` directory if your skill includes executable scripts
7. Update the Skills Index section in this README
8. Run the index skill to regenerate INDEX.md: `./index/scripts/index.sh`

## License

See [LICENSE](./LICENSE) for details.
