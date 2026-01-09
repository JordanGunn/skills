# Purpose

The `doctor-triage` skill performs breadth-first hypothesis surfacing across all ownership zones.

## Why Triage Matters

When symptoms appear, humans (and agents) naturally focus on the **layer where symptoms manifest**. But:

- A frontend error may be a backend timeout
- A backend timeout may be a database lock
- A database lock may be a Kubernetes resource limit
- A Kubernetes limit may be a Terraform misconfiguration

Triage exists to **prevent layer fixation** by systematically considering all zones.

## What Triage Does

1. **Enumerates** plausible causes across all ownership zones
2. **Ranks** hypotheses by likelihood
3. **Cites** lightweight evidence pointers
4. **Recommends** which suspect to examine first

## What Triage Does NOT Do

- Deep investigation (that's `doctor-exam`)
- Diagnosis (that's `doctor-treatment`)
- Fixing (that's implementation, outside protocol)

Triage produces a **prioritized hypothesis list**, not a conclusion.

## Success Criteria

A successful triage report:

- Considers ALL ownership zones (not just the obvious one)
- Has at least 3 ranked hypotheses
- Cites evidence pointers for each hypothesis
- Calls out disputed assumptions
- Recommends a clear next step (which hypothesis to examine)
