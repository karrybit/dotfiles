# Designing Against the Real Environment

Read when: wiring an integration to a path, port, endpoint, or config key;
making a change that must work across machines, agents, operating systems, or
runtimes; generating derived artifacts; picking per-item or whole-directory
file ownership; accepting a refactor; or collecting information into a durable
artifact.

## Integrations and Targets

- Before wiring an integration to a path, port, endpoint, or config key, confirm
  where the consuming program reads it here, resolving environment variables,
  config overrides, and XDG or platform defaults; documented defaults can be
  overridden locally.
- When a change must work across targets you cannot all observe (agents,
  machines, operating systems, runtimes), treat each unobserved target's
  behavior as an unverified assumption: verify it directly, or make the
  mechanism self-verify at apply or run time, before depending on it.

## Derived Artifacts and Refactors

- Generate derived artifacts from a single source of truth, since
  hand-maintained derived sets drift and scale with item count times target
  count.
- Before accepting a refactor, enumerate the invariants the current solution
  satisfies (correct consumer path, coexistence with other writers,
  idempotency, reversibility) and confirm the replacement preserves all of
  them; a lower file or step count does not by itself justify a change.
- Prefer per-item ownership over whole-directory ownership, so additions by
  other tools survive.

## Durable Information Artifacts

- When collecting information into a durable artifact (research notes,
  ledgers, analyses, reports, handoffs), keep three separable layers:
  policy-safe raw observations, normalized records, and use-case-shaped
  outputs.
- Keep the artifact rebuildable from the earlier layers when the use case
  changes. Grounding: `medallion-information-design.md` beside this file.
