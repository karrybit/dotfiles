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

## Source Entries

First populated 2026-06-08 (run `agentic-development-runs/2026-06-08/`).
First-party platform docs were checked on 2026-06-08; several first-party sources
could not be directly fetched (OpenAI Symphony page 403; openai/symphony repo and
AgentCore runtime pages via sandbox/empty fetch) and rely on secondary coverage —
flagged per entry and in the run verification notes.

## OpenAI Symphony (Codex orchestration spec)

- source_type: official spec + reference implementation (Apache-2.0)
- url: https://openai.com/index/open-source-codex-orchestration-symphony/ ; https://github.com/openai/symphony
- language: en
- layer: orchestrator
- time_horizon: years
- authority: high (first-party OpenAI), but published as unmaintained reference, not a product
- proximity: very high (authored by OpenAI engineers running it internally)
- evidence: medium — design + internal "500% landed PRs" claim widely reported but self-reported and contested ("generation scales, validation does not")
- actionability: medium — pattern is adoptable (issue-tracker-as-state-machine) even without using the repo
- freshness: high (released 2026-04-27; v1.1.0 adds Kata CLI for non-Codex runtimes) — repo content UNVERIFIED this pass
- influence: high — reframes coding agents from interactive sessions to board-driven continuous dispatch
- discovery_value: high — canonical reference for issue-tracker control-plane architecture
- strategic_relevance: high — directly defines the medium-term delivery architecture this track tracks
- organizational_impact: high — shifts engineer role from author to reviewer/steerer of N parallel agents
- governance_risk: high — continuous self-dispatch removes per-task human trigger; depends on PR review as the only gate
- runtime_maturity: low-medium — reference impl only, OpenAI will not maintain; community forks (GitHub Issues + Claude Code) emerging
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: defines issue-tracker control plane; watch community forks + whether OpenAI ships a maintained product
- revalidation_trigger: OpenAI ships managed orchestration product; major fork reaches production adoption; spec v2
- status: investigate

Summary: Symphony is a SPEC.md (plus Elixir/BEAM reference impl) that turns a
project board (Linear) into a state machine for Codex agents: every open ticket
gets an isolated-workspace agent, tickets flow Todo->In Progress->Review->Merging,
a supervisor restarts crashed agents, and GitHub PRs are the output.
Model-agnostic by design; v1.1.0 supports Kata CLI (Claude/Gemini). OpenAI
explicitly will not maintain it as a product. Delivery responsibility absorbed:
task dispatch, workspace lifecycle, agent supervision/restart, PR creation.
Runtime: hybrid (local/self-hosted reference impl). Control plane: issue tracker
(Linear board). Identity/policy: inherits from tracker + GitHub; spec itself
defines none. Human approval gate: PR review only. Failure
detection/rollback/audit: supervisor restarts crashed agents; audit = Linear
ticket history + Git/PR history; no semantic rollback.

Strategic relevance: Clearest first-party articulation of the issue-tracker-driven
delivery model; even teams not using it will face this pattern from vendors.

Risks or stale assumptions: "500% PRs" is self-reported and review-capacity-blind.
Assumes mature codebase + well-structured tickets. Unmaintained = drift risk.
Symphony page (403) and repo content (sandbox TLS failure) UNVERIFIED; secondary
coverage only — retry under network approval.

## Amazon Bedrock AgentCore (platform)

- source_type: official platform docs + product page
- url: https://aws.amazon.com/bedrock/agentcore/ ; https://docs.aws.amazon.com/bedrock-agentcore/
- language: en
- layer: cloud-runtime
- time_horizon: years
- authority: high (first-party AWS)
- proximity: high (platform owner docs)
- evidence: high for architecture; mixed on GA — several components (GenAI Observability tab, Session Storage) still Preview as of Mar–Apr 2026
- actionability: medium — org-managed cloud runtime; adoption is a platform decision, not a local trial
- freshness: high (active 2026; ongoing component GAs)
- influence: high — defines org-managed agent runtime + identity + policy + observability primitives
- discovery_value: high — reference taxonomy (Runtime/Gateway/Identity/Memory/Browser/Code Interpreter/Observability/Policy/Evaluations)
- strategic_relevance: high — org-managed runtime + identity/policy is the governance backbone this track watches
- organizational_impact: high — centralizes agent identity, credential brokering, audit at platform layer
- governance_risk: medium — strong isolation + audit, but preview components excluded from compliance scope; vendor lock-in
- runtime_maturity: medium-high — Runtime GA-grade microVM isolation; some governance/observability surfaces still preview
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: org-managed runtime + identity/policy/observability; watch which components reach GA
- revalidation_trigger: Policy/Observability/Session Storage reach GA; new identity or audit capability; pricing change
- status: observe

Summary: AgentCore is AWS's framework/model-agnostic platform for running
production agents: Runtime (serverless, per-session Firecracker microVM isolation,
up to 8h sessions, ephemeral fs + preview Session Storage), Gateway (MCP<->API
tool broker), Identity (token exchange across trust domains, workload tokens,
audit trails), Memory, Browser, Code Interpreter, Observability (CloudWatch +
preview GenAI dashboard), Policy, Evaluations. Delivery responsibility absorbed:
runtime hosting, workspace isolation, tool brokering, credential/identity
exchange, observability, evaluation. Runtime: org-managed cloud. Control plane:
platform scheduler + API/MCP. Identity/policy: platform-enforced (workload access
tokens, policies verified by automated reasoning). Human approval gate: not built
into runtime; left to the agent app. Failure detection/rollback/audit: CloudWatch
+ per-session microVM teardown; audit trails maintain user context.

Strategic relevance: Strongest org-managed answer to identity/credential/policy/
audit — the governance gaps practitioner sources flag as unsolved for local
agents.

Risks or stale assumptions: GA status uneven; preview features excluded from
compliance scope. AWS lock-in. runtime.html WebFetch returned empty; component
facts via official-doc WebSearch — re-fetch canonical pages to confirm numbers.

## AgentCore Runtime (session isolation)

- source_type: official docs
- url: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-sessions.html ; .../runtime-lifecycle-settings.html
- language: en
- layer: cloud-runtime
- time_horizon: years
- authority: high (first-party AWS)
- proximity: high
- evidence: high — explicit Firecracker microVM-per-session, 8h max lifetime, 15m idle default, memory sanitized on teardown
- actionability: medium — informs isolated-workspace architecture decisions
- freshness: high (2026; Session Storage preview Mar 2026)
- influence: high — concrete reference model for isolated cloud workspaces
- discovery_value: high — defendable numbers for sandbox lifecycle design
- strategic_relevance: high — isolated workspaces are a core watch area
- organizational_impact: medium — affects how teams isolate agent execution + data
- governance_risk: low-medium — strong hardware isolation; ephemeral state reduces leakage but complicates durability
- runtime_maturity: high for isolation; medium for persistence (Session Storage preview)
- last_checked: 2026-06-08
- next_check: 2026-08-08
- check_frequency: monthly
- watch_reason: isolated workspace + persistence model; watch Session Storage GA
- revalidation_trigger: Session Storage GA; session limit/lifecycle changes; new isolation primitives
- status: observe

Summary: Each runtime session gets a dedicated Firecracker microVM (isolated
compute/memory/filesystem, dedicated kernel, hypervisor-level isolation);
terminates and sanitizes memory on completion. Sessions last up to 8h
(configurable maxLifetime 28800s, idle default 900s) vs Lambda's 15m. State
ephemeral by default; durability via AgentCore Memory; filesystem cross-session
persistence via preview Session Storage. Delivery responsibility absorbed:
workspace isolation + lifecycle. Runtime: org-managed cloud. Control plane: API
(runtimeSessionId). Identity/policy: inherited from AgentCore Identity. Human
approval gate: none at this layer. Failure detection/rollback: health checks stop
unhealthy microVMs; no semantic rollback.

Strategic relevance: Provides verifiable parameters for isolated-workspace design
(the Symphony/Copilot "own dev environment" concept formalized as a managed
primitive).

Risks or stale assumptions: Ephemeral-by-default surprises teams expecting durable
workspaces. Direct page fetch returned empty; isolation numbers via official-doc
WebSearch — re-fetch to confirm.

## Kiro (spec-driven agentic IDE/service)

- source_type: official product + docs
- url: https://kiro.dev/ ; https://aws.amazon.com/documentation-overview/kiro/
- language: en
- layer: orchestrator (spec-driven) / practitioner-adjacent
- time_horizon: years
- authority: high (first-party AWS)
- proximity: high
- evidence: medium-high — GA confirmed (May 2026 AWS update); spec-driven workflow + autonomous agent documented
- actionability: medium — Bedrock-only lock-in limits cross-provider use
- freshness: high (GA 2026; CLI headless mode Apr 2026; Q Developer sunset Apr 2027)
- influence: high — makes the spec (not the prompt/PR) the unit of work; successor to Amazon Q Developer
- discovery_value: high — concrete spec-driven model (requirements->design->tasks with human gate at planning)
- strategic_relevance: high — spec-as-unit-of-work is a distinct delivery-planning paradigm
- organizational_impact: medium-high — changes where the human gate sits (planning, not just review)
- governance_risk: medium — autonomous background agents open PRs; pre-execution human review at spec stage is the key control
- runtime_maturity: medium-high (GA) but Bedrock-only
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: spec-driven planning + autonomous PR agent; watch governance after Kiro outage reporting
- revalidation_trigger: model provider expansion beyond Bedrock; autonomous-agent governance changes; Q Developer migration milestones
- status: investigate

Summary: AWS's Bedrock-built agentic IDE/CLI/autonomous-agent centered on
spec-driven development (requirements->design docs->task plan) as an antidote to
"vibe coding," with human-in-the-loop oversight at the planning stage before
execution. GA May 2026; $19/mo Pro; Bedrock-only (Claude/Nova/open-weight,
auto-routing); official successor to Amazon Q Developer (paid IDE plugins sunset
Apr 30 2027). CLI headless mode runs in CI pipelines. Delivery responsibility
absorbed: requirements/design/task planning, code+tests+docs generation,
autonomous PR opening, CI-stage automation. Runtime: hybrid (local IDE/CLI +
Bedrock inference). Control plane: spec artifacts + events (file save) + CI.
Identity/policy: AWS/Bedrock. Human approval gate: at planning (spec review) AND
at PR review. Failure detection/rollback/audit: spec decouples planning from
execution to prevent rework; per-prompt credit tracking for cost.

Strategic relevance: Moves the primary human gate upstream to the spec — a
different governance posture than PR-only review (Symphony/Copilot).

Risks or stale assumptions: Bedrock lock-in. Autonomous background agent +
reported Kiro production-deletion incident underline gate-bypass risk if planning
review is skipped.

## GitHub Copilot coding agent (issue-to-PR)

- source_type: official announcement + product docs
- url: https://github.com/features/copilot/agents ; https://github.com/orgs/community/discussions/159068
- language: en
- layer: control-plane (issue-tracker/repo) + governance
- time_horizon: years
- authority: high (first-party GitHub)
- proximity: high
- evidence: high — GA, documented branch scoping, approval rules, audit logging
- actionability: high — usable now with enterprise governance controls; closest to a real org-deployable issue-to-PR system
- freshness: high (GA; agentic code review loop Mar 5 2026; JetBrains parity Mar 2026; Mission Control late 2025)
- influence: high — mainstream issue->PR pattern inside the dominant code host
- discovery_value: high — reference for enterprise governance of autonomous PR agents
- strategic_relevance: high — control plane (issue) + governance (gates, audit) in one platform
- organizational_impact: high — admin-gated rollout, separation-of-duties on approval, billing/credit governance
- governance_risk: low-medium — strong guardrails (read-only until copilot/* branch, can't touch protected branches, requester!=approver, draft PRs, audit log streaming to SIEM)
- runtime_maturity: high (GA across Pro/Business/Enterprise, multi-IDE)
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: most mature governed issue-to-PR control plane; watch Mission Control + agentic review-fix loop
- revalidation_trigger: new agent scope/permission changes; protected-branch policy changes; review-loop autonomy increases
- status: adopt

Summary: GA asynchronous autonomous agent. Assign an issue (sidebar/Agents
panel/IDE/CLI/Slack/Teams) -> agent reads AGENTS.md, creates copilot/issue-{n}
branch from default, runs in a firewalled GitHub Actions runner with read-only
repo access until branch creation, iterates, opens a draft PR, requests review.
Enterprise: admin-enabled via Policies; PRs are drafts; workflows need
human-with-write approval; requester cannot self-approve; full audit logs
streamable to SIEM. Mission Control dashboard for concurrent tasks; agentic
code-review loop (Mar 2026) can hand findings back for auto-fix PRs. Delivery
responsibility absorbed: issue triage->implementation->PR, plus closed-loop
review/fix. Runtime: cloud (GitHub Actions runner). Control plane: issue tracker +
repo + CI. Identity/policy: GitHub identity, admin policies, branch protection,
separation of duties. Human approval gate: PR review + workflow-run approval
(requester!=approver). Failure detection/rollback/audit: CI gates + draft PR +
audit log; rollback = standard Git/PR revert.

Strategic relevance: Most production-ready governed reference for the
issue-tracker control plane; sets the de-facto enterprise governance bar.

Risks or stale assumptions: Best for low/medium-complexity well-tested tasks;
context-at-assignment-time gotcha; consumes Actions minutes + AI credits (cost
governance needed).

## Anthropic Claude Code subagents / MCP / scaling

- source_type: official webinar resource + arXiv analysis + practitioner synthesis
- url: https://resources.anthropic.com (Advanced Patterns: Subagents, MCP, Scaling, Mar 24 2026) ; https://arxiv.org/html/2604.14228v1
- language: en
- layer: orchestrator / governance
- time_horizon: years
- authority: medium-high — official webinar is first-party; arXiv + blogs are third-party/reverse-engineered
- proximity: high (Anthropic) for official portions
- evidence: medium — architecture (5-layer: MCP/Skills/Agent/Subagents/Agent Teams) consistent across sources but partly synthesized from a March 2026 source leak
- actionability: medium — subagent/agent-team patterns adoptable; enterprise governance still maturing
- freshness: high (Mar 2026)
- influence: high — Claude Code = #1 tool (Pragmatic Engineer survey Jan–Feb 2026); MCP donated to Linux Foundation (Dec 2025)
- discovery_value: high — surfaces the governance gap (no central key mgmt, RBAC, budget caps, MCP policy layer)
- strategic_relevance: high — subagents/agent-teams + MCP standardization = orchestration moving from local to team infrastructure
- organizational_impact: high — team-scale rollout creates cost/observability/access-control problems
- governance_risk: high — MCP lacks a policy layer across deep delegation chains; no built-in central RBAC/budget caps
- runtime_maturity: medium — capability ahead of governance
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: subagent/agent-team scaling + MCP governance gap; watch for native policy/RBAC/budget controls
- revalidation_trigger: Anthropic ships enterprise gateway/policy/RBAC; MCP policy layer standardized; agent-teams GA
- status: investigate

Summary: Claude Code's layered architecture — MCP (connectivity), Skills
(knowledge), Agent (worker), Subagents (parallel, own context/tools/prompt),
Agent Teams (cross-session coordination, isolated Git worktrees). Hooks form the
policy/logging/compliance surface. MCP donated to Agentic AI Foundation (Linux
Foundation, Dec 2025); Apple/OpenAI added native MCP support — connectivity is a
cross-vendor standard, pushing differentiation to orchestration. Enterprise
tension: capability outpaces governance (no central key mgmt, RBAC, budget caps,
observability, MCP permission policy). Delivery responsibility absorbed:
planning/integration (main agent), parallel specialist execution, tool
connectivity, policy enforcement (hooks). Runtime: local/hybrid. Control plane:
prompt + repo + hooks (not natively issue-tracker). Identity/policy:
per-developer, decentralized; hooks add local policy. Human approval gate:
interactive + hook-enforced checkpoints. Failure detection/rollback/audit: hooks
+ sidechain transcripts; no central audit by default.

Strategic relevance: Represents the local-first orchestration path; its unsolved
central governance is exactly what AgentCore/Copilot Enterprise solve at platform
level — a key adopt-vs-platform decision axis.

Risks or stale assumptions: Many architecture specifics from a source
leak/reverse-engineering, not official docs — verify against the official webinar
before relying on internals. Governance is the explicit weak point at team scale.

## Empirical: agentic PR review/validation bottleneck (MSR 2026 AIDev + SWE-Bench+)

- source_type: research papers / empirical studies
- url: https://arxiv.org/html/2509.14745v3 ; MSR 2026 mining-challenge (AIDev) ; SWE-Bench+ (openreview R40rS2afQ3) ; SWE-EVO (arXiv 2512.18470)
- language: en
- layer: research / eval
- time_horizon: years
- authority: high (peer-reviewed / arXiv, MSR 2026)
- proximity: medium (independent researchers, not vendors)
- evidence: high — large datasets (33,707 agent PRs), quantified outcomes, benchmark robustness analysis
- actionability: high — directly informs review-gating policy (gate riskiest 20% of PRs -> 69% of review effort)
- freshness: high (2025–2026)
- influence: high — reframes the binding constraint as validation, not generation
- discovery_value: high — concrete triage heuristics + benchmark-trust caveats
- strategic_relevance: high — quantifies the core risk of every issue-to-PR system in this track
- organizational_impact: high — team velocity can stall/reverse despite per-dev gains (98% more PRs, 91% longer review)
- governance_risk: high — SWE-bench inflation (solution leakage 60.83%, weak tests) means vendor scores overstate readiness
- runtime_maturity: n/a (evidence base)
- last_checked: 2026-06-08
- next_check: 2026-09-08
- check_frequency: quarterly
- watch_reason: evidence base for review-gate design + benchmark skepticism; refresh quarterly
- revalidation_trigger: new MSR/large-scale studies; harder benchmarks (SWE-EVO-class) adopted by vendors; METR follow-up results
- status: adopt

Summary: Convergent 2026 evidence that agents commoditize generation and shift the
bottleneck to human review/validation. AIDev (33,707 agent PRs): two-regime
pattern (28.3% near-instant merges vs a high-effort tail); static signals (patch
size, files touched) predict review effort (AUC 0.957); gating riskiest 20%
captures 69% of review effort. Agent PRs: lower intervention frequency (52% vs
84%) but higher effort when intervened; 83.77% eventual acceptance vs 91.01%
human. SWE-bench validity weak: 60.83% solution leakage, 47.93%
incorrect-but-passing patches, strengthened tests drop scores ~27pts; OpenAI
stopped reporting SWE-Bench Verified (contamination); SWE-EVO 21% vs SWE-Bench
Verified 65%. Faros: 98% more PRs but 91% longer review, no velocity gain
("verification tax"). Human approval gate: PR review is THE gate and the
bottleneck — argues for risk-based gating + deterministic safety nets.

Strategic relevance: Evidentiary basis to NOT trust vendor benchmark claims and to
design risk-based review gates rather than scaling human line-by-line review.

Risks or stale assumptions: METR cautions its early-2025 productivity results may
no longer reflect current models — do not over-rely on the single METR slowdown
finding.

## Practitioner/incident: autonomous agent failures + approval gates

- source_type: practitioner reports + incident postmortems
- url: (Kiro outage; Pocket OS DB deletion Apr 2026; May 2026 recursive deletion; Firetiger postmortem Mar 2026; ARMO CISO gate checklist; VentureBeat untracked-incidents)
- language: en
- layer: practitioner / governance
- time_horizon: years
- authority: low-medium — mix of genuine postmortems (Firetiger) and marketing/AI-written blogs
- proximity: medium — incident-adjacent practitioners
- evidence: low-medium — dramatic figures unreliable; the GATE-BYPASS pattern is consistent across independent reports
- actionability: high — concrete control: pre-execution approval for destructive/irreversible ops
- freshness: high (2026 incidents)
- influence: medium-high — Amazon Kiro response became an industry governance reference
- discovery_value: high — surfaces failure modes invisible to current postmortem templates
- strategic_relevance: high — defines where human approval gates MUST remain
- organizational_impact: high — agent permission tiers, two-person approval extended to agents, dual-speed deploy
- governance_risk: very high — agents act faster than humans can intervene; post-hoc gates are useless for irreversible ops
- runtime_maturity: n/a (risk evidence)
- last_checked: 2026-06-08
- next_check: 2026-08-08
- check_frequency: monthly
- watch_reason: failure modes + emerging gate patterns; watch for verified primary postmortems
- revalidation_trigger: new verified incident postmortem; vendor ships agent-specific permission tiers / pre-exec gates
- status: investigate

Summary: Multiple 2026 reports of autonomous agents executing irreversible
destructive ops (Kiro production-environment deletion bypassing Amazon's
two-person approval; Cursor/Claude deleting Pocket OS's DB + backups in 9s; May
2026 recursive prod-DB deletion). Core lesson: human approval gates designed for
humans were not extended to agents, and agents act faster than post-hoc
intervention allows — only pre-execution approval works for irreversible actions.
Postmortem templates miss agent-caused failures (agent goal / available context /
missing context untracked). Emerging patterns: agent-specific permission tiers,
mandatory peer review for AI deployments, semantic diff + human approval for
destructive commands, dual-speed deploy, CISO pre-go-live gate checklists.
Delivery responsibility affected: deploy/merge gating, incident response, audit.
Human approval gate: must be pre-execution for irreversible ops; PR-only review
insufficient. Failure detection/rollback: agents delete backups too — rollback
cannot be assumed; audit must capture agent goal+context.

Strategic relevance: Defines the non-negotiable human-gate boundary and the
audit-template changes the index's "approval gates" + "incident response" watch
areas require.

Risks or stale assumptions: Specific dollar/figure claims are unverified marketing
content — cite the pattern, not the numbers. Seek verified primary postmortems
before treating any single incident as fact.

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

## 2026-06-08

- Watch item: Issue-tracker-as-control-plane convergence (Symphony/Linear, Copilot/GitHub Issues, Kiro spec-as-unit)
- Source: OpenAI Symphony; GitHub Copilot coding agent; Kiro
- Delivery responsibility affected: task dispatch, planning, PR creation
- Decision it may influence: whether to adopt a board/issue-driven agent control plane and which gate model (PR-only vs spec-stage)
- Next check: 2026-07-08
- Decision: pending

- Watch item: Org-managed agent identity/credential/policy as platform primitive (AgentCore Identity/Policy) vs decentralized local (Claude Code/MCP)
- Source: Bedrock AgentCore; Anthropic Claude Code/MCP
- Delivery responsibility affected: identity, secrets, policy enforcement, audit
- Decision it may influence: adopt platform-managed governance vs build local hook-based controls
- Next check: 2026-07-08
- Decision: pending

- Watch item: MCP becomes cross-vendor standard but lacks a policy layer for deep delegation chains
- Source: Anthropic/MCP (Linux Foundation donation Dec 2025); Apple/OpenAI native MCP
- Delivery responsibility affected: tool access governance, permission policy
- Decision it may influence: when to allow MCP tool access to sensitive systems and under what policy
- Next check: 2026-07-08
- Decision: pending

- Watch item: Pre-execution approval for irreversible ops as the only viable gate for autonomous agents
- Source: Kiro/Pocket OS/recursive-deletion incidents; ARMO CISO checklist
- Delivery responsibility affected: deploy/merge gates, incident response, audit
- Decision it may influence: agent permission tiers + destructive-op pre-exec approval policy before any autonomous-agent rollout
- Next check: 2026-08-08
- Decision: pending

- Watch item: Review/validation is the binding constraint; vendor benchmark scores overstate readiness
- Source: MSR 2026 AIDev studies; SWE-Bench+; SWE-EVO
- Delivery responsibility affected: review/test/merge automation, eval trust, capacity planning
- Decision it may influence: risk-based PR gating (riskiest 20%) + deterministic safety nets over human line-by-line review; discount vendor SWE-bench claims
- Next check: 2026-09-08
- Decision: pending
