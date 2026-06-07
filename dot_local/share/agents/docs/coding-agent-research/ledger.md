# Coding Agent Source Ledger

Date created: 2026-06-06

Context: Maintained ledger for near-term coding agent practice research. Use
with `strategy.md`.

## Status Values

- `adopt`: Ready to turn into a local practice or durable instruction.
- `trial`: Ready for a small reversible experiment.
- `investigate`: Worth deeper review before a trial.
- `observe`: Watch for updates, adoption, or clearer evidence.
- `hold`: Not actionable now, but not rejected.
- `reject`: Do not use as a basis for local changes.

## Entry Template

```md
## <name>

- source_type:
- url:
- language:
- layer: local / repo / tool / workflow / eval / community
- time_horizon: days / weeks
- authority:
- proximity:
- evidence:
- actionability:
- freshness:
- influence:
- discovery_value:
- local_applicability:
- trial_cost:
- last_checked:
- next_check:
- check_frequency:
- watch_reason:
- revalidation_trigger:
- status: adopt / trial / investigate / observe / hold / reject

Summary:

Local applicability:

Risks or stale assumptions:
```

## Initial Source Queue

Use this queue for the first full research pass. Add entries only after
checking the current source state.

- OpenAI Codex manual and customization guidance.
- OpenAI skills repository and skill packaging guidance.
- OpenAI Codex release notes and changelogs.
- Anthropic Claude Code docs for settings, subagents, hooks, plugins, MCP, and
  skills.
- Anthropic Claude Code advanced patterns materials.
- GitHub Copilot coding agent and Codex or Claude integration announcements.
- Kiro coding service docs and steering/spec guidance.
- Cursor, Gemini CLI, and other current coding agent workflows when supported
  by official docs or concrete practitioner evidence.
- Public dotfiles with strong AGENTS.md, CLAUDE.md, skill, subagent, or eval
  examples.
- Japanese practitioner sources, including mizchi when a specific post,
  repository, or talk is relevant.
- Zenn, personal blogs, issue comments, and small repositories with concrete
  reproducible workflows.

## Candidate Extraction

This section stores only candidates promoted from source entries. Keep source
evaluation in ledger entries and final decisions in the run-level decision log.

```md
## <date>

- Trial candidate:
- Source:
- Expected benefit:
- Reversal cost:
- Verification:
- Decision:
```
