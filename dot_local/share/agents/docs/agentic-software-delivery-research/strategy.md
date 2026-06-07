# Agentic Software Delivery Research Strategy

Source URLs:

- https://openai.com/index/open-source-codex-orchestration-symphony/
- https://aws.amazon.com/bedrock/agentcore/
- https://aws.amazon.com/documentation-overview/kiro/
- https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/code-interpreter-tool.html
- https://aws.amazon.com/blogs/machine-learning/securely-launch-and-scale-your-agents-and-tools-on-amazon-bedrock-agentcore-runtime/

Date checked: 2026-06-06

Context: Recurring research strategy for medium- and long-term changes in how
software delivery is planned, executed, reviewed, governed, and observed by
agentic systems.

Revalidate when: Agent orchestrators, cloud runtimes, issue-to-PR systems,
policy controls, identity systems, code execution sandboxes, browser tools, or
observability surfaces change.

## Purpose

Track the shift from coding agents as interactive local tools to agentic
software delivery systems that absorb larger parts of the development process.
This includes orchestration specs, issue-tracker control planes, cloud
execution, agent runtimes, identity, governance, observability, and human
approval boundaries.

The output should be a maintained source ledger plus strategic watch items and
architecture notes. Do not reduce this track to local tool settings; local
experiments belong in the `coding-agent` track unless they change a delivery
architecture decision.

## Scope

Include sources about:

- Issue tracker, project board, or backlog driven agent orchestration.
- Persistent or autonomous coding workflows.
- Cloud agent runtimes, isolated workspaces, browser tools, and code
  interpreters.
- Agent identity, delegated credentials, policy controls, and audit.
- Human approval gates, review automation, testing, merge workflows, and
  incident response.
- Observability, traces, evaluation, cost controls, and operational readiness.
- Organization-level adoption criteria and risk models.

Exclude or hand off to `coding-agent` when the source is primarily about
single-user productivity, local prompts, repo instruction files, local hooks,
or a small reversible workflow improvement.

## Source Priority

1. Official specs, platform docs, architecture docs, release notes, and
   product engineering posts.
2. Maintainer, employee, and contributor sources close to orchestrators,
   runtimes, policy systems, and coding-agent integrations.
3. Research papers and empirical studies on coding agents, orchestration,
   software engineering impact, evaluation, and risk.
4. Practitioner and early-adopter reports with implementation details, failure
   cases, or adoption criteria.
5. Community sources that reveal concrete buried practices or incidents.

## Recurring Research Process

1. Refresh the official baseline for orchestration, cloud runtime, policy,
   identity, sandbox, and observability surfaces.
2. Scan first-party repositories, specs, changelogs, and example deployments.
3. Review papers and empirical studies for evaluation methods, adoption risks,
   and software engineering impact.
4. Track practitioner reports for early operational failure modes and adoption
   criteria.
5. Update `ledger.md` with source status and next-check metadata.
6. Extract strategic watch items, architecture hypotheses, risk controls, and
   possible local experiments.
7. Hand off low-cost local experiments to the `coding-agent` track.

## Strategic Evaluation Criteria

Assess each source by:

- Which software delivery responsibility it absorbs.
- Whether the runtime is local, cloud, hybrid, or organization-managed.
- What control plane it uses: prompt, repo, issue tracker, CI, project board,
  or platform scheduler.
- How identity, secrets, permissions, and policy are enforced.
- Where human approval gates remain.
- How failures are detected, attributed, rolled back, and audited.
- Whether adoption would change local workflow, team process, or platform
  architecture.
