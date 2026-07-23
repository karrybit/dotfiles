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
| agent-architecture-audit | skill | cross-agent | distilled | ECC workflow | 2026-06-06 local review | local-distillation | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Instruction-only; no ECC runtime, plugin, hook, or MCP installed. |
| agent-introspection-debugging | skill | cross-agent | distilled | ECC workflow | 2026-06-06 local review | local-distillation | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Instruction-only recovery workflow. |
| agentic-development-research | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Uses local agent docs cache; Claude subagent is optional. |
| ai-regression-testing | skill | cross-agent | distilled | ECC workflow | 2026-06-06 local review | local-distillation | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Framework-neutral regression test design. |
| audit-agent-skills | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Audits skill structure, overlap, placement, and provenance. |
| cli-creator | skill | Codex | local | this repo | main | Apache-2.0 | chezmoi Codex skill | adapter-only | future personal plugin or cross-agent refactor | 2026-06-07 | Still Codex-specific; revisit before common canonical migration. |
| csv-wrangling-with-qsv | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | qsv-first local CSV/TSV inspection, transformation, and validation workflow. |
| final-artifact-review | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Final reconciliation pass. |
| frontend-design@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | Apache-2.0 | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-07-23 | Replaced stale vendored skill copy; upstream rewrote the skill entirely. |
| manage-agent-skills | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Maintains skills and provenance. |
| pii-publish-guard | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Publish-time PII and secret guard. |
| production-audit | skill | cross-agent | distilled | ECC workflow | 2026-06-06 local review | local-distillation | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Local-evidence readiness workflow. |
| webapp-testing | skill | cross-agent | official | anthropics/skills | installed copy + local additions | Apache-2.0 | chezmoi canonical skill | sync | official standalone package when available | 2026-07-23 | Upstream diff reviewed 2026-07-23 (minor). Kept vendored: anthropics/skills marketplace ships it only inside the broad example-skills bundle. |
| xlsx | skill | Claude Code | official | Anthropic Claude Code installed skill | installed copy | Proprietary | installed/runtime only | do-not-vendor | official package only | 2026-06-07 | Proprietary license forbids shared vendoring; remove from dotfiles source. |
| maintain-claude-md | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-09 | Full-lifecycle CLAUDE.md maintenance: Bootstrap (create), Restructure (five-layer), Drift-correct (fact verification). Distilled from practitioner research (Okhlopkov, Karpathy, Yanli Liu, VILA-Lab). |
| japanese-tech-writing | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-07-23 | 日本語技術文書の整形・段落構成・論証の厳密さ・冗長排除の文章規範。 |
| cognitive-rhythm-writing | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-07-23 | 認知リズム（緩急）設計規範。japanese-tech-writing の併用を前提とする。 |
| agentic-development-researcher | subagent | Claude Code | local | this repo | main | local | chezmoi Claude subagent | adapter-only | future personal plugin | 2026-06-07 | Optional isolated research scanner for Claude Code. |
| github@openai-curated | plugin | Codex | official | OpenAI curated marketplace | installed | official marketplace | Codex runtime config | installed-only | package manager | 2026-06-07 | Enabled in live `~/.codex/config.toml`; config is not currently chezmoi-managed. |
| google-drive@openai-curated | plugin | Codex | official | OpenAI curated marketplace | installed | official marketplace | Codex runtime config | installed-only | package manager | 2026-06-07 | Enabled in live `~/.codex/config.toml`; config is not currently chezmoi-managed. |
| usage-collector@awesome-claude-marketplace | plugin | Claude Code | third-party | awesome-claude-marketplace | managed setting | unknown | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| skill-creator@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| slack@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| superpowers@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| gopls-lsp@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| typescript-lsp@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
