---
name: install-agent-extension
description: Vet a Claude Code skill, subagent, plugin, or MCP server before installing or enabling it. Use when asked to install, add, enable, or try out an agent extension from a marketplace, a GitHub repository, or a directory on disk, and when authoring a subagent definition. Covers what to inspect, source and license requirements, and the tool defaults a new subagent should start from. The source basis is recorded in ~/.local/share/agents/docs/agent-extension-security.md.
---

# Installing an agent extension

The hard prohibitions live in the user `CLAUDE.md` under "External Agent
Extensions" and apply whether or not this skill is loaded. What follows is the
procedure.

## Inspect before installing

Inspect the candidate in a temporary or quarantined directory first, covering
`SKILL.md`, subagent frontmatter, plugin manifests, hooks, MCP server
declarations, executable scripts, install and update commands, network access,
and secret-handling behavior. A skill is a folder of instructions, scripts, and
resources, so review the whole directory rather than only `SKILL.md`.

When the candidate is available on disk, run
`$XDG_DATA_HOME/agents/scripts/agent-extension-security/bin/vet-agent-extension`
against its directory.

## Source and license

- Prefer official, canonical, or maintainer-owned sources.
- Pin the exact source repository and ref when installing from Git.
- Review the license for each imported extension.
- Organization-required extensions are acceptable even when they are third-party.
  Do not record private employer or organization names in public dotfiles or
  reusable guidance unless explicitly requested.

## Authoring a subagent

Prefer read-only tools, and no `mcpServers`, `hooks`, or elevated
`permissionMode`, unless the task requires those capabilities. Subagents can
declare tools, disallowed tools, model, permission mode, MCP servers, hooks,
preloaded skills, memory, background execution, and worktree isolation — treat
each of the last four as a review gate rather than a default.
