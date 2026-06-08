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

## Source Entries

First populated 2026-06-08 (run `agentic-development-runs/2026-06-08/`).
Official-doc entries were freshly fetched on 2026-06-08; unverified sources are
flagged in `freshness`/`Risks` and in the run verification notes.

## Codex Manual and Customization Guidance

- source_type: official documentation (manual)
- url: https://developers.openai.com/codex/codex-manual.md
- language: en
- layer: tool
- time_horizon: days
- authority: high (OpenAI first-party)
- proximity: maintainer/product
- evidence: high (concrete config.toml keys, slash commands, file paths)
- actionability: high
- freshness: current (references gpt-5.5, granular approvals, goal/plan modes as of 2026-06)
- influence: high
- discovery_value: medium
- local_applicability: high (defines AGENTS.md, config.toml, profiles, hooks for Codex used locally)
- trial_cost: low
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: Codex config surface (approval_policy granular form, profiles, hooks.json, goal/plan modes) changes frequently
- revalidation_trigger: Codex CLI minor version bump or changelog entry touching config/AGENTS/hooks/skills
- status: adopt

Summary: Current Codex manual confirms repo guidance via AGENTS.md
(`~/.codex/AGENTS.md`, `.codex/AGENTS.md`, subdir overrides), persistent config
in `config.toml` (user/project/profile), granular approval policy,
`[mcp_servers]`, hooks (`~/.codex/hooks.json`, events incl. PreToolUse),
profiles (`--profile`), and workflow modes `/plan`, `/goal`, `/review`. Verified
by fetch on 2026-06-08, not memory.

Local applicability: Directly governs how this user's Codex setup should
structure AGENTS.md layering, profiles for deep-review, and hook-based command
validation.

Risks or stale assumptions: Some features gated by flags
(`features.goals = true`); product surface moves monthly, so specific keys may
drift.

## Codex Agent Skills (Official)

- source_type: official documentation
- url: https://developers.openai.com/codex/skills
- language: en
- layer: tool
- time_horizon: days
- authority: high (OpenAI first-party)
- proximity: maintainer/product
- evidence: high (frontmatter spec, discovery path table, installer commands)
- actionability: high
- freshness: current (skills GA on Codex; open-standard alignment)
- influence: high
- discovery_value: high (corrects skill path assumption)
- local_applicability: high (same SKILL.md works across Codex + Claude Code)
- trial_cost: low
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: skill discovery paths, openai.yaml policy schema, and installer behavior are evolving
- revalidation_trigger: change to agentskills.io standard or Codex skills doc revision
- status: trial

Summary: Codex skills use `SKILL.md` (frontmatter: `name`, `description`)
discovered from `.agents/skills` (cwd), `$REPO_ROOT/.agents/skills`,
`$HOME/.agents/skills`, `/etc/codex/skills`, plus bundled. Invocation explicit
(`$skill-name`, `/skills`) or implicit (description match). `agents/openai.yaml`
controls `allow_implicit_invocation` and tool deps. `$skill-creator` /
`$skill-installer <name>` manage skills. Follows agentskills.io open standard.
Verified by fetch 2026-06-08.

Local applicability: This user already maintains skills for Claude Code; the
shared open standard means a single SKILL.md authored under the standard can
serve both tools. Confirms canonical path is `~/.agents/skills`, NOT
`~/.codex/skills`.

Risks or stale assumptions: Implicit invocation is probabilistic;
`agents/openai.yaml` schema may change. Requires Codex restart to pick up new
skills.

## OpenAI Skills Repository

- source_type: official repository
- url: https://github.com/openai/skills (README via raw.githubusercontent.com/openai/skills/main/README.md)
- language: en
- layer: community/tool
- time_horizon: days
- authority: high (OpenAI-owned repo)
- proximity: maintainer
- evidence: medium (README only; full tree not enumerated this pass)
- actionability: medium
- freshness: current (README fetched 2026-06-08; per-skill LICENSE.txt)
- influence: high
- discovery_value: high (reference skill implementations + installer mechanics)
- local_applicability: medium (vet before vendoring per user extension policy)
- trial_cost: low-medium (must inspect skills before install)
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: curated/experimental skill catalog and skill-installer conventions evolve
- revalidation_trigger: new curated skills or installer interface change
- status: investigate

Summary: Repo organizes skills into `skills/.system/` (auto-included),
`skills/.curated/` (vetted, manual install by name), `skills/.experimental/`
(explicit folder or GitHub URL). Install: `$skill-installer
gh-address-comments`; experimental via `$skill-installer install <github tree
URL>`. Restart Codex to load. Per-skill `LICENSE.txt`. README verified via raw;
HTML page and full file tree UNVERIFIED (WebFetch 504, gh api blocked by sandbox
TLS cert) — retry under network approval before vendoring any skill.

Local applicability: Candidate source of vetted skills to adapt, but user policy
requires vetting each extension (vet-agent-extension) and recording provenance
before vendoring.

Risks or stale assumptions: Did not enumerate actual skill list/refs this pass;
licenses vary per skill; must not vendor unclear-license skills.

## Claude Code Skills Documentation

- source_type: official documentation
- url: https://code.claude.com/docs/en/skills
- language: en
- layer: tool
- time_horizon: days
- authority: high (Anthropic first-party)
- proximity: maintainer/product
- evidence: high (full frontmatter reference, lifecycle, substitutions)
- actionability: high
- freshness: current (min-version notes e.g. v2.1.145; fetched in full 2026-06-08)
- influence: high
- discovery_value: high
- local_applicability: high (user maintains Claude Code skills already)
- trial_cost: low
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: skill frontmatter fields, context:fork, dynamic injection, skillOverrides change often
- revalidation_trigger: Claude Code minor version touching skills/commands
- status: adopt

Summary: Custom commands merged into skills; `SKILL.md` in
`~/.claude/skills/<name>/` (personal) or `.claude/skills/<name>/` (project). Key
frontmatter: description, when_to_use, disable-model-invocation, user-invocable,
allowed-tools/disallowed-tools, model, effort, context: fork, agent, hooks,
paths, arguments. Dynamic context injection via `` !`cmd` ``. Lifecycle: skill
content persists for session; re-attached after compaction (5k tokens each, 25k
combined budget). Follows agentskills.io standard. Verified by full fetch
2026-06-08.

Local applicability: Directly informs how this user should structure skills
(concise bodies <500 lines, push reference to supporting files, use
disable-model-invocation for side-effect commands, paths for scoping).

Risks or stale assumptions: Skill behavior is probabilistic; description char
budget (1,536 cap; 1% context-window listing budget) can truncate.

## Claude Code Subagents Documentation

- source_type: official documentation
- url: https://code.claude.com/docs/en/sub-agents
- language: en
- layer: tool
- time_horizon: days
- authority: high (Anthropic first-party)
- proximity: maintainer/product
- evidence: high (frontmatter table, model resolution, isolation, memory)
- actionability: high
- freshness: current (min-version notes e.g. v2.1.117/2.1.161; fetched in full 2026-06-08)
- influence: high
- discovery_value: high
- local_applicability: high (user already uses an agentic-development-researcher subagent)
- trial_cost: low
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: subagent fields (isolation: worktree, memory, skills preload, fork mode, agent teams) are actively changing
- revalidation_trigger: Claude Code minor version touching subagents/agent-teams
- status: adopt

Summary: Subagents are `.claude/agents/*.md` (project) or `~/.claude/agents/`
(user). Frontmatter: name, description, tools, disallowedTools, model
(alias/ID/inherit), permissionMode, maxTurns, skills (preload), mcpServers,
hooks, memory (user/project/local), isolation: worktree, effort, background,
color, initialPrompt. Built-in Explore/Plan are read-only and skip CLAUDE.md/git.
Fork mode (`/fork`, CLAUDE_CODE_FORK_SUBAGENT) inherits full context. Persistent
memory at `~/.claude/agent-memory/<name>/`. Verified by full fetch 2026-06-08.

Local applicability: Strongly supports the user's read-only researcher subagent
pattern (tools allowlist, no mcpServers/hooks). `isolation: worktree`, `memory`,
and `skills` preload are new low-cost trial levers; fresh-context reviewer
subagent is a high-value verification pattern.

Risks or stale assumptions: Some features version-gated (fork v2.1.117+); agent
teams behind CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1; bypassPermissions risk
noted. Note: this run found the custom subagent type was not registered in the
running session (`agentic-development-researcher` not in available agent types) —
confirm subagent install/discovery before relying on it.

## Claude Code Hooks Documentation

- source_type: official documentation
- url: https://code.claude.com/docs/en/hooks
- language: en
- layer: tool
- time_horizon: days
- authority: high (Anthropic first-party)
- proximity: maintainer/product
- evidence: high (event list, settings.json schema, matcher/if syntax, exit codes)
- actionability: high
- freshness: current (fetched 2026-06-08; ~31 events incl. SubagentStart/Stop)
- influence: high
- discovery_value: high
- local_applicability: high (deterministic enforcement of user's instruction policies)
- trial_cost: low-medium
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: hook events, handler types (command/http/mcp_tool/prompt/agent), and if-conditions expand frequently
- revalidation_trigger: Claude Code minor version touching hooks/permissions
- status: trial

Summary: Hooks configured in settings.json (`~/.claude/settings.json`,
`.claude/settings.json`, `.claude/settings.local.json`). Events span session
(SessionStart, InstructionsLoaded), per-turn (UserPromptSubmit, Stop), tool
(PreToolUse, PostToolUse, PermissionRequest), and agent (SubagentStart/Stop)
phases. Matcher = exact/`|`-list/regex; `if` narrows (e.g. `Bash(git commit *)`,
`Edit(*.ts)`). Exit code 2 blocks. Handler types: command, http, mcp_tool,
prompt, agent. Common uses: auto-format on Write/Edit, lint-before-commit, block
rm -rf, load context on SessionStart. Verified by fetch 2026-06-08.

Local applicability: Hooks are the deterministic enforcement layer the user's own
AGENTS.md philosophy prefers ("prefer tests/hooks over prose"). Strong fit for
mechanically enforcing rules like `git diff --check` after edits or chezmoi-path
guardrails.

Risks or stale assumptions: Hooks run with user permissions; mis-scoped matchers
can block legitimate work; some handler types newer.

## GitHub Copilot: Claude and Codex Coding Agents Availability

- source_type: official changelog
- url: https://github.blog/changelog/2026-02-26-claude-and-codex-now-available-for-copilot-business-pro-users/
- language: en
- layer: tool/workflow
- time_horizon: weeks
- authority: high (GitHub first-party)
- proximity: product
- evidence: medium (announcement-level; plan/usage detail, no deep config)
- actionability: low-medium
- freshness: current as of 2026-02-26 (public preview); re-verify GA status
- influence: high
- discovery_value: medium
- local_applicability: low (cloud/PR-centric, not local CLI)
- trial_cost: medium (requires Copilot plan + org enablement)
- last_checked: 2026-06-08
- next_check: 2026-09-08
- check_frequency: quarterly
- watch_reason: signals convergence of Claude/Codex into PR-based delivery; mostly cross-track
- revalidation_trigger: GA announcement or pricing/premium-request change
- status: observe

Summary: As of 2026-02-26, Claude and Codex are available as Copilot coding
agents to Copilot Business/Pro (previously Enterprise/Pro+), no extra
subscription, one premium request per session in preview. Invoke via
@claude/@codex on issues/PRs or VS Code v1.109+; output is reviewable drafts.
Verified by fetch 2026-06-08.

Local applicability: Limited for local/repo CLI productivity; primarily a
delivery-track signal (agent identity, PR review automation, approval gates).
Cross-referenced in the delivery ledger's GitHub Copilot coding agent entry.

Risks or stale assumptions: Preview pricing/limits may have changed since Feb; GA
status not re-confirmed this pass.

## Practitioner: 2026 Claude Code Setup (MCP/Hooks/Skills/Agents)

- source_type: practitioner blog (discovery)
- url: https://okhlopkov.com/claude-code-setup-mcp-hooks-skills-2026/ (plus boringbot substack; shareuhack fleet guide)
- language: en
- layer: workflow
- time_horizon: weeks
- authority: low-medium (individual practitioners)
- proximity: user
- evidence: medium (claimed measured effect: skill trigger ~20% -> ~84% with hook auto-injection over 200 prompts) — NOT independently reproduced
- actionability: medium
- freshness: current (2026)
- influence: medium
- discovery_value: high (five-layer model; hooks-back-skills reliability pattern; fresh-subagent verification)
- local_applicability: medium
- trial_cost: low
- last_checked: 2026-06-08
- next_check: 2026-07-08
- check_frequency: monthly
- watch_reason: practitioner failure-mode evidence on skill reliability and verification loops
- revalidation_trigger: new measured workflows or contradicting official guidance
- status: investigate

Summary: Practitioner sources (surfaced via search; individual pages NOT fetched
in full this pass) converge on a five-layer model (CLAUDE.md = always-on facts;
skills = sometimes-procedures; hooks = auto/safety; subagents = isolation; MCP =
connectivity) and two reliability patterns: (1) back skills with hooks because
skill invocation is probabilistic (claimed trigger uplift 20%->84%), (2) verify
with a fresh-context subagent / bundled /code-review so the author is not the
grader. Cross-tool SKILL.md portability emphasized.

Local applicability: Reinforces user's existing "prefer hooks over prose"
instinct and existing researcher subagent; the hooks-back-skills and
fresh-subagent-verification patterns are cheap local trials.

Risks or stale assumptions: Single-practitioner metrics unverified; pages not
deep-read this pass — treat as discovery, confirm specifics before adopting. Vet
any linked third-party skills per user extension policy.

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

## 2026-06-08

- Trial candidate: Add a fresh-context "diff reviewer" subagent + pre-completion verification step
- Source: code.claude.com/docs/en/sub-agents; okhlopkov / boringbot practitioner pattern
- Expected benefit: Independent verification (author != grader) catches gaps; aligns with user's verification-before-completion principle
- Reversal cost: Low (single `.claude/agents/*.md` file; deletable)
- Verification: Run on a real diff; confirm it surfaces a known-omitted edge case
- Decision: pending (proposed; implementation is a separate scope/approval)

## 2026-06-08

- Trial candidate: Convert "after editing files, run git diff --check" + chezmoi guardrails from prose AGENTS.md rules into a PostToolUse/Stop hook in settings.json
- Source: code.claude.com/docs/en/hooks
- Expected benefit: Deterministic enforcement of rules currently relying on probabilistic prose compliance (matches user's "prefer hooks over instructions")
- Reversal cost: Low (remove hook block from settings.json; disableAllHooks fallback)
- Verification: Make an edit; confirm hook fires and blocks/reports as intended
- Decision: pending (proposed; implementation is a separate scope/approval)

## 2026-06-08

- Trial candidate: Author skills under the agentskills.io open standard so one SKILL.md serves both Claude Code (~/.claude/skills) and Codex (~/.agents/skills)
- Source: code.claude.com/docs/en/skills; developers.openai.com/codex/skills
- Expected benefit: Single source of truth for repeatable workflows across both tools the user runs; lower maintenance
- Reversal cost: Low (skills are isolated directories)
- Verification: Same SKILL.md invoked successfully in both Codex and Claude Code
- Decision: pending (note: Codex path is ~/.agents/skills, not ~/.codex)

## 2026-06-08

- Trial candidate: Use Codex named permission profiles (`--profile deep-review`) + granular approval_policy for review-heavy sessions
- Source: developers.openai.com/codex/codex-manual.md; changelog v0.134-0.137
- Expected benefit: Reproducible, scoped approval posture per task type without editing base config
- Reversal cost: Low (profile overlay file; delete to revert)
- Verification: Launch with profile; confirm sandbox/approval overlay applies
- Decision: pending (proposed; implementation is a separate scope/approval)
