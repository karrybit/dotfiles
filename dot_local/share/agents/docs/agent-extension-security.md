# Agent Extension Security Sources

Checked: 2026-06-06

Revalidate when Codex or Claude Code changes skill, plugin, subagent,
permission, sandbox, or marketplace behavior.

## OpenAI Codex Skills

Source: https://github.com/openai/skills

OpenAI's public skills catalog describes Agent Skills as folders of
instructions, scripts, and resources that Codex can discover for repeatable
tasks. The catalog distinguishes system, curated, and experimental skills.
System skills are shipped with Codex; curated and experimental skills are
installed through `$skill-installer` and require a Codex restart after
installation. Individual skill licenses live inside each skill directory.

Security implication: review the whole skill directory, not only `SKILL.md`,
because scripts and resources are part of the executable package.

## Claude Code Subagents

Source: https://code.claude.com/docs/en/sub-agents

Claude Code subagents are Markdown files with YAML frontmatter. User subagents
live under `~/.claude/agents/`; project subagents live under `.claude/agents/`;
plugin agents come from plugin `agents/` directories. Subagents can define
tools, disallowed tools, model, permission mode, MCP servers, hooks, preloaded
skills, memory, background execution, and worktree isolation. Plugin-shipped
agents do not support hooks, MCP servers, or permission mode.

Security implication: prefer read-only tools for review/research agents, avoid
elevated `permissionMode`, and treat `mcpServers`, `hooks`, and broad tool
access as explicit review gates.

## Claude Code Settings And Plugins

Source: https://code.claude.com/docs/en/settings

Claude Code settings support permission allow/ask/deny rules, sensitive file
read denial, sandbox filesystem and network restrictions, plugin enablement,
marketplace declarations, and managed-only marketplace restrictions. Settings
precedence is managed settings, command-line arguments, local project settings,
shared project settings, then user settings. Plugin settings can explicitly
enable or disable `plugin@marketplace` IDs.

Security implication: user settings can add practical local deny rules and
sandbox defaults, but strict marketplace and customization lockdown requires
managed settings.
