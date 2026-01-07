# Intent

> Identifiers must encode ontology, not behavior.
> Derivation implies agency. Agency must be explicit.

---

Enforce *meaningful, role-consistent naming* by aligning identifiers with:

1) **Ontology**  
   Names must correctly express *what kind of thing* the target is in the system.

2) **Lexical Semantics**  
   Morphology implies meaning:
   - `-er/-or/-ist` often implies **agent** (doer) or **instrument** (tool)
   - `-ing` often implies **process/activity**
   - bare noun often implies **artifact/entity**
   Misuse causes cognitive and architectural drift.

3) **Semantic Role Alignment**  
   Every identifier should imply (and match) one dominant role:
   - **Entity/Artifact** (a thing/data/object) — `plan`, `policy`, `report`
   - **Process** (an activity) — `planning`, `validation`, `compaction`
   - **Agent** (actor that performs) — `planner`, `validator`, `scheduler`
   - **Instrument/Tool** (means for performing) — `planner` (tool), `validator` (tool)
   - **Rule/Constraint** — `rules`, `constraints`, `policy`

The audit aims to reduce:

- category errors (module named as agent but contains process or artifacts)
- derivational mismatch (agentive names without actual agency)
- namespace erosion (names repeating or compensating for missing structure)

Deliverable: a single Markdown report with findings + minimal safe renames + refactor options.
