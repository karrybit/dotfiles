# Agentic Development Research Run Summary

Date: 2026-06-08

## Scope

- First real research pass for both tracks (the 2026-06-07 run only set up
  directory structure; ledgers had no scored source entries).
- User-selected scope: both tracks, broad initial-queue scan.
- Two isolated research agents ran in parallel (one per track). The custom
  `agentic-development-researcher` subagent type was not registered in this
  session, so `general-purpose` agents were briefed with the researcher
  boundaries (read-only, draft-only, report inaccessible sources).

## Method

- Source priority per each track's `strategy.md`: official/primary first, then
  implementation-proximate, then practitioners, then community.
- Official docs freshly fetched on 2026-06-08 and labeled verified; sources that
  could not be fetched are labeled unverified with revalidation triggers.

## Updated Artifacts

- `coding-agent-research/ledger.md` — added 8 source entries + 4 trial
  candidates.
- `agentic-software-delivery-research/ledger.md` — added 8 source entries + 5
  strategic watch items.
- `agentic-development-runs/2026-06-08/` — this summary, candidate actions,
  decision log.

## Coding-agent track — what was checked

- Verified (fetched 2026-06-08): Codex manual, Codex skills doc, Codex
  changelog, Claude Code skills / sub-agents / hooks docs, GitHub Copilot
  Claude+Codex availability changelog, openai/skills README (via raw).
- Discovery only (search snippets, not deep-read): okhlopkov, boringbot,
  mizchi and other 2026 practitioner setups.
- Key correction: Codex skills live under the agentskills.io open-standard path
  `~/.agents/skills`, NOT `~/.codex/skills`. SKILL.md is now shared across
  Claude Code, Codex, Cursor, Gemini CLI, Copilot.

## Delivery track — what was checked

- Verified via official docs / WebSearch of official docs: Bedrock AgentCore
  platform + Runtime session isolation, Kiro (GA May 2026), GitHub Copilot
  coding agent (GA, governance controls).
- Partially verified / secondary coverage: OpenAI Symphony (page 403; repo via
  sandbox TLS failure), Claude Code advanced-patterns internals (mix of official
  webinar + reverse-engineered analysis).
- Empirical base added: MSR 2026 AIDev (33,707 agent PRs), SWE-Bench+ / SWE-EVO
  benchmark-validity findings, "verification tax" reports.

## Cross-track signal

- Generation is commoditizing; the binding constraint and main governance risk
  is review/validation and pre-execution approval for irreversible operations.
  This connects near-term local trials (risk-based diff triage, destructive-op
  hooks) to long-term delivery architecture (issue-tracker control planes,
  org-managed identity/policy).

## Notes

- No AGENTS, skill, subagent, settings, eval, MCP, or workflow implementation
  was adopted in this run. Trial candidates and watch items are proposals only.
- Strategy-file source-list additions were identified but not applied (recorded
  in the decision log as pending user approval).
