# Preconditions

All preconditions must be satisfied before execution proceeds.

## Required State

### 1. Canonical artifact exists

The file `.prompt-forge/active.yaml` must exist and be valid YAML.

**If missing**: Abort with message:
> "No active prompt found. Use `prompt-forge` to create one first."

### 2. Status is ready

The artifact's `status` field must be `ready`.

**If `drafting`**: Abort with message:
> "The prompt is still in draft status. Complete refinement with `prompt-forge` first."

**If invalid/missing**: Abort with message:
> "The prompt artifact has an invalid status. Use `prompt-forge` to repair it."

### 3. User explicitly triggers execution

The user must provide an explicit execution trigger. Valid triggers include:

- "execute"
- "run this"
- "proceed"
- "go"
- "do it"
- "execute the prompt"

**If ambiguous**: Ask for explicit confirmation:
> "Do you want me to execute the forged prompt now?"

## Precondition Check Order

```text
1. Check artifact exists       → fail fast if missing
2. Parse artifact              → fail fast if invalid
3. Check status == ready       → fail fast if not ready
4. Confirm user consent        → fail fast if not explicit
5. Proceed to execution
```
