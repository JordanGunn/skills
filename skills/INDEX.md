# Skill Index

> Auto-generated. Do not edit manually.
> Regenerate with: `.codex/scripts/index.sh`

---

## Quick Reference

| Skill | Path | Type |
|-------|------|------|
| `doctor` | `doctor/` | skillset |
| `doctor-exam` | `doctor/exam/` | member |
| `doctor-intake` | `doctor/intake/` | member |
| `doctor-treatment` | `doctor/treatment/` | member |
| `doctor-triage` | `doctor/triage/` | member |
| `mimic` | `mimic/` | standalone |
| `plan-create` | `plan/create/` | member |
| `plan-exec` | `plan/exec/` | member |
| `plan` | `plan/` | skillset |
| `plan-status` | `plan/status/` | member |
| `refactor-dictionaries` | `refactor/dictionaries/` | member |
| `refactor-import-hygiene` | `refactor/import-hygiene/` | member |
| `refactor-inline-complexity` | `refactor/inline-complexity/` | member |
| `refactor-lexical-ontology` | `refactor/lexical-ontology/` | member |
| `refactor-module-stutter` | `refactor/module-stutter/` | member |
| `refactor` | `refactor/` | skillset |
| `refactor-semantic-noise` | `refactor/semantic-noise/` | member |
| `refactor-squatters` | `refactor/squatters/` | member |
| `refactor-structural-duplication` | `refactor/structural-duplication/` | member |
| `wizard-banish` | `wizard/wizard-banish/` | member |
| `wizard` | `wizard/` | skillset |

---

## Skillsets

### `doctor`

**Path:** `doctor/`
> Orchestrator skill for the `doctor` skillset. A diagnostic protocol that

**Members:** `doctor-intake`, `doctor-triage`, `doctor-exam`, `doctor-treatment`
**Default Pipeline:** doctor-intake doctor-triage-doctor-exam>doctor-treatment

#### Members

- **`doctor-exam`** — Conduct a focused, evidence-driven examination of ONE triaged suspect area.
- **`doctor-intake`** — Convert the user's raw description into a clinically precise intake note
- **`doctor-treatment`** — Produce a treatment note that combines diagnosis, confidence, supporting
- **`doctor-triage`** — Perform breadth-first hypothesis surfacing and prioritization across all

---

### `plan`

**Path:** `plan/`
> Orchestrator skill for the `plan` skillset. Dispatches to member skills in a safe, predictable order

**Members:** `plan-create`, `plan-exec`, `plan-status`
**Default Pipeline:** plan-create plan-exec

#### Members

- **`plan-create`** — Materialize the current conversation into a new docs/planning/phase-N plan
- **`plan-exec`** — Execute an existing docs/planning/phase-N plan sequentially by completing
- **`plan-status`** — Display the execution status of a plan by parsing frontmatter metadata.

---

### `refactor`

**Path:** `refactor/`
> Orchestrator skill for the `refactor` skillset. Dispatches to member skills

**Members:** `refactor-dictionaries`, `refactor-import-hygiene`, `refactor-inline-complexity`, `refactor-lexical-ontology`, `refactor-module-stutter`, `refactor-squatters`, `refactor-semantic-noise`, `refactor-structural-duplication`
**Default Pipeline:** refactor-lexical-ontology refactor-module-stutter-refactor-squatters>refactor-semantic-noise refactor-dictionaries refactor-inline-complexity-refactor-import-hygiene>refactor-structural-duplication

#### Members

- **`refactor-dictionaries`** — Audit dictionary usage against the Dictionary Usage Doctrine.
- **`refactor-import-hygiene`** — Audit Python imports to preserve semantic context and prevent shadowing after refactors.
- **`refactor-inline-complexity`** — Audit inline complexity and recommend variable extraction.
- **`refactor-lexical-ontology`** — Audit identifiers and namespaces for lexical-semantic and ontological correctness.
- **`refactor-module-stutter`** — Detect module/package name stutter in Python public APIs.
- **`refactor-semantic-noise`** — Audit semantic noise and namespace integrity.
- **`refactor-squatters`** — Detect squatters: modules and packages that occupy namespace positions
- **`refactor-structural-duplication`** — Identify structurally duplicate logic (pipeline-spine duplication) across semantically distinct modu

---

### `wizard`

**Path:** `wizard/`
> Orchestrator skill for the `wizard` skillset. A deterministic, idempotent

**Members:** `wizard-banish`

#### Members

- **`wizard-banish`** — Safety knob for the wizard skillset. Forcefully removes all wizard state

---

## Standalone Skills

### `mimic`

**Path:** `mimic/`
> Persona overlay skill. Applies stylistic transforms to prose output.

**Keywords:** `mimic`, `persona`, `overlay`

---

## Keyword Index

| Keyword | Skills |
|---------|--------|
| `abstraction` | `refactor-structural-duplication` |
| `agent` | `refactor-lexical-ontology` |
| `approval` | `doctor-treatment` |
| `artifact` | `refactor-lexical-ontology` |
| `axis violation` | `refactor-squatters` |
| `banish` | `wizard`, `wizard-banish` |
| `belief` | `doctor-intake` |
| `boundary` | `refactor-semantic-noise` |
| `breadth` | `doctor-triage` |
| `capture` | `doctor-intake` |
| `collision` | `refactor-import-hygiene` |
| `common` | `refactor-squatters` |
| `complete` | `plan-exec` |
| `complexity` | `refactor-inline-complexity` |
| `confidence` | `doctor-treatment` |
| `confirm` | `doctor-exam` |
| `convention` | `refactor-lexical-ontology` |
| `dataclass` | `refactor-dictionaries` |
| `decision` | `wizard` |
| `destroy` | `wizard-banish` |
| `diagnosis` | `doctor-treatment` |
| `dictionary` | `refactor-dictionaries` |
| `dict` | `refactor-dictionaries` |
| `draft` | `plan-create` |
| `drift` | `refactor-structural-duplication` |
| `duplication` | `refactor-structural-duplication` |
| `evidence` | `doctor-exam` |
| `exam` | `doctor-exam` |
| `execute` | `plan-exec` |
| `extraction` | `refactor-inline-complexity`, `refactor-structural-duplication` |
| `falsify` | `doctor-exam` |
| `flatten` | `refactor-inline-complexity` |
| `focused` | `doctor-exam` |
| `from import` | `refactor-import-hygiene` |
| `handoff` | `plan-exec` |
| `helpers` | `refactor-squatters` |
| `homeless concept` | `refactor-squatters` |
| `hypothesis` | `doctor-exam`, `doctor-triage` |
| `import` | `refactor-import-hygiene` |
| `imports` | `refactor-import-hygiene` |
| `intake` | `doctor-intake` |
| `integrity` | `refactor-squatters` |
| `intermediate` | `refactor-inline-complexity` |
| `investigation` | `doctor-exam` |
| `layer bleeding` | `refactor-squatters` |
| `lexical` | `refactor-lexical-ontology` |
| `likelihood` | `doctor-triage` |
| `mimic` | `mimic` |
| `misplaced` | `refactor-squatters` |
| `module` | `refactor-module-stutter` |
| `namespace` | `refactor-import-hygiene`, `refactor-semantic-noise`, `refactor-squatters` |
| `naming` | `refactor-lexical-ontology`, `refactor-module-stutter` |
| `nested` | `refactor-inline-complexity` |
| `noise` | `refactor-semantic-noise` |
| `normalize` | `doctor-intake` |
| `observation` | `doctor-intake` |
| `ontology` | `refactor-lexical-ontology` |
| `options` | `doctor-treatment` |
| `overlay` | `mimic` |
| `package` | `refactor-module-stutter` |
| `persona` | `mimic` |
| `phase` | `plan-create`, `plan-exec` |
| `pipeline` | `refactor-structural-duplication` |
| `planning` | `plan-create` |
| `plan` | `plan-create`, `plan-exec`, `plan-status` |
| `prefix` | `refactor-module-stutter`, `refactor-semantic-noise` |
| `prioritization` | `doctor-triage` |
| `process` | `refactor-lexical-ontology` |
| `progress` | `plan-status` |
| `proposal` | `doctor-treatment` |
| `public API` | `refactor-dictionaries`, `refactor-module-stutter` |
| `readability` | `refactor-inline-complexity` |
| `redundant` | `refactor-module-stutter`, `refactor-semantic-noise` |
| `refusal` | `wizard` |
| `reset` | `wizard-banish` |
| `risk` | `doctor-treatment` |
| `roman numerals` | `plan-exec` |
| `safety` | `wizard-banish` |
| `semantic diffusion` | `refactor-squatters` |
| `semantic` | `refactor-lexical-ontology`, `refactor-semantic-noise` |
| `session` | `wizard` |
| `shadowing` | `refactor-import-hygiene` |
| `sibling` | `refactor-squatters` |
| `sketch` | `plan-create` |
| `skill-creation` | `wizard` |
| `spine` | `refactor-structural-duplication` |
| `squatters` | `refactor-squatters` |
| `status` | `plan-status` |
| `structural` | `refactor-structural-duplication` |
| `stutter` | `refactor-module-stutter`, `refactor-squatters` |
| `sub-plan` | `plan-create`, `plan-exec` |
| `sub-plans` | `plan-create` |
| `subtask` | `plan-create`, `plan-exec` |
| `subtasks` | `plan-create`, `plan-exec` |
| `suffix` | `refactor-lexical-ontology`, `refactor-semantic-noise` |
| `symbol` | `refactor-import-hygiene` |
| `symptoms` | `doctor-intake` |
| `task file` | `plan-exec` |
| `task` | `plan-create`, `plan-exec` |
| `tasks` | `plan-create`, `plan-exec` |
| `taxonomy` | `refactor-semantic-noise` |
| `tracking` | `plan-status` |
| `treatment` | `doctor-treatment` |
| `triage` | `doctor-triage` |
| `TypedDict` | `refactor-dictionaries` |
| `type safety` | `refactor-dictionaries` |
| `typing` | `refactor-dictionaries` |
| `unification` | `refactor-structural-duplication` |
| `utility dump` | `refactor-squatters` |
| `utils` | `refactor-squatters` |
| `variable` | `refactor-inline-complexity` |
| `witness` | `doctor-intake` |
| `wizard` | `wizard`, `wizard-banish` |
| `wrong home` | `refactor-squatters` |
| `zones` | `doctor-triage` |
