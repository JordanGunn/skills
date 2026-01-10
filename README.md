# Agent Skills

A collection of structured skills for AI agents to perform specific tasks effectively and avoid common pitfalls in agentic programming.

## What's New

**Recent Updates (January 2026):**

- ✨ **New Skillsets**: `doctor`, `md`, `prompt`, and `task` skillsets for comprehensive workflow orchestration
- 🎭 **Standalone Skills**: `mimic` skill for persona overlay and stylistic transforms
- 📊 **Plan Status Tracking**: `plan-status` skill for tracking plan execution progress
- 🔍 **Refactor Suite**: Complete code quality audit skills including `refactor-squatters`
- 📋 **Task Management**: Full task lifecycle management with validation and chronological awareness

## Quick Links

- 📚 [Skills Reference](./docs/SKILLS.md) - Browse all available skills
- 🎯 [Skillsets](./docs/SKILLSETS.md) - Learn about orchestrator skills
- 📋 [Skill Index](./skills/.INDEX.md) - Auto-generated skill index with keywords
- 📖 [Quickstart Guide](./docs/QUICKSTART.md) - Get started quickly

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
- **Spec Compliant**: Follows the Agent Skills specification

## Documentation

### Getting Started

- **[Quickstart Guide](./docs/QUICKSTART.md)** - Get up and running quickly
  - What are Agent Skills?
  - Repository structure overview
  - Using skills and running scripts
  - Quick actions and common commands

### Reference Documentation

- **[Skills Reference](./docs/SKILLS.md)** - Complete guide to individual skills
  - Doctor skills (diagnostic protocol)
  - Markdown skills (chunking workflows)
  - Plan skills (create, exec, status)
  - Prompt skills (forge, exec)
  - Refactor skills (code quality audits)
  - Task skills (lifecycle management)
  - Standalone skills (mimic)
  - Keyword index for quick lookup

- **[Skillsets](./docs/SKILLSETS.md)** - Understanding orchestrator skills
  - What are skillsets?
  - How skillsets work
  - Available skillsets (doctor, md, plan, prompt, refactor, task)
  - Creating new skillsets

- **[Schema Documentation](./docs/schema/skill/01_OVERVIEW.md)** - Technical reference
  - SKILL.md frontmatter schema
  - SKILLSET custom schema
  - Reference files and scripts
  - Examples and validation

- **[Contributing Guidelines](./CONTRIBUTING.md)** - Add your own skills
  - Adding individual skills
  - Creating skillsets
  - Schema requirements
  - Testing and submission

## Available Skills

### Skillsets (Orchestrators)

- **[doctor](./skills/doctor/SKILL.md)** - Medical-model diagnostic protocol for software failures
- **[md](./skills/md/SKILL.md)** - Coordinate markdown chunking workflows (split → index → summary)
- **[plan](./skills/plan/SKILL.md)** - Coordinate planning, execution, and status tracking
- **[prompt](./skills/prompt/SKILL.md)** - Coordinate prompt forging and execution
- **[refactor](./skills/refactor/SKILL.md)** - Coordinate code quality audits
- **[task](./skills/task/SKILL.md)** - Coordinate task creation and lifecycle management

### Individual Skills

**Doctor Skills:**

- [doctor-exam](./skills/doctor/exam/SKILL.md) - Conduct focused, evidence-driven examination
- [doctor-intake](./skills/doctor/intake/SKILL.md) - Convert raw descriptions into intake notes
- [doctor-treatment](./skills/doctor/treatment/SKILL.md) - Produce treatment notes with diagnosis
- [doctor-triage](./skills/doctor/triage/SKILL.md) - Perform hypothesis surfacing and prioritization

**Markdown Skills:**

- [md-split](./skills/md/split/SKILL.md) - Split markdown files by H2 headings

**Plan Skills:**

- [plan-create](./skills/plan/create/SKILL.md) - Create execution plans
- [plan-exec](./skills/plan/exec/SKILL.md) - Execute existing plans
- [plan-status](./skills/plan/status/SKILL.md) - Track plan progress

**Prompt Skills:**

- [prompt-forge](./skills/prompt/forge/SKILL.md) - Shape and refine human intent into canonical prompts
- [prompt-exec](./skills/prompt/exec/SKILL.md) - Execute forged prompts exactly as written

**Refactor Skills:**

- [refactor-dictionaries](./skills/refactor/dictionaries/SKILL.md) - Audit dictionary usage
- [refactor-import-hygiene](./skills/refactor/import-hygiene/SKILL.md) - Audit Python imports
- [refactor-inline-complexity](./skills/refactor/inline-complexity/SKILL.md) - Audit inline complexity
- [refactor-lexical-ontology](./skills/refactor/lexical-ontology/SKILL.md) - Audit identifiers
- [refactor-module-stutter](./skills/refactor/module-stutter/SKILL.md) - Detect module name stutter
- [refactor-semantic-noise](./skills/refactor/semantic-noise/SKILL.md) - Audit semantic noise
- [refactor-squatters](./skills/refactor/squatters/SKILL.md) - Detect namespace squatters
- [refactor-structural-duplication](./skills/refactor/structural-duplication/SKILL.md) - Identify structural duplication

**Task Skills:**

- [task-activate](./skills/task/activate/SKILL.md) - Activate a task
- [task-create](./skills/task/create/SKILL.md) - Create a new task
- [task-invalidate](./skills/task/invalidate/SKILL.md) - Invalidate a task
- [task-list](./skills/task/list/SKILL.md) - List tasks with filters
- [task-next](./skills/task/next/SKILL.md) - Navigate to next task
- [task-prev](./skills/task/prev/SKILL.md) - Navigate to previous task
- [task-review](./skills/task/review/SKILL.md) - Review a task
- [task-status](./skills/task/status/SKILL.md) - Display task status
- [task-validate](./skills/task/validate/SKILL.md) - Validate a task

**Standalone Skills:**

- [mimic](./skills/mimic/SKILL.md) - Persona overlay skill for stylistic transforms

See [Skills Reference](./docs/SKILLS.md) for detailed descriptions and [Skill Index](./skills/.INDEX.md) for the auto-generated index.

## Quick Start

### Using Skills

Skills are structured instructions that can be used by AI agents. Each skill includes:

- **SKILL.md**: Frontmatter with metadata and description
- **references/**: Detailed documentation loaded as needed
- **scripts/**: Cross-platform automation scripts (when applicable)

To use a skill, refer to its `SKILL.md` file and associated reference documentation. See the [Quickstart Guide](./docs/QUICKSTART.md) for detailed usage instructions.

## Understanding Skills

### Skill Structure

Each skill follows a canonical structure:

```text
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

See [Schema Documentation](./docs/schema/skill/01_OVERVIEW.md) for complete details.

### Skillsets

Skillsets are orchestrator skills that coordinate multiple related skills:

- **`doctor` skillset**: Diagnostic protocol for software failures using medical-model approach
- **`md` skillset**: Coordinates markdown chunking workflows
- **`plan` skillset**: Coordinates plan creation, execution, and status tracking
- **`prompt` skillset**: Coordinates prompt forging and execution for safe intent handling
- **`refactor` skillset**: Coordinates code quality audits in recommended order
- **`task` skillset**: Coordinates task lifecycle management with validation

Skillsets use a strict `metadata.skillset` schema that maintains spec compliance while providing orchestration capabilities.

See [Skillsets Documentation](./docs/SKILLSETS.md) to learn more.

## Contributing

We welcome contributions! Before adding a new skill:

1. **Check existing skills** to avoid duplication
2. **Review the [Contributing Guidelines](./CONTRIBUTING.md)** for detailed instructions
3. **Follow the schema requirements** for skills or skillsets
4. **Test thoroughly** including cross-platform scripts when applicable

### Key Requirements

- ✅ `SKILL.md` must contain **only frontmatter** (no body content)
- ✅ Skills must follow the canonical schema
- ✅ Skillsets must use the strict `metadata.skillset` schema
- ✅ Scripts should support both Unix (`.sh`) and Windows (`.ps1`) when applicable
- ✅ Reference files must follow `NN_TOPIC.md` naming convention

See the [Contributing Guidelines](./CONTRIBUTING.md) for complete details.

## License

See [LICENSE](./LICENSE) for details.
