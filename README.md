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

Each skill follows a canonical structure to ensure consistency and ease of use. **SKILL.md files are now strictly frontmatter** with skill resources defined in the `metadata` key.

### Main Skill File (`SKILL.md`)

The `SKILL.md` file contains only YAML frontmatter - no Markdown body content. All instructions and documentation are referenced through the `metadata` field.

#### Required Fields

- **`name`**: The skill's unique identifier (lowercase, hyphens only)
- **`description`**: A brief description of the skill's purpose and when to use it

#### Optional Fields

- **`license`**: License identifier (e.g., MIT, Apache-2.0)
- **`compatibility`**: Environment requirements
- **`allowed-tools`**: Pre-approved tools (experimental)

#### The `metadata` Field

The `metadata` field defines skill resources and properties:

- **`author`**: Skill author name or organization
- **`version`**: Semantic version string
- **`references`**: List of reference files (e.g., `["01_GOAL.md", "02_PROCEDURE.md"]`)
- **`scripts`**: List of executable scripts (e.g., `["index.sh", "validate.py"]`)
- **`keywords`**: List of keywords for skill discovery

**Example - Individual Skill:**
```yaml
---
name: plan-create
license: MIT
description: >
  Materialize the current conversation into a new docs/planning/phase-N plan
  (root plan plus sub-plans and task files).
metadata:
  author: Jordan Godau
  references:
    - 00_INSTRUCTIONS.md
    - 01_INTENT.md
    - 02_PRECONDITIONS.md
    - 03_SCRIPTS.md
    - 04_PROCEDURE.md
    - 05_TEMPLATES.md
    - 06_EDGE_CASES.md
  scripts:
    - dirs.ps1
    - dirs.sh
  keywords:
    - phase
    - plan
    - planning
    - task
---
```

### Skillsets (Parent Skills)

**Skillsets** are orchestrator skills that group and coordinate related member skills. They use the special `metadata.skillset` field to define the group structure.

#### The `metadata.skillset` Field

- **`name`**: Skillset identifier
- **`schema_version`**: Skillset schema version (currently `1`)
- **`skills`**: List of member skill names
- **`resources`**: Shared resources for the skillset
  - `root`: Shared resources directory path
  - `assets`: List of shared asset files
  - `scripts`: List of shared scripts
  - `references`: List of shared reference files
- **`pipelines`**: Skill execution pipelines
  - `default`: Default execution order
  - `allowed`: List of valid skill execution sequences
- **`requires`**: Dependencies (implementation TBD)

**Example - Skillset:**
```yaml
---
name: plan
description: >
  Orchestrator skill for the `plan` skillset. Dispatches to member skills in a safe, predictable order.
metadata:
  author: Jordan Godau
  version: 0.1.0

  skillset:
    name: plan
    schema_version: 1
    skills:
      - plan-create
      - plan-exec

    resources:
      root: .resources
      assets: []
      scripts: []
      references: 
        - TAXONOMY.md

    pipelines:
      default:
        - plan-create
        - plan-exec
      allowed:
        - [plan-exec]
        - [plan-create]
        - [plan-create, plan-exec]

    requires: []
---
```

### References Directory

Detailed instruction files are kept separate in a `references/` subdirectory. This enables progressive disclosure - agents load these files only when needed.

**Naming Convention**: References follow the pattern `<NN>_<TOPIC>.md` where:
- `<NN>` is a zero-padded sequential number (00, 01, 02, 03, ...)
- `<TOPIC>` is a descriptive name in uppercase with underscores (e.g., `GOAL`, `DEFINITIONS`, `PROCEDURE`)

**Example**:
```
skill-name/
├── SKILL.md                    # Frontmatter only
├── references/
│   ├── 00_INSTRUCTIONS.md
│   ├── 01_INTENT.md
│   ├── 02_PRECONDITIONS.md
│   ├── 03_PROCEDURE.md
│   └── 04_OUTPUT.md
└── scripts/
    ├── script1.sh
    └── script2.py
```

### Scripts Directory

Contains executable scripts referenced in `metadata.scripts`. Scripts should be self-contained and handle errors gracefully.

### Skillset Resources Directory

Skillsets may have a shared resources directory (e.g., `.resources/`) containing assets, scripts, and references used by multiple member skills.

## Contributing

When adding new skills to this repository:

1. Choose or create an appropriate category directory (e.g., `adapter/`, `index/`, `plan/`, `refactor/`)
2. Create a new directory for your skill within the category
3. Add a `SKILL.md` file with **frontmatter only** following the canonical structure (see [SPEC.md](./SPEC.md))
   - Include required fields: `name`, `description`
   - Use `metadata` field to define `author`, `references`, `scripts`, and `keywords`
   - For skillsets, add `metadata.skillset` with `skills`, `resources`, and `pipelines`
4. Create a `references/` subdirectory for detailed documentation
5. Follow the `<NN>_<TOPIC>.md` naming convention for reference files (zero-padded numbers, uppercase topics)
6. List reference files in `metadata.references` array
7. Optionally add a `scripts/` directory if your skill includes executable scripts
8. List script files in `metadata.scripts` array
9. Update the Skills Index section in this README
10. Run the index skill to regenerate INDEX.md: `./index/scripts/index.sh`

## License

See [LICENSE](./LICENSE) for details.
