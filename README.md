# Skills

## Overview

This repository contains a collection of agent skills designed to prevent typical issues that surface during agentic programming sessions. Each skill provides structured guidance, instructions, and references to help AI agents perform specific tasks more effectively and avoid common pitfalls.

## Repository Structure

```
skills/
├── README.md                          # This file
├── LICENSE                            # Repository license
└── <skill-name>/                      # Individual skill directory
    ├── <SKILL>.md                     # Main skill file (thin)
    └── references/                    # Detailed instruction files
        ├── 1_<TOPIC>.md              # First reference (numbered)
        ├── 2_<TOPIC>.md              # Second reference (numbered)
        └── ...                        # Additional references
```

## Skills Index

_No skills have been added yet. Skills will be listed here as they are created._

<!-- Example format:
- **[Skill Name](./skill-name/SKILL.md)** - Brief description of what the skill does
-->

## Skill Structure

Each skill follows a canonical structure to ensure consistency and ease of use:

### Main Skill File (`SKILL.md`)

The main skill file is intentionally kept thin and serves as an entry point. It contains:

#### 1. Metadata
- **Name**: The skill's name
- **Description**: A brief description of the skill's purpose

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

**Naming Convention**: References follow the pattern `<N>_<TOPIC>.md` where:
- `<N>` is a sequential number (1, 2, 3, ...)
- `<TOPIC>` is a descriptive name in lowercase with underscores (e.g., `error_handling`, `best_practices`)

**Example**:
```
references/
├── 1_getting_started.md
├── 2_common_pitfalls.md
├── 3_advanced_techniques.md
└── 4_troubleshooting.md
```

## Contributing

When adding new skills to this repository:

1. Create a new directory for your skill
2. Add a `SKILL.md` file following the canonical structure
3. Create a `references/` subdirectory for detailed documentation
4. Follow the `<N>_<TOPIC>` naming convention for reference files
5. Update the Skills Index section in this README

## License

See [LICENSE](./LICENSE) for details.
