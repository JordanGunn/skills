# Procedure

## Step 1: Inventory candidate pipelines

For each candidate module/function:
- Identify its stages in order (write as a list).
- Note data model boundaries (inputs, outputs).
- Note concurrency/distribution boundaries (chunks, partitions, delayed tasks, map_blocks, reduce trees).

Deliverable: a “pipeline skeleton” per candidate.

## Step 2: Match pipeline spines

Compare skeletons and find common subsequences.
Flag duplication when:
- 3+ stages match in order, AND
- the shared stages are infrastructure (shape/bounds/chunk/reduction/wrap), not domain logic.

Deliverable: a duplication matrix mapping modules to shared spine segments.

## Step 3: Identify the minimal abstraction seam

For each duplication group:
- Determine what differs (the operator).
- Propose the smallest seam that can be parameterized (strategy/hook).

Hard rule:
- Do NOT introduce a generic abstraction that erases domain meaning.
- Prefer a small seam + shared kernel.

Deliverable: seam definition(s) including:
- strategy names + responsibilities
- minimal inputs/outputs
- where it plugs into the spine

## Step 4: Choose kernel resting place

Check for existing internal modules that already host similar mechanics.
If none exist, propose a new kernel module named after the mechanism.

Deliverable: “kernel target” recommendation with justification.

## Step 5: Decide whether subtle abstraction is required

If unification requires:

- changing function signatures,
- introducing a strategy object/protocol,
- normalizing nodata policies,
- aligning chunk semantics,
- or adding shared helpers for validation/postprocess,

then subtle abstraction is required.

Deliverable: include a staged plan (see template) that is safe and incremental.

## Step 6: Emit report

Use the output template.
Be explicit about:

- what stays separate (domain boundary)
- what becomes shared (spine/kernels)
- what changes (seams)
- risks and ordering
