# Skills Reference

This document provides a comprehensive reference of all individual skills available in this repository. For information about skillsets (orchestrator skills), see [Skillsets Documentation](./SKILLSETS.md).

> **Note:** This is a curated view of skills from the auto-generated [Skill Index](../skills/.INDEX.md). The index includes additional metadata like keywords and pipelines.

---

## Doctor Skills

Diagnostic protocol skills using a medical-model approach for software failures.

### `doctor-exam`

**Path:** `doctor/exam/`

Conduct a focused, evidence-driven examination of ONE triaged suspect area.

**Keywords:** `exam`, `evidence`, `focused`, `investigation`, `confirm`, `falsify`, `hypothesis`

---

### `doctor-intake`

**Path:** `doctor/intake/`

Convert the user's raw description into a clinically precise intake note.

**Keywords:** `intake`, `capture`, `normalize`, `observation`, `symptoms`, `witness`, `belief`

---

### `doctor-treatment`

**Path:** `doctor/treatment/`

Produce a treatment note that combines diagnosis, confidence, supporting evidence, and actionable options.

**Keywords:** `treatment`, `diagnosis`, `proposal`, `options`, `confidence`, `risk`, `approval`

---

### `doctor-triage`

**Path:** `doctor/triage/`

Perform breadth-first hypothesis surfacing and prioritization across all suspect zones.

**Keywords:** `triage`, `hypothesis`, `breadth`, `prioritization`, `likelihood`, `zones`

---

## Markdown Skills

Skills for chunking and processing markdown documents.

### `md-split`

**Path:** `md/split/`

Splits a Markdown file by H2 headings into numbered documents, generates an index, and creates summaries.

**Keywords:** `markdown`, `split`, `chunking`, `docs`, `index`, `summary`

---

## Mimic Skills

Standalone persona overlay skills.

### `mimic`

**Path:** `mimic/`

Persona overlay skill. Applies stylistic transforms to prose output.

**Keywords:** `mimic`, `persona`, `overlay`

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

## Prompt Skills

Skills for shaping and executing human intent into stable prompts.

### `prompt-forge`

**Path:** `prompt/forge/`

Shape, refine, and stabilize human intent into a canonical prompt artifact before execution.

**Keywords:** `prompt`, `forge`, `shape`, `refine`, `stabilize`, `intent`, `draft`, `formulate`, `clarify`

---

### `prompt-exec`

**Path:** `prompt/exec/`

Execute the forged prompt exactly as written, with no reinterpretation.

**Keywords:** `prompt`, `execute`, `confirm`, `proceed`, `go`, `run`

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

Detect squatters: modules and packages that occupy namespace positions without proper semantic justification.

**Keywords:** `squatters`, `namespace`, `integrity`, `misplaced`, `utility dump`, `utils`, `helpers`, `common`, `wrong home`, `axis violation`, `homeless concept`, `layer bleeding`, `semantic diffusion`, `sibling`, `stutter`

**References:**
- `01_GOAL.md`
- `02_DEFINITIONS.md`
- `03_INVARIANTS.md`
- `04_SCOPE.md`
- `05_CHECKS.md`
- `06_OUTPUT.md`

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

## Task Skills

Task lifecycle management skills for creating, validating, and tracking tasks.

### `task-activate`

**Path:** `task/activate/`

Activate a task by setting lifecycle_state to active. Refuses activation if epistemic_state is not validated.

**Keywords:** `task`, `activate`, `enable`, `start`, `run`, `begin`

---

### `task-create`

**Path:** `task/create/`

Create a new task directory with 00_TASK.md from template.

**Keywords:** `task`, `create`, `new`, `initialize`, `init`, `start`, `begin`

---

### `task-invalidate`

**Path:** `task/invalidate/`

Invalidate a task by setting epistemic_state to invalidated. Requires a reason.

**Keywords:** `task`, `invalidate`, `cancel`, `revoke`, `obsolete`, `supersede`

---

### `task-list`

**Path:** `task/list/`

List tasks from a root directory with optional filters. Supports filtering by lifecycle_state, epistemic_state, and staleness.

**Keywords:** `task`, `list`, `show`, `find`, `filter`, `search`

---

### `task-next`

**Path:** `task/next/`

Navigate to the next task in chronological order. Returns the task ID and path.

**Keywords:** `task`, `next`, `forward`, `navigate`

---

### `task-prev`

**Path:** `task/prev/`

Navigate to the previous task in chronological order. Returns the task ID and path.

**Keywords:** `task`, `prev`, `previous`, `back`, `navigate`

---

### `task-review`

**Path:** `task/review/`

Review a task by updating last_reviewed_at timestamp. Recomputes derived status for freshness tracking.

**Keywords:** `task`, `review`, `inspect`, `check`, `refresh`, `update`

---

### `task-status`

**Path:** `task/status/`

Compute and display derived status for a task. Runs deterministic status checks without modifying the task.

**Keywords:** `task`, `status`, `info`, `check`, `display`, `show`

---

### `task-validate`

**Path:** `task/validate/`

Validate a task by setting epistemic_state to validated. Requires explicit human approval.

**Keywords:** `task`, `validate`, `verify`, `confirm`, `approve`, `validation`

---

## Keyword Index

For a complete and up-to-date keyword index, see the [auto-generated Skill Index](../skills/.INDEX.md).

The keyword index maps common terms to relevant skills, making it easy to discover skills based on the task you need to accomplish. Each skill includes keywords in its frontmatter that describe its purpose and functionality.

---

## See Also

- [Skillsets Documentation](./SKILLSETS.md) - Learn about orchestrator skills
- [Auto-generated Skill Index](../skills/.INDEX.md) - Complete index with keywords and pipelines
- [Schema Documentation](./schema/skill/01_OVERVIEW.md) - Understand skill structure
