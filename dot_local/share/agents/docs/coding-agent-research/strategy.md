# Coding Agent Research Strategy

Source URLs:

- https://developers.openai.com/codex/codex-manual.md
- https://github.com/openai/skills
- https://code.claude.com/docs/
- https://github.blog/changelog/2026-02-26-claude-and-codex-now-available-for-copilot-business-pro-users/
- https://resources.anthropic.com/hubfs/Claude%20Code%20Advanced%20Patterns_%20Subagents%2C%20MCP%2C%20and%20Scaling%20to%20Real%20Codebases.pdf

Date checked: 2026-06-06

Context: Recurring research strategy for near-term coding agent practices that
can improve individual and repository-level engineering productivity.

Revalidate when: Coding agent docs, CLI behavior, IDE integrations, skills,
subagents, MCP guidance, hooks, eval tooling, or repository instruction formats
change.

## Purpose

Track practical coding agent practices that can improve local and repo-level
workflows within days or weeks. This track covers tools such as Codex, Claude
Code, Kiro, Cursor, Gemini CLI, GitHub Copilot coding agents, and similar
systems, but the goal is productivity and reliability rather than tool
comparison.

The output should be a maintained source ledger plus trial candidates. Do not
turn a finding into durable local instructions, skills, or workflow changes
until the source entry has been reviewed.

## Scope

Include sources about:

- Agent instructions, AGENTS.md, CLAUDE.md, steering rules, and repo guidance.
- Skills, subagents, plugins, hooks, MCP servers, and connector usage.
- Review loops, test loops, planning modes, multi-agent delegation, and
  recovery patterns.
- Local and repo-level evaluation of agent behavior.
- Practitioner workflows with concrete commands, failure cases, or measured
  effects.

Exclude or hand off to `agentic-software-delivery` when the primary topic is
cloud runtime, issue-tracker orchestration, organizational governance, policy
controls, or autonomous delivery architecture.

## Source Priority

1. Official docs, manuals, release notes, changelogs, guides, and official
   repositories.
2. Implementation-proximate employees, maintainers, contributors, product
   owners, developer relations staff, and official speakers.
3. Practitioner sources with reproducible workflows, concrete examples,
   failure analysis, or measured outcomes.
4. Community writeups, dotfiles, public repositories, issue comments, and
   Japanese-language sources.
5. Low-influence buried sources with unusually strong local applicability.

Influence is a discovery signal, not final authority. Use citations, forks,
mentions, adoption examples, and repeated references to find sources, then
score them by authority, proximity, evidence, freshness, and actionability.

## Recurring Research Process

1. Refresh official baseline sources for currently used tools.
2. Scan implementation-proximate people and repositories for changed practices.
3. Search practitioner sources in English and Japanese, including known
   candidates such as mizchi, but evaluate specific source material rather than
   names alone.
4. Run a buried-source pass for low-visibility repos, Zenn posts, issue
   comments, and small workflow writeups.
5. Update `ledger.md` with source status and next-check metadata.
6. Extract `trial` candidates only when the source is current enough and the
   expected local cost is low.
7. Escalate broader orchestration, runtime, or governance signals to the
   agentic software delivery track.

## Trial Criteria

Prefer a near-term trial when a source is:

- Current for the relevant tool surface.
- Reproducible in a local or repo-level workflow.
- Cheap to reverse.
- Connected to a real local pain point.
- Verifiable by tests, evals, command output, or before/after workflow checks.

Hold or observe sources that are promising but too broad, stale, unverified,
expensive to adopt, or better suited to the long-term track.
