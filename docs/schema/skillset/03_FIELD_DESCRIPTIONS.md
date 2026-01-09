# Field Descriptions
### `name` (required)
- **Type:** String
- **Purpose:** Skillset identifier
- **Convention:** Should match the skill's `name` field
### `schema_version` (required)
- **Type:** Integer
- **Current Value:** `1`
- **Purpose:** Schema version for future evolution
### `skills` (required)
- **Type:** Array of strings
- **Purpose:** List of member skill names
- **Example:** `["plan-create", "plan-exec", "plan-status"]`
### `resources` (optional)
- **Type:** Object
- **Purpose:** Define shared resources for member skills
- **Fields:**
  - `root`: Directory path (e.g., `.resources`)
  - `assets`: Array of asset file paths
  - `scripts`: Array of script file paths
  - `references`: Array of reference file paths
### `pipelines` (required)
- **Type:** Object
- **Purpose:** Define how skills can be executed
- **Fields:**
  - `default`: Array defining default execution order
  - `allowed`: Array of arrays defining valid skill sequences
### `requires` (optional)
- **Type:** Array of strings
- **Purpose:** Dependencies (implementation TBD)
- **Future Use:** System packages, environment variables, etc.
### Complete Example - Skillset
```yaml
---
name: plan
description: >
  Orchestrator skill for the `plan` skillset. Dispatches to member skills 
  in a safe, predictable order.
metadata:
  author: Jordan Godau
  version: 0.1.0
  # Strict structure (convention). Agents/tools may parse this.
  skillset:
    name: plan
    schema_version: 1
    skills:
      - plan-create
      - plan-exec
      - plan-status
    # Shared resources directory for skillset assets, scripts, and references
    resources:
      root: .resources
      assets: 
        - example.txt
        - another-example.json
      scripts: 
        - example.sh
        - another-example.ps1
      references: 
        - DEFINITIONS.md
        - FRONTMATTER.md
    # Chaining defaults/rules
    pipelines:
      default:
        - plan-create
        - plan-exec
      allowed:
        - [plan-exec]
        - [plan-create]
        - [plan-status]
        - [plan-create, plan-exec]
    # Dependencies assumed or provisioned (implementation TBD)
    requires: []
---
```
### Pipeline Patterns
#### Sequential Pipeline
Skills must run in order (one depends on the previous):
```yaml
pipelines:
  default:
    - skill-one
    - skill-two
    - skill-three
  allowed:
    - [skill-one, skill-two, skill-three]
    - [skill-one, skill-two]
    - [skill-one]
```
#### Flexible Pipeline
Skills can run in any combination:
```yaml
pipelines:
  default:
    - skill-a
    - skill-b
  allowed:
    - [skill-a]
    - [skill-b]
    - [skill-a, skill-b]
    - [skill-b, skill-a]
```
#### Grouped Pipeline
Skills organized into logical groups:
```yaml
pipelines:
  default:
    - naming-one
    - naming-two
    - hygiene-one
    - hygiene-two
  allowed:
    - [naming-one, naming-two]      # Naming group
    - [hygiene-one, hygiene-two]    # Hygiene group
    - [naming-one]                  # Individual skills
    - [naming-two]
    - [hygiene-one]
    - [hygiene-two]
```
### Shared Resources Structure
When using shared resources, organize them in a `.resources` directory:
```text
skillset-name/
├── SKILL.md                        # Skillset orchestrator
├── .resources/                     # Shared resources
│   ├── assets/
│   │   └── diagram.png
│   ├── scripts/
│   │   └── utility.sh
│   └── references/
│       ├── TAXONOMY.md             # Shared terminology
│       └── TEMPLATES.md            # Shared templates
├── member-one/
│   ├── SKILL.md
│   ├── references/
│   └── scripts/
└── member-two/
    ├── SKILL.md
    ├── references/
    └── scripts/
```
---
