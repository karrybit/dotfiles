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
| define-goal | skill | cross-agent | local | this repo | main | Apache-2.0 | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Uses Codex goal tools only when available. |
| final-artifact-review | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Final reconciliation pass. |
| frontend-design | skill | cross-agent | official | Anthropic Claude Code installed skill | installed copy | Apache-2.0 | chezmoi canonical skill | sync | official package when available | 2026-06-07 | Review for overlap with higher-priority frontend instructions. |
| manage-agent-skills | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Maintains skills and provenance. |
| pii-publish-guard | skill | cross-agent | local | this repo | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Publish-time PII and secret guard. |
| production-audit | skill | cross-agent | distilled | ECC workflow | 2026-06-06 local review | local-distillation | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Local-evidence readiness workflow. |
| security-best-practices | skill | cross-agent | local | this repo | main | Apache-2.0 | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | Language/framework security review workflow. |
| skill-evaluation | skill | cross-agent | inspired | mizchi/waxa and local cowaxa | main | local | chezmoi canonical skill | sync | future personal plugin | 2026-06-07 | `cowaxa` is the Codex executor when available. |
| webapp-testing | skill | cross-agent | official | Anthropic Claude Code installed skill | installed copy | Apache-2.0 | chezmoi canonical skill | sync | official package when available | 2026-06-07 | Playwright workflow and helper script. |
| xlsx | skill | Claude Code | official | Anthropic Claude Code installed skill | installed copy | Proprietary | installed/runtime only | do-not-vendor | official package only | 2026-06-07 | Proprietary license forbids shared vendoring; remove from dotfiles source. |
| agentic-development-researcher | subagent | Claude Code | local | this repo | main | local | chezmoi Claude subagent | adapter-only | future personal plugin | 2026-06-07 | Optional isolated research scanner for Claude Code. |
| github@openai-curated | plugin | Codex | official | OpenAI curated marketplace | installed | official marketplace | Codex runtime config | installed-only | package manager | 2026-06-07 | Enabled in live `~/.codex/config.toml`; config is not currently chezmoi-managed. |
| google-drive@openai-curated | plugin | Codex | official | OpenAI curated marketplace | installed | official marketplace | Codex runtime config | installed-only | package manager | 2026-06-07 | Enabled in live `~/.codex/config.toml`; config is not currently chezmoi-managed. |
| usage-collector@awesome-claude-marketplace | plugin | Claude Code | third-party | awesome-claude-marketplace | managed setting | unknown | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| skill-creator@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| slack@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| superpowers@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| gopls-lsp@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
| typescript-lsp@claude-plugins-official | plugin | Claude Code | official | claude-plugins-official | managed setting | official marketplace | `dot_config/claude/settings.base.pkl` | installed-only | package manager | 2026-06-07 | Enabled plugin setting only; artifact not vendored here. |
