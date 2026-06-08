---
name: skill-reference-curation
description: Use when creating or updating an agent skill that depends on external knowledge, domain concepts, official documentation, reusable source summaries, schemas, practices, or examples, and the skill should keep SKILL.md concise by moving durable knowledge into references/.
---

# Skill Reference Curation

Use this skill during skill creation or skill updates when the workflow needs knowledge that should outlive a single conversation.

The goal is to make skills sharper without bloating `SKILL.md`. Keep triggers and workflow in `SKILL.md`; move source-grounded domain knowledge to directly linked files under `references/`.

Read [references/reference-design.md](references/reference-design.md) when designing a new reference file or deciding whether a reference is warranted.

## When to Use

Invoke this skill when:

- A skill's `SKILL.md` is growing beyond concise procedural guidance because it embeds source-specific facts, schemas, or domain vocabulary.
- A skill needs to cite official documentation, standards, or canonical sources that may go stale.
- A skill covers multiple providers, workflow variants, or concept families, and each warrants conditional loading.
- You are adding a new reference file to an existing skill's `references/` directory.
- An existing reference file has a triggered revalidation condition (e.g., tool version change, policy update, time elapsed since `last_checked`).

## When NOT to Use

- **Improving the skill's workflow logic or triggers**: use `manage-agent-skills` instead.
- **Creating a new skill from scratch**: use `write-a-skill` instead.
- **Adding a script or automation**: scripts belong in `scripts/`, not `references/`.
- **Collecting general knowledge the model already reliably knows**: do not add a reference just to have one.

## Workflow

1. Identify which knowledge improves the skill beyond general model knowledge.
2. Prefer official documentation, standards, maintainer guidance, canonical repositories, and implementation-proximate sources.
3. Decide whether the content belongs in:
   - `SKILL.md`: trigger, core workflow, loading instructions.
   - `references/`: durable source summaries, schemas, examples, policy details, domain concepts.
   - `scripts/`: deterministic repeatable operations.
4. Create or update the reference file using the compact structure defined in [references/reference-design.md](references/reference-design.md).
5. Add a direct `Read [references/<file>.md]` link in `SKILL.md` with a conditional loading instruction (e.g., "Read when the task uses X").
6. Keep every reference directly linked from `SKILL.md`; avoid deep reference chains.
7. Include source URLs, `last_checked`, and a revalidation trigger for time-sensitive or external facts.
8. Summarize sources in your own words. Do not copy long passages.
9. Add only references that the agent can realistically know when to load.

## Updating Existing References

Update an existing reference file when any of the following is true:

- The reference's own `Revalidation trigger` condition has been met (e.g., tool major version released, policy changed, time threshold passed).
- A source URL is dead or the content has materially changed.
- The skill's workflow was updated and the reference no longer matches what the workflow expects.
- A user or reviewer flags the reference as outdated or incorrect.

Do not update a reference preemptively. Check the `last_checked` date and `Revalidation trigger` field first.

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
