# Agentic Development Research Index

Source URLs:

- https://openai.com/index/open-source-codex-orchestration-symphony/
- https://aws.amazon.com/bedrock/agentcore/
- https://aws.amazon.com/documentation-overview/kiro/
- https://www.cs.uml.edu/~haim/teaching/iws/tirsaa/sources/google/PageRank_Citation_cover.html
- https://www.nsf.gov/impacts/google

Date checked: 2026-06-06

Context: Index for recurring research on coding agents and agentic software
delivery. This file keeps short-term productivity research separate from
longer-term software-delivery architecture research while preserving links
between them.

Revalidate when: OpenAI, Anthropic, AWS, GitHub, Google, or other major coding
agent providers change agent docs, release notes, cloud runtimes,
orchestration specs, repository integrations, MCP guidance, policy controls, or
agent evaluation practices.

## Purpose

Maintain a recurring research system for agentic development instead of a
one-time source list. The system has two tracks with different time horizons:

- `coding-agent`: near-term improvements to individual and repository-level
  coding workflows.
- `agentic-software-delivery`: medium- to long-term changes in how software
  delivery is planned, executed, reviewed, governed, and observed.

The two tracks should share source discovery, but not collapse into one ledger.
Short-term tool practices can become long-term architecture signals. Long-term
platform changes can create near-term experiments.

## Layout

```text
agentic-development-research-index.md
coding-agent-research/
  strategy.md
  ledger.md
agentic-software-delivery-research/
  strategy.md
  ledger.md
agentic-development-runs/
  YYYY-MM-DD/
    research-summary.md
    candidate-actions.md
    decision-log.md
```

## Tracks

| Track | Time horizon | Primary question | Ledger |
| --- | --- | --- | --- |
| `coding-agent` | Days to weeks | What can improve local or repo-level engineering productivity now? | `coding-agent-research/ledger.md` |
| `agentic-software-delivery` | Months to years | How are agents absorbing the software delivery process itself? | `agentic-software-delivery-research/ledger.md` |

## Recurring Cycle

Run each research pass as a cycle:

1. `scan`: Check official docs, release notes, repositories, papers, and
   practitioner sources.
2. `triage`: Classify new, updated, stale, duplicate, and rejected sources.
3. `ledger update`: Update source entries, dates, status, and watch fields.
4. `candidate extraction`: Separate near-term trials from strategic watch
   items.
5. `decision review`: Decide what to adopt, trial, observe, hold, or reject.

Use different cadences by source type:

- Fast-moving official changelogs and cloud runtime announcements: monthly or
  sooner when relevant to an active decision.
- Coding agent practice sources and implementation-proximate repos: monthly.
- Research papers, architecture essays, and stable docs: quarterly unless a
  release changes their assumptions.

## Cross-Track Rules

- Promote a `coding-agent` finding into `agentic-software-delivery` when it
  points to persistent orchestration, cloud execution, governance, identity,
  audit, or organizational workflow changes.
- Pull an `agentic-software-delivery` finding into `coding-agent` when it
  suggests a low-cost local trial, instruction change, evaluation, or workflow
  experiment.
- Keep provider-specific tool setup in the near-term track unless it changes a
  broader delivery architecture decision.
- Treat first-party and official sources as the authority for product behavior.
- Treat practitioners and first movers as discovery sources for practices,
  failure modes, adoption criteria, and tacit operational knowledge.

## Artifact Placement

- Strategy files live inside each track directory as `strategy.md`. They define
  research scope, source priority, and scoring criteria.
- Ledger files live inside each track directory as `ledger.md`. They store
  source-level evidence, evaluation, freshness, and status.
- Run-level artifacts live under `agentic-development-runs/YYYY-MM-DD/`. They
  store the summary, candidate actions, and decisions for a specific research
  run.
- Skills should contain reusable research procedure only. Do not store source
  entries, decision history, or copied external content in skill files.
- Subagents should perform isolated research, triage, and draft preparation.
  They should return summaries and proposed edits for the main agent to review.
- Write-once temporary scripts belong under `$TMPDIR` or `/tmp`.
- Scripts that must survive across sessions belong under
  `$XDG_DATA_HOME/agent-scripts/`, or
  `$HOME/.local/share/agent-scripts/` when `XDG_DATA_HOME` is unset.
- Runtime outputs, logs, scraped pages, and disposable intermediates belong
  under `$XDG_STATE_HOME/agent-scripts/`, or
  `$HOME/.local/state/agent-scripts/` when `XDG_STATE_HOME` is unset.
- Adopted implementation changes belong in their real target surfaces, such as
  AGENTS files, skills, subagents, settings, evals, MCP configuration, or
  workflow scripts.

## Watch Areas

- Human-in-the-loop boundaries and approval gates.
- Issue tracker or project board control planes.
- Isolated workspaces, cloud execution, and sandboxing.
- Agent identity, delegated credentials, and policy enforcement.
- Review, test, and merge automation.
- Observability, traceability, cost, and incident response.
- Durable local guidance: AGENTS, skills, subagents, hooks, MCP, evals, and
  workflow checklists.
