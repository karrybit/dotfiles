# Agent Extensions

Read when: committing an agent extension or a managed skill, or deciding where
an installed skill, plugin, MCP server, hook, or subagent is recorded.

- Treat skills, plugins, MCP servers, hooks, and subagents installed by Claude
  Code commands as runtime state, not chezmoi-managed source, unless the
  corresponding source artifact or setting is added to the dotfiles repository.
- Give every managed user-global skill a `PROVENANCE.md` recording origin,
  source, license, and review date, plus the upstream version or ref for any
  vendored artifact.
- Keep `PROVENANCE.md` current across updates and re-reviews.
- Keep provenance per item, beside the artifact, instead of in a registry of the
  collection.
- Install proprietary, unclear-license, or terms-restricted artifacts through a
  plugin or package manager, or leave them as runtime state outside the
  dotfiles repository.
