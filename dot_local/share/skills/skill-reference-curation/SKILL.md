---
name: skill-reference-curation
description: Use when creating or updating an agent skill that depends on external knowledge, domain concepts, official documentation, reusable source summaries, schemas, practices, or examples, and the skill should keep SKILL.md concise by moving durable knowledge into references/.
---

# Skill Reference Curation

Use this skill during skill creation or skill updates when the workflow needs knowledge that should outlive a single conversation.

The goal is to make skills sharper without bloating `SKILL.md`. Keep triggers and workflow in `SKILL.md`; move source-grounded domain knowledge to directly linked files under `references/`.

Read [references/reference-design.md](references/reference-design.md) when designing a new reference file or deciding whether a reference is warranted.

## Workflow

1. Identify which knowledge improves the skill beyond general model knowledge.
2. Prefer official documentation, standards, maintainer guidance, canonical repositories, and implementation-proximate sources.
3. Decide whether the content belongs in:
   - `SKILL.md`: trigger, core workflow, loading instructions.
   - `references/`: durable source summaries, schemas, examples, policy details, domain concepts.
   - `scripts/`: deterministic repeatable operations.
4. Keep every reference directly linked from `SKILL.md`; avoid deep reference chains.
5. Include source URLs, `last_checked`, and a revalidation trigger for time-sensitive or external facts.
6. Summarize sources in your own words. Do not copy long passages.
7. Add only references that the agent can realistically know when to load.

## Reference Rules

- A reference should improve decisions, not merely collect interesting reading.
- A reference should be narrower than the skill, usually one concept, schema, provider, workflow variant, or source family.
- If `SKILL.md` would exceed concise procedural guidance, move detail to references.
- If a reference becomes larger than practical to load, split by task or provider and add clear loading instructions.
- If the knowledge is stale-prone, record freshness and revalidation conditions.
- If the source is unofficial, label it as such and prefer it only for examples or practitioner context.

## Output Shape

When adding or revising references, report:

- Why a reference is needed.
- Which reference files will exist.
- Which sources support them.
- How `SKILL.md` tells the agent when to load them.
- Any freshness or licensing caveats.
