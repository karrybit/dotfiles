# Agent Extensions

Read when: installing or committing an agent extension or a managed skill, or
deciding where an installed skill, plugin, MCP server, hook, or subagent is
recorded.

- Treat skills, plugins, MCP servers, hooks, and subagents installed by Claude
  Code commands as runtime state, not chezmoi-managed source, unless the
  corresponding source artifact or setting is added to the dotfiles repository.
- When a managed user-global skill is vendored or derived from an external
  source, give it a `PROVENANCE.md` recording origin, source, license, review
  date, and the upstream version or ref.
- Leave `PROVENANCE.md` out of a skill or plugin written in this repository,
  since its plugin namespace and git history already record its origin.
- Keep `PROVENANCE.md` current across updates and re-reviews.
- Keep provenance per item, beside the artifact, instead of in a registry of the
  collection.
- Install proprietary, unclear-license, or terms-restricted artifacts through a
  plugin or package manager, or leave them as runtime state outside the
  dotfiles repository.
