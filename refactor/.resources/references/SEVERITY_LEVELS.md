# Severity Levels (Shared)

All refactor skills use consistent severity classification:

## Blockers

Issues that **must** be addressed before merge or release:

- Public API violations that will propagate
- Type safety holes that break downstream consumers
- Naming collisions or shadowing that cause runtime errors

## Strongly Recommended

Issues that **should** be addressed but are not blocking:

- Internal API quality issues
- Readability concerns that affect maintainability
- Convention violations that increase cognitive load
- Drift risks between parallel implementations

## Suggestions / Informational

Issues that **may** be addressed at discretion:

- Style preferences within acceptable bounds
- Optimizations with marginal benefit
- Acceptable uses that were reviewed and confirmed safe
- Future refactor candidates (not urgent)

## Severity Assignment Heuristic

1. Does it break callers or downstream code? → **Blocker**
2. Does it increase maintenance burden or risk? → **Strongly Recommended**
3. Is it a preference or minor improvement? → **Suggestion**
