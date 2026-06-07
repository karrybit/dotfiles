---
name: manage-agent-skills
description: Design, create, place, update, move, or remove reusable agent skills while preserving clear scope and triggering behavior. Use when deciding whether a workflow should become a skill, choosing repository-local versus user-global placement, resolving overlap between skills, or maintaining a skill's structure and metadata. Delegate broad quality audits to audit-agent-skills.
---

# Manage Agent Skills

Create the smallest durable skill that adds procedural knowledge the agent does not already have.

## Decide Whether A Skill Is Needed

Use a skill for a reusable workflow, specialized domain knowledge, deterministic helper script, or bundled reference. Prefer:

- A prompt for one-off constraints.
- `AGENTS.md` for durable repository conventions and verification requirements.
- A hook or test for mechanically enforceable behavior.
- A plugin when distributing multiple skills with tools, commands, hooks, or MCP configuration.

Do not create a skill that merely repeats general engineering practices or an existing skill.

## Choose Scope And Placement

Inspect repository instructions and existing conventions before choosing a path.

| Scope | Typical path |
| --- | --- |
| One repository | `<repo>/.agents/skills/<skill-name>/` |
| Current user across repositories | `~/.local/share/agent-skills/skills/<skill-name>/` |
| Managed user-global source | Use the repository's documented source mapping |

Do not assume a dotfiles repository's source path. Verify its mapping and ignore
rules first. In this dotfiles repository, shared user-global skills are canonical
under `dot_local/share/agent-skills/skills/` and deploy to Codex and Claude Code
through managed symlink entries. When both local and global copies exist, prefer
the narrower applicable skill and eliminate accidental duplication.

## Workflow

1. Clarify concrete trigger examples and expected outcomes.
2. Search all relevant skill roots for equivalent or overlapping skills.
3. Decide whether to create, extend, split, merge, move, or remove a skill.
4. State the intended scope, placement, and edits before modifying files.
5. Use the available `skill-creator` workflow to initialize new skills.
6. Keep `SKILL.md` concise and imperative:
   - Include only `name` and `description` in frontmatter.
   - Put all triggering conditions in `description`.
   - Move detailed material to directly linked `references/`.
   - Add `scripts/` only for repeated or deterministic operations.
7. When making a skill cross-agent, normalize it around the shared workflow and make agent-specific capabilities conditional. Do not leave Codex-only or Claude Code-only assumptions in the main instructions unless the description scopes the skill to that agent. Put agent-specific runners, metadata, or entrypoint behavior behind explicit availability checks or adapter files.
8. Add or update `PROVENANCE.md` and the extension ledger before publishing the skill.
9. Generate or update `agents/openai.yaml` when the skill is deployed to Codex and UI metadata is useful.
10. Preserve unrelated files and upstream license files.
11. Review repository documentation and ignore rules when placement or discovery changes.

## Validation

Use the available official skill validator. If `uv` is available and the validator needs PyYAML, prefer:

```sh
uv run --with pyyaml python <skill-creator>/scripts/quick_validate.py <skill-path>
```

Also run:

```sh
git diff --check
git status --short
```

When a repository manages global skills, verify the intended target paths with its management tool. Do not deploy, install globally, or restart tools unless the user requests that side effect.
