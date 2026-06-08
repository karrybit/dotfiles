# Agentic Development Decision Log

Date: 2026-06-08

## Decisions Taken This Run

### Populate both ledgers from the first real research pass

- decision: adopted
- track: agentic-development
- source:
  - `coding-agent-research/ledger.md`
  - `agentic-software-delivery-research/ledger.md`
- reason: This run executed the first scan/triage/ledger-update cycle. Reviewed
  source entries (8 per track) with freshness and revalidation metadata were
  written, plus trial candidates and strategic watch items.
- next_review: 2026-07-08 monthly pass.

### Keep implementation separate from research

- decision: adopted
- track: agentic-development
- source:
  - `dot_config/agents/AGENTS.md` (scope control)
- reason: No AGENTS/skill/subagent/settings/eval/MCP/workflow changes were made.
  Trial candidates and watch items are proposals; each requires its own explicit
  approval before implementation.
- next_review: When the user approves a specific trial.

## Decisions Needed (pending user approval)

### Add newly found official sources to coding-agent strategy

- status: pending
- proposed: add `https://developers.openai.com/codex/skills` and
  `https://developers.openai.com/codex/changelog` to
  `coding-agent-research/strategy.md` source list.
- reason: Both are official Codex sources not in the current queue and were
  load-bearing this pass.

### Correct stale Codex skills-path assumption in strategy

- status: pending
- proposed: note in `coding-agent-research/strategy.md` that the canonical Codex
  skills path is the agentskills.io standard `~/.agents/skills` (plus
  `.agents/skills` repo-level and `/etc/codex/skills`), NOT `~/.codex/skills`.
- reason: Verified correction from the Codex skills doc; affects any
  cross-tool skill work.

### Add empirical + governance sources to delivery strategy

- status: pending
- proposed: add MSR 2026 AIDev empirical studies and the MCP-to-Linux-Foundation
  (Dec 2025) governance signal to
  `agentic-software-delivery-research/strategy.md` source list.
- reason: Strongest empirical evidence on the review bottleneck and a key
  cross-vendor governance signal; not currently in the queue.

### Schedule which trial candidates to run

- status: pending
- proposed: pick from the 4 coding-agent trial candidates (diff-reviewer
  subagent, diff-check/chezmoi hook, cross-tool SKILL.md, Codex profiles).

## Verification Gaps To Retry (with network approval)

- OpenAI Symphony page (HTTP 403) and `openai/symphony` repo / SPEC.md (sandbox
  TLS error `x509: OSStatus -26276`) — Symphony details rely on secondary
  coverage only.
- `github.com/openai/skills` HTML page + full file tree (WebFetch 504; gh api
  TLS) — only README verified via raw; enumerate skills/licenses before
  vendoring any.
- AgentCore `runtime-sessions.html` direct page (empty fetch) — isolation
  numbers (Firecracker, 8h, ephemeral fs) came from official-doc WebSearch.
- Claude Code "Advanced Patterns" internals — verify against the official
  webinar resource; several specifics derive from reverse-engineered analysis.
- Incident dollar/time/record figures — treat as unverified marketing; cite the
  gate-bypass pattern, not the numbers.

## Process Note

- The custom `agentic-development-researcher` subagent type was not available in
  this session; `general-purpose` agents were used with the researcher
  boundaries embedded in the prompt. Confirm subagent install/discovery before
  the next pass relies on it.
