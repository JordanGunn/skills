# Agent Skills

A collection of structured skills for AI agents to perform specific tasks effectively and avoid common pitfalls in agentic programming.

## What's New

**Recent Updates (January 2026):**
- 🩺 **New Skillset**: `doctor` - Diagnostic protocol modeling software failures as medical cases
- 🧙 **New Skill**: `wizard` - Guided sensemaking and epistemic calibration
- 🏠 **New Skill**: `refactor-squatters` - Detect modules occupying wrong namespace positions
- ✨ **New Skill**: `plan-status` - Track plan execution progress with frontmatter parsing
- 🪟 **Windows Support**: PowerShell (`.ps1`) scripts added to `adapter`, `index`, and `plan` skills
- 📦 **Adapter Skillset**: Created `SKILLSET` for coordinating IDE adapter generation
- 📊 **Plan Status Tracking**: Added frontmatter status values (`pending`, `in_progress`, `complete`)
- 🔄 **Enhanced Plan Skills**: All plan skills now support artifact status parsing

See [CHANGELOG.md](#) for complete release history.

## Quick Links

- 📚 [Skills Reference](./docs/02_SKILLS.md) - Browse all available skills
- 🎯 [Skillsets](./docs/03_SKILLSETS.md) - Learn about orchestrator skills
- 📋 [INDEX.md](./INDEX.md) - Auto-generated skill index with keywords
- 📖 [Formal Specification](./SPEC.md) - Official Agent Skills format

## Overview

This repository provides **agent skills** - structured instructions that help AI agents perform specific tasks more effectively. Each skill includes:

- **Clear guidance** on when and how to use the skill
- **Step-by-step procedures** stored in reference files
- **Executable scripts** for automation (Unix and Windows)
- **Keywords and metadata** for easy discovery

### Key Features

- **Individual Skills**: Standalone skills for specific tasks
- **Skillsets**: Orchestrator skills that coordinate multiple related skills
- **Cross-Platform**: Scripts for both Unix/macOS/Linux (`.sh`) and Windows (`.ps1`)
- **Progressive Disclosure**: Frontmatter-only `SKILL.md` files that reference detailed documentation
- **Spec Compliant**: Follows the [Agent Skills specification](./SPEC.md)

## Documentation

### Getting Started

- **[Quickstart Guide](./docs/01_QUICKSTART.md)** - Get up and running quickly
  - What are Agent Skills?
  - Repository structure overview
  - Using skills and running scripts
  - Quick actions and common commands

### Reference Documentation

- **[Skills Reference](./docs/02_SKILLS.md)** - Complete guide to individual skills
  - Adapter skills (Cursor, Windsurf)
  - Index skill (skill discovery)
  - Plan skills (create, exec, status)
  - Refactor skills (code quality audits)
  - Keyword index for quick lookup

- **[Skillsets](./docs/03_SKILLSETS.md)** - Understanding orchestrator skills
  - What are skillsets?
  - How skillsets work
  - Available skillsets (adapter, plan, refactor)
  - Creating new skillsets

- **[Schema Documentation](./docs/04_SCHEMAS.md)** - Technical reference
  - SKILL.md frontmatter schema
  - SKILLSET custom schema
  - Plan artifact frontmatter
  - Examples and validation

- **[Contributing Guidelines](./docs/05_CONTRIBUTING.md)** - Add your own skills
  - Adding individual skills
  - Creating skillsets
  - Schema requirements
  - Testing and submission

## Available Skills

### Skillsets (Orchestrators)

- **[adapter](./adapter/SKILL.md)** - Coordinate IDE adapter generation (Windsurf, Cursor)
- **[doctor](./doctor/SKILL.md)** - Diagnostic protocol modeling software failures as medical cases
- **[plan](./plan/SKILL.md)** - Coordinate planning, execution, and status tracking
- **[refactor](./refactor/SKILL.md)** - Coordinate code quality audits

### Individual Skills

**Adapter Skills:**
- [adapter-cursor](./adapter/cursor/SKILL.md) - Generate Cursor commands
- [adapter-windsurf](./adapter/windsurf/SKILL.md) - Generate Windsurf workflows

**Doctor Skills:**
- [doctor-intake](./doctor/intake/SKILL.md) - Convert user's description into clinically precise intake note
- [doctor-triage](./doctor/triage/SKILL.md) - Breadth-first hypothesis surfacing and prioritization
- [doctor-exam](./doctor/exam/SKILL.md) - Focused evidence gathering on one suspect area
- [doctor-treatment](./doctor/treatment/SKILL.md) - Diagnosis estimate + proposed treatment options

**Index Skill:**
- [index](./index/SKILL.md) - Generate hierarchical skill index

**Plan Skills:**
- [plan-create](./plan/create/SKILL.md) - Create execution plans
- [plan-exec](./plan/exec/SKILL.md) - Execute existing plans
- [plan-status](./plan/status/SKILL.md) - Track plan progress

**Wizard Skill:**
- [wizard](./wizard/SKILL.md) - Guided sensemaking and epistemic calibration

**Refactor Skills:**
- [refactor-dictionaries](./refactor/dictionaries/SKILL.md) - Audit dictionary usage
- [refactor-import-hygiene](./refactor/import-hygiene/SKILL.md) - Audit Python imports
- [refactor-inline-complexity](./refactor/inline-complexity/SKILL.md) - Audit inline complexity
- [refactor-lexical-ontology](./refactor/lexical-ontology/SKILL.md) - Audit identifiers
- [refactor-module-stutter](./refactor/module-stutter/SKILL.md) - Detect module name stutter
- [refactor-semantic-noise](./refactor/semantic-noise/SKILL.md) - Audit semantic noise
- [refactor-squatters](./refactor/squatters/SKILL.md) - Detect modules occupying wrong namespace positions
- [refactor-structural-duplication](./refactor/structural-duplication/SKILL.md) - Identify structural duplication

See [Skills Reference](./docs/02_SKILLS.md) for detailed descriptions and [INDEX.md](./INDEX.md) for the auto-generated index.

## Quick Start

### Install and Run Scripts

**macOS / Linux / WSL:**
```bash
# Generate skill index
./index/scripts/index.sh

# Check plan status
./plan/status/scripts/status.sh

# Generate IDE adapters
./adapter/windsurf/scripts/generate.sh
./adapter/cursor/scripts/generate.sh
```

**Windows (PowerShell):**
```powershell
# Generate skill index
.\index\scripts\index.ps1

# Check plan status
.\plan\status\scripts\status.ps1

# Generate IDE adapters
.\adapter\windsurf\scripts\generate.ps1
.\adapter\cursor\scripts\generate.ps1
```

See [Quickstart Guide](./docs/01_QUICKSTART.md) for more examples.

## Understanding Skills

### Skill Structure

Each skill follows a canonical structure:

```
skill-name/
├── SKILL.md              # Frontmatter only (no body content)
├── references/           # Detailed documentation
│   ├── 00_INSTRUCTIONS.md
│   ├── 01_INTENT.md
│   └── 02_PROCEDURE.md
└── scripts/              # Executable automation
    ├── script.sh         # Unix/macOS/Linux
    └── script.ps1        # Windows PowerShell
```

- **SKILL.md**: Contains only YAML frontmatter with metadata
- **references/**: Progressive disclosure - detailed instructions loaded as needed
- **scripts/**: Cross-platform automation with identical functionality

See [Schema Documentation](./docs/04_SCHEMAS.md) for complete details.

### Skillsets

Skillsets are orchestrator skills that coordinate multiple related skills:

- **`adapter` skillset**: Coordinates Windsurf and Cursor adapter generation
- **`plan` skillset**: Coordinates plan creation, execution, and status tracking
- **`refactor` skillset**: Coordinates code quality audits in recommended order

Skillsets use a strict `metadata.skillset` schema that maintains spec compliance while providing orchestration capabilities.

See [Skillsets Documentation](./docs/03_SKILLSETS.md) to learn more.

## Contributing

We welcome contributions! Before adding a new skill:

1. **Check existing skills** to avoid duplication
2. **Review the [Contributing Guidelines](./docs/05_CONTRIBUTING.md)** for detailed instructions
3. **Follow the schema requirements** for skills or skillsets
4. **Test thoroughly** including cross-platform scripts
5. **Regenerate the index** using `./index/scripts/index.sh` or `.\index\scripts\index.ps1`

### Key Requirements

- ✅ `SKILL.md` must contain **only frontmatter** (no body content)
- ✅ Skills must follow the [canonical schema](./docs/04_SCHEMAS.md)
- ✅ Skillsets must use the strict `metadata.skillset` schema
- ✅ Scripts should support both Unix (`.sh`) and Windows (`.ps1`)
- ✅ Reference files must follow `NN_TOPIC.md` naming convention

See the [Contributing Guidelines](./docs/05_CONTRIBUTING.md) for complete details.

## License

See [LICENSE](./LICENSE) for details.
