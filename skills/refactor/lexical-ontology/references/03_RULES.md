# Rules

## R0: Prefer ontology over vibes

Identifiers must encode the ontology (what it *is*), not the implementation detail.

## R1: Namespace carries taxonomy

Do not force names to repeat structure.

- Prefer `planning/plan.py` over `plan_planning.py`.
- Prefer `validation/rules.py` over `validation_rules_rules.py`.

## R2: Module/package naming (default stance)

- **Packages/directories**: use **domain nouns** (or stable topic nouns).
  - ✅ `planning/`, `auth/`, `gitlab/`, `validation/`, `policies/`
  - ⚠️ Avoid agentive directory names unless the package is *primarily* an agent type:
    - ❌ `planner/` if it contains planning logic, schemas, helpers, rules
    - ✅ `planner/` only if it primarily contains concrete planner agents + orchestration

If a directory is about the activity, prefer `planning/` not `planner/`.

## R3: Class naming

- Classes should be **count nouns** (instanceable entities/agents/tools).
  - ✅ `Planner`, `Plan`, `ValidationReport`, `RuleSet`
- If the class is a *process coordinator*, agentive is fine:
  - ✅ `Planner`, `Scheduler`, `Validator`
- If it’s *pure logic*, prefer neutral nouns:
  - ✅ `PlanningRules`, `PlanBuilder`, `PlanCompiler`

## R4: Function/method naming

- Functions should typically be **verbs** or verb phrases:
  - ✅ `plan_route()`, `validate_polygon()`, `compile_plan()`
- Avoid meaningless accessor verbs unless semantically distinct:
  - ❌ `get_plan()` if it just returns `plan`
  - ✅ `load_plan()`, `fetch_plan()`, `derive_plan()`

## R5: Morphology cues (lexical semantics)

- `-er/-or/-ist` implies **agent/tool**.
  - If the target is not an agent/tool, flag as misalignment.
- `-ing` implies **process**.
  - If the target is a stable artifact/entity, flag it.
- `Manager/Handler/Service/Util` are role-weak.
  - If used, require a clear scoped noun (e.g., `GitLabClient`, `PlanRepository`).

## R6: Semantic role consistency

For each identifier, assign exactly one primary role:

- Artifact/Entity, Process, Agent, Instrument/Tool, Rule/Constraint, Collection/Registry
If the implied role conflicts with usage/contents, flag it.

## R7: Fix strategy priority (minimal breakage)

1) Rename leaf identifiers (variables, functions, classes) when local
2) Introduce aliases/exports for public API stability
3) Rename modules/files (requires import updates)
4) Restructure directories only for repeated, systemic misalignment
