---
name: agentic-development-research
description: Run recurring research on coding agents and agentic software delivery. Use when updating agentic development source ledgers, extracting trial candidates or strategic watch items, or deciding where to store research artifacts.
---

# Agentic Development Research

Use this skill to run the recurring research workflow defined in the shared
agent docs cache. Do not store research results in this skill.

## When to Use

Invoke this skill when the user explicitly requests one of the following:
- Updating or refreshing a research ledger for the `coding-agent` or
  `agentic-software-delivery` track.
- Extracting or reviewing trial candidates or strategic watch items from
  existing ledger evidence.
- Deciding where to store a new research artifact (run directory, ledger,
  strategy file).
- Running a scheduled or ad-hoc research pass on coding-agent tooling (Claude
  Code, Cursor, Copilot, etc.) or delivery orchestration topics.

## When NOT to Use

Do not invoke this skill for:
- Editing `AGENTS.md`, `CLAUDE.md`, skills, subagents, MCP configuration, or
  settings files — use the appropriate implementation skill instead (e.g.
  `maintain-claude-md`, `update-config`).
- General web research unrelated to agentic development — use `WebSearch`
  directly.
- Summarising or publishing research findings to external channels — use the
  appropriate communication skill.

## Required Sources

Read these files before updating research artifacts:

- `~/.local/share/agents/docs/agentic-development-research-index.md`
- `~/.local/share/agents/docs/coding-agent-research/strategy.md` when the work
  is about near-term productivity or local/repo-level coding agent practice.
- `~/.local/share/agents/docs/agentic-software-delivery-research/strategy.md`
  when the work is about orchestration, cloud runtime, governance, or delivery
  architecture.

## Workflow

1. Read `~/.local/share/agents/docs/agentic-development-research-index.md` to
   orient to the current state of all tracks before doing anything else.
2. Classify the request as `coding-agent`, `agentic-software-delivery`, or
   both.
3. Read the matching track's `strategy.md` and `ledger.md`.
4. Use current official or primary sources for product behavior before relying
   on practitioner or community sources.
5. Update the track `ledger.md` with source-level evidence, status, freshness,
   and revalidation metadata.
6. Promote only reviewed findings into `Candidate Extraction` or
   `Strategic Watch Items`.
7. Record run-level summaries, candidate actions, and decisions under
   `~/.local/share/agents/docs/agentic-development-runs/YYYY-MM-DD/`.
8. Keep implementation changes separate. Do not edit AGENTS, skills, subagents,
   settings, evals, MCP configuration, or workflow scripts unless the user
   explicitly asks for that implementation step.

## Artifact Boundaries

- Strategy files define research policy.
- Ledgers store source-level evidence and status.
- Run directories store per-research-run summaries, candidate actions, and
  decisions.
- Temporary scripts belong under `$TMPDIR` or `/tmp`.
- Reusable scripts belong under `$XDG_DATA_HOME/agent-scripts/`, or
  `$HOME/.local/share/agent-scripts/` when `XDG_DATA_HOME` is unset.
- Runtime outputs and logs belong under `$XDG_STATE_HOME/agent-scripts/`, or
  `$HOME/.local/state/agent-scripts/` when `XDG_STATE_HOME` is unset.

## Output Format

After completing a research pass, return a structured summary containing:

1. **Track**: which track(s) were researched (`coding-agent` /
   `agentic-software-delivery` / both).
2. **Sources consulted**: list of files read and external sources checked, with
   freshness dates.
3. **Ledger changes**: which entries were added, updated, or flagged for
   revalidation, with evidence snippets.
4. **Candidate actions**: zero or more items promoted to `Candidate Extraction`
   or `Strategic Watch Items`, each with a one-line rationale.
5. **Run record location**: the path under
   `~/.local/share/agents/docs/agentic-development-runs/YYYY-MM-DD/` where the
   full run summary was written.
6. **Deferred items**: topics that required live network access or were out of
   scope for this pass, noted explicitly.

Do not return raw ledger dumps. Summarise changes; the ledger files are the
authoritative record.

## Agent-Specific Boundaries

Use skills for reusable workflow guidance. When running in Claude Code, use the
`agentic-development-researcher` subagent for isolated source scanning, triage,
and draft preparation when the research would consume substantial context. Do
not create wrapper scripts or hacks to imitate unavailable subagent features in
other coding agents.
