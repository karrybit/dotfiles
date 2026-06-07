---
name: agentic-development-research
description: Run recurring research on coding agents and agentic software delivery. Use when updating agentic development source ledgers, extracting trial candidates or strategic watch items, or deciding where to store research artifacts.
---

# Agentic Development Research

Use this skill to run the recurring research workflow defined in the shared
agent docs cache. Do not store research results in this skill.

## Required Sources

Read these files before updating research artifacts:

- `~/.local/share/agents/docs/agentic-development-research-index.md`
- `~/.local/share/agents/docs/coding-agent-research/strategy.md` when the work
  is about near-term productivity or local/repo-level coding agent practice.
- `~/.local/share/agents/docs/agentic-software-delivery-research/strategy.md`
  when the work is about orchestration, cloud runtime, governance, or delivery
  architecture.

## Workflow

1. Classify the request as `coding-agent`, `agentic-software-delivery`, or
   both.
2. Read the matching track's `strategy.md` and `ledger.md`.
3. Use current official or primary sources for product behavior before relying
   on practitioner or community sources.
4. Update the track `ledger.md` with source-level evidence, status, freshness,
   and revalidation metadata.
5. Promote only reviewed findings into `Candidate Extraction` or
   `Strategic Watch Items`.
6. Record run-level summaries, candidate actions, and decisions under
   `~/.local/share/agents/docs/agentic-development-runs/YYYY-MM-DD/`.
7. Keep implementation changes separate. Do not edit AGENTS, skills, subagents,
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

## Codex Boundary

Use Codex skills for reusable workflow guidance. Do not create wrapper scripts
or other hacks to imitate Claude Code subagents.
