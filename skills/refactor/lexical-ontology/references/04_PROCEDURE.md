# Procedure

## Step 1 — Select scope

- Default: changed files only (diff/PR)
- Else: one package subtree

## Step 2 — Build an identifier inventory

Collect names from:

- directories / packages
- modules / files
- classes / types
- functions / methods
- exported/public API identifiers
- key domain nouns (plan, policy, rule, etc.)

## Step 3 — Infer implied role from the name

Heuristics:

- suffix/pattern: `-er/-or/-ist` => Agent/Tool
- gerund `-ing` => Process
- plural collection `rules`, `policies`, `constraints` => Collection/RuleSet
- `Client`, `Repository`, `Adapter` => Instrument/Boundary
- `Model`, `Schema` => Artifact/Type

Record: (name, implied_role, scope, public?)

## Step 4 — Infer actual role from usage/contents

- Directories: what dominates inside? agents? rules? pure helpers?
- Classes: does it hold state? orchestrate? represent data?
- Functions: does it perform action? return entity? mutate?
- Modules: mostly types? mostly behavior? mostly glue?

Record: (actual_role, evidence)

## Step 5 — Flag misalignments

Flag categories:
A) Ontological category error  
   Name claims wrong kind of thing (agent package containing rules, etc.)

B) Lexical-semantic mismatch  
   Morphology implies role not supported (e.g., `planner/` contains no planners)

C) Semantic role ambiguity  
   `Manager/Util/Service` hiding role; or both artifact and process mixed

D) Namespace integrity erosion  
   Names repeating what structure should express; stutter imports

## Step 6 — Propose fixes (minimal-first)

For each finding:

- Provide 1–3 candidate renames
- Choose a recommended option
- Note breakage risk and migration approach
- Prefer moves only if repeated pattern justifies it

## Step 7 — Produce report

Output per `05_OUTPUT.md`.
