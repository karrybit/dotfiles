---
name: install-agent-extension
description: Vet a Claude Code skill, subagent, plugin, or MCP server before installing or enabling it. Use when asked to install, add, enable, or try out an agent extension from a marketplace, a GitHub repository, or a directory on disk, and when authoring a subagent definition. Covers what to inspect, source and license requirements, and the tool defaults a new subagent should start from. The source basis is recorded in ~/.local/share/agents/docs/agent-extension-security.md.
---

# Installing an agent extension

The approval rule for risky extensions lives in the user `CLAUDE.md` under
"Agent Scripts and Extensions", and the rules for committing an extension live
in `~/.local/share/agents/docs/agent-extensions.md`; both apply whether or not
this skill is loaded. What follows is the procedure.

## Vetting Steps

1. Inspect the candidate in a temporary or quarantined directory first,
   covering the whole directory: `SKILL.md`, subagent frontmatter, plugin
   manifests, hooks, MCP server declarations, executable scripts, install and
   update commands, network access, and secret-handling behavior. Review more
   than `SKILL.md`, since a skill is a folder of instructions, scripts, and
   resources.
   Completion: each item in that list is reported as present with its
   findings, or absent.
2. When the candidate is on disk, run
   `$XDG_DATA_HOME/agents/scripts/agent-extension-security/bin/vet-agent-extension`
   against its directory.
   Completion: the script's output is in the report.
3. Check the source and license as "Source and License" describes.
   Completion: the report names the source repository, the pinned ref, and the
   license.

## Source and License

- Prefer official, canonical, or maintainer-owned sources.
- Pin the exact source repository and ref when installing from Git.
- Review the license for each imported extension.
- Accept organization-required extensions even when they are third-party.
- Keep private employer or organization names out of public dotfiles and
  reusable guidance unless explicitly requested.

## Authoring a Subagent

- Start a subagent with read-only tools, and without `mcpServers`, `hooks`, or
  an elevated `permissionMode`, unless the task requires those capabilities.
- Subagents can declare tools, disallowed tools, model, permission mode, MCP
  servers, hooks, preloaded skills, memory, background execution, and worktree
  isolation; treat each of the last four as a review gate rather than a
  default.
