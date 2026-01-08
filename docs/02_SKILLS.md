# Skills Reference

This document provides a comprehensive reference of all individual skills available in this repository. For information about skillsets (orchestrator skills), see [Skillsets Documentation](./03_SKILLSETS.md).

> **Note:** This is a curated view of skills from the auto-generated [INDEX.md](../INDEX.md). The index includes additional metadata like keywords and pipelines.

---

## Adapter Skills

Adapter skills generate IDE and tool integrations from agent skills.

### `adapter-cursor`

**Path:** `adapter/cursor/`

Generate Cursor commands from agent skills. Creates plain markdown command files that delegate to skill references, enabling Cursor to invoke agent skills.

**Keywords:** `adapter`, `cursor`, `command`, `generate`

**Scripts:**
- `generate.sh` (macOS/Linux/WSL)
- `generate.ps1` (Windows)

---

### `adapter-windsurf`

**Path:** `adapter/windsurf/`

Generate Windsurf workflows from agent skills. Creates thin workflow adapters that point to skill references, enabling Windsurf to invoke agent skills via slash commands.

**Keywords:** `adapter`, `windsurf`, `workflow`, `generate`, `slash command`

**Scripts:**
- `generate.sh` (macOS/Linux/WSL)
- `generate.ps1` (Windows)

---

## Doctor Skills

Diagnostic protocol skills for modeling software failures as medical cases.

### `doctor-intake`

**Path:** `doctor/intake/`

Convert the user's raw description into a clinically precise intake note. First step in the doctor protocol for establishing ground truth.

**Keywords:** `intake`, `diagnosis`, `medical`, `protocol`, `investigation`, `symptoms`

**References:**
- `01_PURPOSE.md`
- `02_EPISTEMIC_STANCE.md`
- `03_BEHAVIOR.md`
- `04_OUTPUT.md`

---

### `doctor-triage`

**Path:** `doctor/triage/`

Perform breadth-first hypothesis surfacing and prioritization across all plausible failure points. Second step in the doctor protocol.

**Keywords:** `triage`, `hypothesis`, `prioritization`, `diagnosis`, `investigation`

**References:**
- `01_PURPOSE.md`
- `02_SCOPE.md`
- `03_BEHAVIOR.md`
- `04_OUTPUT.md`

**Scripts:**
- `evidence.sh` (macOS/Linux/WSL)

---

### `doctor-exam`

**Path:** `doctor/exam/`

Conduct a focused, evidence-driven examination of ONE triaged suspect area. Third step in the doctor protocol.

**Keywords:** `exam`, `examination`, `evidence`, `diagnosis`, `investigation`

**References:**
- `01_PURPOSE.md`
- `02_SCOPE.md`
- `03_BEHAVIOR.md`
- `04_OUTPUT.md`

---

### `doctor-treatment`

**Path:** `doctor/treatment/`

Produce a treatment note that combines diagnosis, confidence, supporting evidence, and multiple treatment options. Final step in the doctor protocol.

**Keywords:** `treatment`, `diagnosis`, `remediation`, `options`, `confidence`

**References:**
- `01_PURPOSE.md`
- `02_DIAGNOSIS.md`
- `03_OPTIONS.md`
- `04_OUTPUT.md`

---

## Index Skill

Skill indexing and discovery functionality.

### `index`

**Path:** `index/`

Generate a hierarchical index of all skills from SKILL.md files. Produces a Markdown index optimized for agent lookup with skillsets, member skills, keywords, and pipelines.

**Keywords:** `index`, `skill`, `skills`, `discovery`, `lookup`, `catalog`, `registry`, `skillset`, `perform`, `capability`

**Scripts:**
- `index.sh` (macOS/Linux/WSL)
- `index.ps1` (Windows)

---

## Plan Skills

Development phase management skills for creating, executing, and tracking plans.

### `plan-create`

**Path:** `plan/create/`

Materialize the current conversation into a new `docs/planning/phase-N` plan (root plan plus sub-plans and task files).

**Keywords:** `phase`, `plan`, `planning`, `task`, `draft`, `sketch`, `sub-plans`, `subtasks`

**References:**
- `00_INSTRUCTIONS.md`
- `01_INTENT.md`
- `02_PRECONDITIONS.md`
- `03_SCRIPTS.md`
- `04_PROCEDURE.md`
- `05_TEMPLATES.md`
- `06_EDGE_CASES.md`

**Scripts:**
- `dirs.sh` (macOS/Linux/WSL)
- `dirs.ps1` (Windows)

---

### `plan-exec`

**Path:** `plan/exec/`

Execute an existing `docs/planning/phase-N` plan sequentially by completing subtasks.

**Keywords:** `phase`, `plan`, `execute`, `complete`, `handoff`, `roman numerals`, `sub-plan`, `subtask`, `subtasks`, `task`, `tasks`, `task file`

**References:**
- `00_INSTRUCTIONS.md`
- `01_INTENT.md`
- `02_PRECONDITIONS.md`
- `03_RULES.md`
- `04_PROCEDURE.md`
- `05_OUTPUT.md`

---

### `plan-status`

**Path:** `plan/status/`

Display the execution status of a plan by parsing frontmatter metadata. Shows progress at-a-glance without requiring manual inspection of each file.

**Keywords:** `plan`, `status`, `progress`, `tracking`

**References:**
- `01_INTENT.md`
- `02_PROCEDURE.md`

**Scripts:**
- `status.sh` (macOS/Linux/WSL)
- `status.ps1` (Windows)

**Frontmatter Status Values:**
- `pending`: Task not yet started
- `in_progress`: Task currently being worked on
- `complete`: Task finished

---

## Refactor Skills

Code quality audit and refactoring skills for improving code structure and maintainability.

### `refactor-dictionaries`

**Path:** `refactor/dictionaries/`

Audit dictionary usage against the Dictionary Usage Doctrine. Produces a severity-grouped report with minimal refactor suggestions.

**Keywords:** `dictionary`, `dict`, `TypedDict`, `dataclass`, `type safety`, `typing`, `public API`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

---

### `refactor-import-hygiene`

**Path:** `refactor/import-hygiene/`

Audit Python imports to preserve semantic context and prevent shadowing after refactors.

**Keywords:** `import`, `imports`, `from import`, `namespace`, `collision`, `shadowing`, `symbol`

**References:**
- `01_GOAL.md`
- `02_DEFINITION.md`
- `03_RULES.md`
- `04_PROCEDURE.md`
- `05_OUTPUT.md`
- `06_EXAMPLES.md`

---

### `refactor-inline-complexity`

**Path:** `refactor/inline-complexity/`

Audit inline complexity and recommend variable extraction. Produces a report with flattening suggestions for nested expressions.

**Keywords:** `complexity`, `nested`, `inline`, `intermediate`, `variable`, `extraction`, `flatten`, `readability`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

---

### `refactor-lexical-ontology`

**Path:** `refactor/lexical-ontology/`

Audit identifiers and namespaces for lexical-semantic and ontological correctness.

**Keywords:** `lexical`, `ontology`, `semantic`, `naming`, `convention`, `agent`, `artifact`, `process`, `suffix`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

---

### `refactor-module-stutter`

**Path:** `refactor/module-stutter/`

Detect module/package name stutter in Python public APIs. Produces a Markdown report and optional CI gate.

**Keywords:** `module`, `package`, `stutter`, `naming`, `redundant`, `prefix`, `public API`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

**Scripts:**
- Various detection scripts

---

### `refactor-semantic-noise`

**Path:** `refactor/semantic-noise/`

Audit semantic noise and namespace integrity.

**Keywords:** `noise`, `semantic`, `namespace`, `boundary`, `taxonomy`, `redundant`, `prefix`, `suffix`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

---

### `refactor-squatters`

**Path:** `refactor/squatters/`

Detect squatters: modules and packages that occupy namespace positions they do not semantically own. Identifies utility dumps, stuttery siblings, axis violations, layer bleeding, and semantic diffusion.

**Keywords:** `squatters`, `namespace`, `integrity`, `wrong home`, `misplaced`, `utility dump`, `common`, `helpers`, `utils`, `stutter`, `sibling`, `axis violation`, `layer bleeding`, `semantic diffusion`, `homeless concept`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_HEURISTICS.md`
- `05_PROCEDURE.md`
- `06_REMEDIATION.md`
- `07_OUTPUT.md`

**Scripts:**
- `detect.sh` (macOS/Linux/WSL)
- `detect.ps1` (Windows)

---

### `refactor-structural-duplication`

**Path:** `refactor/structural-duplication/`

Identify structurally duplicate logic (pipeline-spine duplication) across semantically distinct modules.

**Keywords:** `structural`, `duplication`, `pipeline`, `spine`, `abstraction`, `extraction`, `unification`, `drift`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

---

## Wizard Skill

Guided sensemaking and epistemic calibration for unclear or unstable situations.

### `wizard`

**Path:** `wizard/`

Guided sensemaking and epistemic calibration when intent is unstable, terminology is inadequate, or it is unclear whether automation should exist.

**Keywords:** `wizard`, `sensemaking`, `calibration`, `discovery`, `epistemic`, `intent`, `taxonomy`, `refusal`

**References:**
- `00_INSTRUCTIONS.md`
- `01_INTENT.md`
- `02_TAXONOMY.md`
- `03_PROTOCOL.md`
- `04_WORKING_MODEL.md`
- `05_TERMINAL_OUTCOMES.md`
- `06_ANTI_SKILLS.md`
- `07_INTERACTION.md`

---

## Keyword Index

Use keywords to quickly find relevant skills:

| Keyword | Skills |
|---------|--------|
| `abstraction` | `refactor-structural-duplication` |
| `adapter` | `adapter-cursor`, `adapter-windsurf` |
| `agent` | `refactor-lexical-ontology` |
| `artifact` | `refactor-lexical-ontology` |
| `boundary` | `refactor-semantic-noise` |
| `capability` | `index` |
| `catalog` | `index` |
| `collision` | `refactor-import-hygiene` |
| `command` | `adapter-cursor` |
| `complete` | `plan-exec` |
| `complexity` | `refactor-inline-complexity` |
| `convention` | `refactor-lexical-ontology` |
| `cursor` | `adapter-cursor` |
| `dataclass` | `refactor-dictionaries` |
| `dictionary` | `refactor-dictionaries` |
| `dict` | `refactor-dictionaries` |
| `discovery` | `index` |
| `draft` | `plan-create` |
| `drift` | `refactor-structural-duplication` |
| `duplication` | `refactor-structural-duplication` |
| `execute` | `plan-exec` |
| `extraction` | `refactor-inline-complexity`, `refactor-structural-duplication` |
| `flatten` | `refactor-inline-complexity` |
| `from import` | `refactor-import-hygiene` |
| `generate` | `adapter-cursor`, `adapter-windsurf` |
| `handoff` | `plan-exec` |
| `import` | `refactor-import-hygiene` |
| `imports` | `refactor-import-hygiene` |
| `index` | `index` |
| `intermediate` | `refactor-inline-complexity` |
| `lexical` | `refactor-lexical-ontology` |
| `lookup` | `index` |
| `module` | `refactor-module-stutter` |
| `namespace` | `refactor-import-hygiene`, `refactor-semantic-noise` |
| `naming` | `refactor-lexical-ontology`, `refactor-module-stutter` |
| `nested` | `refactor-inline-complexity` |
| `noise` | `refactor-semantic-noise` |
| `ontology` | `refactor-lexical-ontology` |
| `package` | `refactor-module-stutter` |
| `perform` | `index` |
| `phase` | `plan-create`, `plan-exec` |
| `pipeline` | `refactor-structural-duplication` |
| `planning` | `plan-create` |
| `plan` | `plan-create`, `plan-exec`, `plan-status` |
| `prefix` | `refactor-module-stutter`, `refactor-semantic-noise` |
| `process` | `refactor-lexical-ontology` |
| `progress` | `plan-status` |
| `public API` | `refactor-dictionaries`, `refactor-module-stutter` |
| `readability` | `refactor-inline-complexity` |
| `redundant` | `refactor-module-stutter`, `refactor-semantic-noise` |
| `registry` | `index` |
| `roman numerals` | `plan-exec` |
| `semantic` | `refactor-lexical-ontology`, `refactor-semantic-noise` |
| `shadowing` | `refactor-import-hygiene` |
| `sketch` | `plan-create` |
| `skill` | `index` |
| `skills` | `index` |
| `slash command` | `adapter-windsurf` |
| `spine` | `refactor-structural-duplication` |
| `status` | `plan-status` |
| `structural` | `refactor-structural-duplication` |
| `stutter` | `refactor-module-stutter` |
| `sub-plan` | `plan-create`, `plan-exec` |
| `sub-plans` | `plan-create` |
| `subtask` | `plan-create`, `plan-exec` |
| `subtasks` | `plan-create`, `plan-exec` |
| `suffix` | `refactor-lexical-ontology`, `refactor-semantic-noise` |
| `symbol` | `refactor-import-hygiene` |
| `task file` | `plan-exec` |
| `task` | `plan-create`, `plan-exec` |
| `tasks` | `plan-create`, `plan-exec` |
| `taxonomy` | `refactor-semantic-noise` |
| `tracking` | `plan-status` |
| `TypedDict` | `refactor-dictionaries` |
| `type safety` | `refactor-dictionaries` |
| `typing` | `refactor-dictionaries` |
| `unification` | `refactor-structural-duplication` |
| `variable` | `refactor-inline-complexity` |
| `windsurf` | `adapter-windsurf` |
| `workflow` | `adapter-windsurf` |

---

## See Also

- [Skillsets Documentation](./03_SKILLSETS.md) - Learn about orchestrator skills
- [Auto-generated INDEX.md](../INDEX.md) - Complete index with pipelines
- [Schema Documentation](./04_SCHEMAS.md) - Understand skill structure
