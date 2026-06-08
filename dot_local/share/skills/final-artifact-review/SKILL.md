---
name: final-artifact-review
description: Review final deliverables after iterative or conversation-driven work. Use before finishing work that created or changed multiple artifacts, or when asked to check consistency, quality, contradictions, stale decisions, artifact placement, documentation, skills, subagents, code, configs, or other non-code deliverables. This is a review workflow; modify files only when the user separately asks for fixes.
---

# Final Artifact Review

Use this skill as the final reconciliation pass after artifacts have evolved through discussion, partial implementation, or multiple design changes.

The goal is not to re-review every detail. The goal is to catch mismatches that emerge only when the final set is viewed as one system.

## Scope

Apply this to any durable output:

- code, tests, configs, scripts, and generated project files
- documentation, research notes, ledgers, decision logs, and README updates
- agent instructions, skills, subagents, prompts, workflows, and tooling metadata
- plans or handoff artifacts that future agents or humans will execute

Do not use this as a substitute for domain-specific audits. If the work is a production release, security review, skill audit, or regression-testing task, use the relevant specialized skill as well.

Do not use this skill for:

- A single in-progress or partially written file. Run the `code-review` skill instead.
- A mid-session check before implementation is complete. Finish the work first, then run this skill.
- General debugging, command troubleshooting, or understanding existing behavior. Those are investigative tasks, not reconciliation.

## Review Workflow

1. Establish the intended final state from the user's latest request, not from earlier conversation momentum.
2. Inventory changed and newly created artifacts with `git status --short`, `git diff --name-status`, or the local equivalent.
3. Classify each new artifact:
   - `canonical`: current source of truth
   - `draft`: useful but not authoritative
   - `merged`: content absorbed elsewhere
   - `deletion candidate`: likely obsolete, but do not delete unless asked
4. Check cross-artifact consistency:
   - terminology and naming
   - directory placement and ownership
   - source-to-target mappings
   - references, links, imports, and generated metadata
   - documented behavior versus actual files
   - current decisions versus stale rationale
5. Check quality at the system level:
   - Does the artifact set answer the user's actual goal?
   - Can a fresh human or agent tell what to use, what to ignore, and what to update next?
   - Are responsibilities split cleanly, without duplicated or conflicting instructions?
   - Are temporary scripts, runtime state, caches, or credentials kept out of durable outputs?
   - Are verification commands, tests, or manual checks recorded or run where appropriate?
6. Check instruction and decision hygiene:
   - Keep only current effective guidance in instruction files.
   - Put rationale, rejected options, and superseded context in a decision log, commit message, PR note, or handoff note.
   - Do not turn one-off preferences into standing rules without a reusable trigger.
7. Report findings first, ordered by severity. Include file paths and concrete evidence.
8. If no material issues are found, say so and list residual checks that were not possible.

## Fixing Findings

When the user asked only for review, do not edit files.

When the user asked to implement fixes, make the smallest coherent edits after the review pass. Re-run the relevant validation and repeat the consistency check on the changed surface.

## Output Shape

Use this compact structure unless the user asks for a different format.

Severity levels for findings:
- `critical`: breaks correctness, safety, or the user's stated goal (e.g., wrong flag name shipped in docs, runtime state committed)
- `warn`: reduces clarity, increases maintenance cost, or risks future breakage (e.g., stale rationale, misplaced file)
- `info`: cosmetic or low-risk (e.g., a TODO comment that is already tracked)

```text
Findings:
- <severity>: <file/path> - <issue, evidence, impact>

Artifact classification:
- canonical: ...
- draft: ...
- merged: ...
- deletion candidate: ...

Checks run:
- ...

Residual risk:
- ...
```

For implementation tasks, the final user-facing answer can be shorter, but it should still mention the important reconciliation result and verification status.
