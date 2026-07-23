# Agent Extensions Ledger

This ledger records skills, plugins, MCP-backed extensions, hooks, and subagents
that affect local coding-agent behavior. It is a migration manifest for future
plugin/package-manager based distribution.

`sync_policy` values:

- `sync`: manage the artifact in this dotfiles repository.
- `adapter-only`: manage only the agent-specific entrypoint or symlink.
- `installed-only`: record installed state, but do not vendor the artifact.
- `do-not-vendor`: do not copy or derive the artifact into shared dotfiles.
- `remove-from-dotfiles`: remove the artifact from managed source when found.

| name | kind | agent | origin | source | version/ref | license | managed_by | sync_policy | migration_target | reviewed_at | notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| agentic-development-research | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Uses local agent docs cache; Claude subagent is optional. |
| cli-creator | skill | Codex | local | this repo | main | Apache-2.0 | chezmoi Codex skill | adapter-only | future personal plugin or cross-agent refactor | 2026-07-23 | Codex-specific; kept because Codex is installed on another managed machine (user-confirmed 2026-07-23). |
| csv-wrangling-with-qsv | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | qsv-first local CSV/TSV inspection, transformation, and validation workflow. |
| frontend-design@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | Apache-2.0 | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Replaced stale vendored skill copy; upstream rewrote the skill entirely. |
| manage-agent-skills | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-07-23 | Skill governance policy (placement, provenance, ledger, reference curation). Absorbed skill-reference-curation; authoring/eval mechanics delegated to skill-creator plugin. |
| pii-publish-guard | hook | Claude Code | local | this repo | main | local | `dot_config/claude/settings.base.pkl` + `dot_local/share/agent-scripts/pii-publish-guard/` | sync | n/a | 2026-07-23 | PreToolUse secret scan blocking `git push` / `gh pr create` / `gh release create`. Replaces the pii-publish-guard skill; broader PII judgment lives in `dot_config/agents/AGENTS.md`. |
| webapp-testing | skill | cross-agent | official | anthropics/skills | installed copy + local additions | Apache-2.0 | chezmoi canonical skill | sync | official standalone package when available | 2026-07-23 | Upstream diff reviewed 2026-07-23 (minor). Kept vendored: anthropics/skills marketplace ships it only inside the broad example-skills bundle. |
| xlsx | skill | Claude Code | official | Anthropic Claude Code installed skill | installed copy | Proprietary | installed/runtime only | do-not-vendor | official package only | 2026-06-07 | Proprietary license forbids shared vendoring; remove from dotfiles source. |
| japanese-tech-writing | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-07-23 | 日本語技術文書の整形・段落構成・論証の厳密さ・冗長排除の文章規範。 |
| cognitive-rhythm-writing | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-07-23 | 認知リズム（緩急）設計規範。japanese-tech-writing の併用を前提とする。 |
| agentic-development-researcher | subagent | Claude Code | local | this repo | main | local | chezmoi Claude subagent | adapter-only | future personal plugin | 2026-06-07 | Optional isolated research scanner for Claude Code. |
| usage-collector@awesome-claude-marketplace | plugin | Claude Code | third-party | awesome-claude-marketplace | managed setting | unknown | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| skill-creator@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Enabled plugin setting only; artifact not vendored here. Canonical route for skill authoring/eval mechanics. |
| claude-md-management@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Enabled plugin setting only. Canonical route for CLAUDE.md maintenance (replaced the maintain-claude-md skill; source summaries kept in agents/docs/claude-md-maintenance-references.md). |
| code-review@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Enabled plugin setting only. Row added retroactively. |
| commit-commands@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Enabled plugin setting only. Row added retroactively. |
| security-guidance@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Enabled plugin setting only (hook-based guidance). With built-in /security-review, replaced the security-best-practices skill. Row added retroactively. |
| slack@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| gopls-lsp@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | installed 1.0.0 | official marketplace | Claude Code project-scope install | installed-only | package manager | 2026-07-23 | Project-scoped install (work repo), not in `settings.base.pkl`. |
| typescript-lsp@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | installed 1.0.0 | official marketplace | Claude Code project-scope install | installed-only | package manager | 2026-07-23 | Project-scoped install (work repo), not in `settings.base.pkl`. |
