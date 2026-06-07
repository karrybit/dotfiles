# Agentic Software Delivery Source Ledger

Date created: 2026-06-06

Context: Maintained ledger for medium- and long-term agentic software delivery
research. Use with `strategy.md`.

## Status Values

- `adopt`: Ready to inform a local or architectural decision.
- `trial`: Ready for a bounded experiment.
- `investigate`: Worth deeper review before a decision.
- `observe`: Watch for maturity, evidence, or provider changes.
- `hold`: Not actionable now, but not rejected.
- `reject`: Do not use as a basis for decisions.

## Entry Template

```md
## <name>

- source_type:
- url:
- language:
- layer: orchestrator / cloud-runtime / control-plane / governance / eval / research / practitioner
- time_horizon: months / years
- authority:
- proximity:
- evidence:
- actionability:
- freshness:
- influence:
- discovery_value:
- strategic_relevance:
- organizational_impact:
- governance_risk:
- runtime_maturity:
- last_checked:
- next_check:
- check_frequency:
- watch_reason:
- revalidation_trigger:
- status: adopt / trial / investigate / observe / hold / reject

Summary:

Strategic relevance:

Risks or stale assumptions:
```

## Initial Source Queue

Use this queue for the first full research pass. Add entries only after
checking the current source state.

- OpenAI Symphony announcement and specification.
- OpenAI Codex cloud, app, and orchestration-related release notes.
- Amazon Bedrock AgentCore platform docs.
- Amazon Bedrock AgentCore Runtime, Gateway, Identity, Memory, Browser, Code
  Interpreter, Observability, and policy controls.
- Kiro documentation for specs, autonomous workflows, and Bedrock-backed
  coding service behavior.
- GitHub issue-to-PR agent and Copilot coding agent announcements.
- Anthropic Claude Code enterprise, subagent, MCP, and scaling materials when
  they affect delivery architecture.
- Empirical papers on coding agents, agentic refactoring, orchestration, and
  software engineering productivity or risk.
- Public reports on autonomous agent failures, approval gates, or operational
  controls.
- Practitioner architecture writeups for issue-tracker control planes, cloud
  workspaces, and multi-agent delivery systems.

## Strategic Watch Items

This section stores only watch items promoted from source entries. Keep source
evaluation in ledger entries and final decisions in the run-level decision log.

```md
## <date>

- Watch item:
- Source:
- Delivery responsibility affected:
- Decision it may influence:
- Next check:
- Decision:
```
