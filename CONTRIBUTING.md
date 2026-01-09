# Contributing Guidelines

Thank you for your interest in contributing to the Agent Skills repository! This document provides guidelines for adding new skills and skillsets to this collection.

---

## Table of Contents

1. [Before You Start](#before-you-start)
2. [Adding Individual Skills](#adding-individual-skills)
3. [Adding Skillsets](#adding-skillsets)
4. [Schema Requirements](#schema-requirements)
5. [Testing Your Contribution](#testing-your-contribution)
6. [Submission Process](#submission-process)

---

## Before You Start

### Review Existing Skills

Before creating a new skill:
1. Check the [Skills Reference](./docs/SKILLS.md) to avoid duplication
2. Review similar skills to understand patterns and conventions
3. Read the [Schema Documentation](./docs/schema/SKILL.md) to understand structure

### Understand the Philosophy

Skills in this repository are designed to:
- **Prevent common issues** in agentic programming sessions
- **Provide clear guidance** with structured instructions
- **Enable progressive disclosure** through reference files
- **Support automation** through executable scripts
- **Maintain independence** while allowing composition

---

## Adding Individual Skills

### Step 1: Choose a Category

Organize your skill into an appropriate category directory:
- `adapter/` - IDE and tool integrations
- `index/` - Discovery and cataloging
- `plan/` - Planning and execution
- `refactor/` - Code quality and improvements
- Or create a new category if needed

### Step 2: Create Directory Structure

```bash
category/
└── your-skill-name/
    ├── SKILL.md              # Required: Frontmatter only
    ├── references/           # Required: Detailed documentation
    │   ├── 00_INSTRUCTIONS.md
    │   ├── 01_INTENT.md
    │   └── 02_PROCEDURE.md
    └── scripts/              # Optional: Executable scripts
        ├── script.sh         # Unix/macOS/Linux
        └── script.ps1        # Windows PowerShell
```

### Step 3: Create SKILL.md

**Important:** `SKILL.md` must contain **only frontmatter** - no Markdown body content.

```yaml
---
name: your-skill-name
license: MIT
description: >
  Clear description of what this skill does and when to use it.
  Include specific keywords that help agents identify relevant tasks.
metadata:
  author: Your Name or Organization
  version: 0.1.0
  references:
    - 00_INSTRUCTIONS.md
    - 01_INTENT.md
    - 02_PROCEDURE.md
  scripts:
    - script.sh
    - script.ps1
  keywords:
    - keyword1
    - keyword2
    - keyword3
---
```

#### Required Fields

- **`name`**: Lowercase with hyphens only, must match directory name
- **`description`**: 1-1024 characters, describes purpose and usage triggers

#### Recommended Metadata

- **`author`**: Your name or organization
- **`version`**: Semantic version (start with `0.1.0`)
- **`references`**: List all reference files in order
- **`scripts`**: List all script files (both `.sh` and `.ps1`)
- **`keywords`**: Improve discoverability (5-10 keywords recommended)

### Step 4: Write Reference Files

Create focused documentation in the `references/` directory:

#### Naming Convention
- Format: `NN_TOPIC.md`
- `NN`: Zero-padded number (00, 01, 02, ...)
- `TOPIC`: Uppercase with underscores (e.g., `INTENT`, `PROCEDURE`)

#### Recommended Structure
1. **00_INSTRUCTIONS.md** - Quick overview and signals
2. **01_INTENT.md** - Purpose and goals
3. **02_PRECONDITIONS.md** - Requirements and setup
4. **03_PROCEDURE.md** - Step-by-step instructions
5. **04_OUTPUT.md** - Expected results

Add more as needed, but keep each file focused on one topic.

### Step 5: Add Scripts (Optional)

If your skill includes automation:

#### Cross-Platform Support
Provide both Unix and Windows versions:
- `script-name.sh` for macOS/Linux/WSL
- `script-name.ps1` for Windows PowerShell

#### Script Requirements
- **Self-contained**: Document all dependencies
- **Error handling**: Provide helpful error messages
- **Exit codes**: Use 0 for success, non-zero for errors
- **Comments**: Explain complex logic
- **Permissions**: Make `.sh` files executable

#### Example Script Header

**Bash:**
```bash
#!/usr/bin/env bash
# Description: Brief description of what this script does
# Requirements: git, jq
# Usage: ./script-name.sh [args]

set -euo pipefail
```

**PowerShell:**
```powershell
# Description: Brief description of what this script does
# Requirements: git, PowerShell 5.1+
# Usage: .\script-name.ps1 [args]

$ErrorActionPreference = "Stop"
```

### Step 6: Update Documentation

1. **Add to README** - Include your skill in the appropriate section
2. **Regenerate INDEX** - Run `./scripts/index/index.sh` or `.\scripts\index\index.ps1`
3. **Update Skills Reference** - Add entry to `docs/SKILLS.md`

---

## Adding Skillsets

### When to Create a Skillset

Create a skillset when:
- You have **multiple related skills** that work together
- Skills follow a **recommended execution order**
- Skills **share common resources** or terminology
- You want to **signal grouping** to agents and users

### Step 1: Create Member Skills

First, create all member skills following the [Individual Skills](#adding-individual-skills) guidelines. Each member must be a complete, independent skill.

### Step 2: Create Skillset Directory

```bash
category/
├── SKILL.md                   # Skillset orchestrator
├── .resources/                # Shared resources (optional)
│   └── references/
│       ├── TAXONOMY.md
│       └── TEMPLATES.md
├── member-one/
│   └── SKILL.md
└── member-two/
    └── SKILL.md
```

### Step 3: Create Skillset SKILL.md

Add the `metadata.skillset` field with the strict schema:

```yaml
---
name: your-skillset-name
description: >
  Orchestrator skill for the `your-skillset-name` skillset. 
  Dispatches to member skills for [purpose].
metadata:
  author: Your Name
  version: 0.1.0

  # Strict structure (convention). Agents/tools may parse this.
  skillset:
    name: your-skillset-name
    schema_version: 1
    skills:
      - member-skill-one
      - member-skill-two
      - member-skill-three

    # Shared resources directory (optional)
    resources:
      root: .resources
      assets: []
      scripts: []
      references: 
        - TAXONOMY.md
        - TEMPLATES.md

    # Execution pipelines
    pipelines:
      default:
        - member-skill-one
        - member-skill-two
        - member-skill-three
      allowed:
        - [member-skill-one]
        - [member-skill-two]
        - [member-skill-three]
        - [member-skill-one, member-skill-two]
        - [member-skill-one, member-skill-two, member-skill-three]

    requires: []
---
```

### Step 4: Define Pipelines

#### Default Pipeline
The recommended execution order for all member skills:
```yaml
default:
  - skill-one
  - skill-two
  - skill-three
```

#### Allowed Combinations
All valid skill execution sequences:
```yaml
allowed:
  - [skill-one]                          # Individual skills
  - [skill-two]
  - [skill-three]
  - [skill-one, skill-two]               # Partial sequences
  - [skill-one, skill-three]
  - [skill-one, skill-two, skill-three]  # Full sequence
```

**Guidelines:**
- Include the default pipeline in allowed
- Add individual skills if they can run standalone
- Document any dependencies in comments
- Consider common use cases

### Step 5: Add Shared Resources (Optional)

If member skills share common resources:

1. Create `.resources/` directory
2. Add shared reference files, assets, or scripts
3. List them in `metadata.skillset.resources`
4. Reference them from member skills as needed

**Example shared resource:**
```
.resources/
└── references/
    ├── TAXONOMY.md       # Shared terminology
    └── OUTPUT_FORMAT.md  # Standard report format
```

### Step 6: Update Documentation

1. **Add to README** - Include skillset in appropriate section
2. **Regenerate INDEX** - Run index script
3. **Add to Skillsets docs** - Update `docs/SKILLSETS.md`
4. **Document orchestration** - Explain how skills work together

---

## Schema Requirements

### Individual Skills Must:

- [ ] Use **frontmatter-only** `SKILL.md` (no body content)
- [ ] Have `name` field matching directory name
- [ ] Have `name` with lowercase and hyphens only
- [ ] Have `description` between 1-1024 characters
- [ ] List all references in `metadata.references`
- [ ] List all scripts in `metadata.scripts`
- [ ] Follow `NN_TOPIC.md` naming for reference files
- [ ] Include both `.sh` and `.ps1` scripts when possible
- [ ] Use descriptive keywords for discovery

### Skillsets Must:

- [ ] Meet all individual skill requirements
- [ ] Include `metadata.skillset` field
- [ ] Set `schema_version: 1`
- [ ] List all member skills in `skills` array
- [ ] Define `pipelines.default` execution order
- [ ] Define `pipelines.allowed` valid sequences
- [ ] Ensure member skills exist and are valid
- [ ] Keep member skills independently usable

---

## Testing Your Contribution

### Validate Structure

```bash
# Check that SKILL.md has only frontmatter
head -20 your-skill/SKILL.md

# Verify directory matches name
basename $(pwd)  # Should match the 'name' field

# Check reference files exist
ls your-skill/references/

# Check scripts are executable (Unix)
ls -l your-skill/scripts/*.sh
```

### Test Scripts

```bash
# Unix/macOS/Linux
cd your-skill
./scripts/your-script.sh

# Windows PowerShell
cd your-skill
.\scripts\your-script.ps1
```

### Regenerate Index

```bash
# Unix/macOS/Linux
./scripts/index/index.sh

# Windows PowerShell
.\scripts\index\index.ps1
```

Check that your skill appears in `INDEX.md` with correct metadata.

### Validate Schema

If available, use the skills-ref validator:
```bash
skills-ref validate ./your-skill
```

---

## Submission Process

### 1. Fork and Branch

```bash
git clone https://github.com/YourUsername/skills.git
cd skills
git checkout -b add-your-skill-name
```

### 2. Make Your Changes

- Add your skill or skillset
- Write clear, focused reference files
- Include cross-platform scripts
- Update documentation

### 3. Test Thoroughly

- Validate schema compliance
- Test all scripts
- Regenerate INDEX.md
- Review all changes

### 4. Commit with Clear Messages

```bash
git add .
git commit -m "Add skill: your-skill-name

- Purpose and description
- Key features
- References included
- Scripts for Unix and Windows"
```

### 5. Create Pull Request

- Provide clear description of the skill
- Explain when it should be used
- Document any dependencies
- Link to related issues or discussions

### Pull Request Template

```markdown
## Description
Brief description of the skill or skillset.

## Purpose
Why this skill is needed and what problems it solves.

## Type
- [ ] Individual skill
- [ ] Skillset
- [ ] Enhancement to existing skill
- [ ] Documentation update

## Testing
- [ ] SKILL.md contains only frontmatter
- [ ] All references follow naming convention
- [ ] Scripts work on target platforms
- [ ] INDEX.md regenerated
- [ ] Documentation updated

## Additional Notes
Any other relevant information.
```

---

## Style Guidelines

### Writing Style

- **Be clear and concise** - Agents should quickly understand the skill
- **Use active voice** - "Create a plan" not "A plan is created"
- **Provide examples** - Show concrete inputs and outputs
- **Explain edge cases** - Document limitations and special scenarios

### Code Style

- **Follow platform conventions** - Bash for `.sh`, PowerShell for `.ps1`
- **Use consistent indentation** - 2 or 4 spaces (be consistent)
- **Add error handling** - Check preconditions and fail gracefully
- **Write helpful messages** - Users should understand what went wrong

### Documentation Style

- **Use headers** - Organize content with clear sections
- **Include code blocks** - Show examples with syntax highlighting
- **Link related content** - Reference other skills and docs
- **Keep it updated** - Documentation should match implementation

---

## Getting Help

### Resources

- [Agent Skills Specification](./SPEC.md) - Official format spec
- [Schema Documentation](./docs/schema/SKILL.md) - Detailed schema reference
- [Skills Reference](./docs/SKILLS.md) - Examples of existing skills
- [Skillsets Documentation](./docs/SKILLSETS.md) - Orchestrator patterns

### Community

- **Issues**: Report bugs or suggest improvements
- **Discussions**: Ask questions or propose new features
- **Pull Requests**: Review others' contributions

---

## License

By contributing to this repository, you agree that your contributions will be licensed under the same license as the project (see [LICENSE](../LICENSE)).

---

Thank you for contributing to Agent Skills! Your contributions help improve agentic programming for everyone.
