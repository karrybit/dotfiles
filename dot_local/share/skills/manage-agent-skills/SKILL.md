---
name: manage-agent-skills
description: Govern reusable agent skills. Use when deciding whether a workflow should become a skill, a rule, or a hook; choosing repository-local versus user-global placement; resolving overlap between skills; curating references/ content; auditing the skill collection; or removing and merging skills. Covers this environment's placement, provenance, and ledger policy. Delegate hands-on authoring and eval mechanics to the skill-creator plugin.
---

# Manage Agent Skills

Keep the skill set small, well-placed, and recorded. Create the smallest
durable skill that adds procedural knowledge the agent does not already have.

## Decide Skill vs Rule vs Hook

- A skill fires probabilistically and costs a description line in every
  session. Use one only for an on-demand workflow, specialized domain
  knowledge, a deterministic helper script, or bundled reference material.
- Prefer `AGENTS.md` rules for norms that must apply every time a common
  situation occurs; a skill is the wrong mechanism when a missed trigger is a
  failure.
- Prefer a hook or test for mechanically enforceable behavior.
- Prefer a plugin when an official or maintained equivalent exists; do not
  duplicate what the standard tooling already provides.
- Do not create a skill that repeats general engineering practice or an
  existing skill.

## Choose Scope And Placement

| Scope | Typical path |
| --- | --- |
| One repository | `<repo>/.agents/skills/<skill-name>/` |
| Current user across repositories | `~/.local/share/skills/<skill-name>/` |
| Managed user-global source | Use the repository's documented source mapping |

In this dotfiles repository, shared user-global skills are canonical under
`dot_local/share/skills/` and deploy through
`run_onchange_04_sync-skills.sh.tmpl`, which symlinks each directory containing
`SKILL.md` into `~/.agents/skills/` and `~/.config/claude/skills/`. Third-party
skills installed into those directories are left untouched. When both local
and global copies exist, prefer the narrower applicable skill.

## Policy Requirements

- Every managed user-global skill has `PROVENANCE.md` (origin, source URL,
  license, reviewed_at, sync_policy, migration_target).
- Every skill, plugin, hook, and subagent that affects agent behavior has a
  row in `~/.local/share/agents/docs/agent-extensions-ledger.md`. Remove the
  row when the extension is fully removed; keep it (as installed-only) while
  the extension remains installed outside chezmoi.
- Keep `SKILL.md` concise and imperative: only `name` and `description` in
  frontmatter, all triggering conditions in `description`, detail in directly
  linked `references/`, `scripts/` only for deterministic repeated operations.
- For skills that depend on external knowledge, official docs, schemas, or
  domain concepts, design `references/` files using
  [references/reference-design.md](references/reference-design.md): one narrow
  concept per file, source URLs with `last_checked` and a revalidation
  trigger, summaries in your own words, every file directly linked from
  `SKILL.md` with a conditional loading instruction.
- When making a skill cross-agent, normalize around the shared workflow and
  put agent-specific runners or metadata behind availability checks or
  adapter files. Do not leave single-agent assumptions in the main
  instructions unless the description scopes the skill to that agent.

## Workflow

1. Clarify concrete trigger examples and expected outcomes.
2. Search all relevant skill roots and enabled plugins for equivalent or
   overlapping capability; prefer extending, merging, or deleting over adding.
3. State the intended scope, placement, and edits before modifying files.
4. Use the skill-creator plugin for authoring, evals, and description
   optimization; apply the policy requirements above to its output.
5. Add or update `PROVENANCE.md` and the extensions ledger before publishing.
6. Preserve unrelated files and upstream license files.
7. Review repository documentation and ignore rules when placement or
   discovery changes.

## Validation

```sh
git diff --check
git status --short
```

Verify deployment with the repository's management tool (`chezmoi apply`, then
confirm the expected symlinks). Do not deploy, install globally, or restart
tools unless the user requests that side effect.
