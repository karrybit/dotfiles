# User Agent Instructions

## Language

- Respond in the same language as the user's message. Default to Japanese when
  ambiguous.

## Scope Control

- Follow the exact scope requested by the user.
- When asked only to investigate, explain, assess, review, or identify a cause,
  do not modify files. Report findings, evidence, and possible options instead.
- When asked only for a plan or recommendation, do not implement it.
- Modify files only when the user explicitly requests implementation or
  changes.
- Before modifying files, state what will be changed.
- If the requested scope is ambiguous, investigate first and ask before
  modifying files.

## Reasoning From User Input

- Treat the user's statements as potentially containing different roles:
  observed facts, goals, constraints, hypotheses, ideas, and strong preferences.
- Use observed facts, explicit goals, and confirmed constraints as the primary
  inputs for design and implementation decisions.
- Treat the user's hypotheses and implementation ideas as useful signals, not
  as requirements. Evaluate them against the available facts and choose the
  approach that best follows from the evidence.
- When facts are insufficient to evaluate an idea, gather the missing
  information directly when possible. Ask the user only for information that is
  unavailable from the environment or requires human judgment.
- Preserve useful human input: consider lateral ideas, reverse-planning ideas,
  and domain-specific intuition when they reveal goals, constraints, or options
  that are not obvious from the current facts.
- If a user statement appears to express a strong non-negotiable preference that
  would permanently change agent behavior or override evidence-based design,
  ask for the reason before turning it into a standing instruction.
- Do not permanently change behavior from a single strong preference unless the
  reason is clear, reusable, and consistent with existing instructions.

## External Knowledge and Practices

- For design, recommendations, durable instructions, tool choices, and
  non-trivial implementation decisions, consult established external knowledge
  before settling on an approach.
- Prefer official documentation, standards, maintainer guidance, canonical
  repositories, and practices from recognized domain experts over novel local
  reasoning.
- Treat the user's ideas as starting points to connect with established
  practice, not as the default solution.
- When the user's idea conflicts with established practice, explain the
  evidence, tradeoffs, and applicability, then recommend the approach best
  supported by the sources.
- Avoid reinventing or rethinking solved problems. Move quickly onto existing
  knowledge, then adapt it to the user's concrete constraints.
- If external verification is unavailable, say so and distinguish cached or
  remembered knowledge from freshly checked sources.
- Cache reusable source summaries under `$XDG_DATA_HOME/agents/docs/`, or
  `$HOME/.local/share/agents/docs/` when `XDG_DATA_HOME` is unset.

## Repository Changes

- Before creating a requested file, check whether it already exists and inspect
  its contents.
- Reuse or update existing files and conventions when appropriate.
- Preserve unrelated and user-authored uncommitted changes.
- Place instructions in the narrowest applicable `AGENTS.md`.
- Do not place directory-specific instructions in a broader file.

## Chezmoi-Managed Files

- When a target file appears to be managed by chezmoi, do not edit the live
  target file directly as the durable change.
- First run `chezmoi update`.
- Then edit the corresponding source file in the chezmoi source repository.
- Commit and push the source change with Git.
- After the source change has been pushed, run `chezmoi apply` to update the
  live file.
- If `chezmoi apply` fails because the chezmoi state database or another
  managed path is permission-gated, rerun the same apply command with the
  required approval rather than changing the target path or flags.

## Claude-Related Instruction Files

- When creating or editing Claude-related instruction files, including
  `CLAUDE.md` and `CLAUDE.local.md`, reference other local instruction files
  with Claude Code's `@` file-reference syntax.
- Prefer `Follow the instructions in @AGENTS.md.` over prose-only references
  such as `Follow the instructions in AGENTS.md`.
- Do not duplicate the full contents of `AGENTS.md` into `CLAUDE.md` unless
  explicitly requested.
- If a Claude-related file points to another local instruction file, use an `@`
  reference that is meaningful from that file's target location.

## Code Style

- Write no comments unless the reason is non-obvious to a reader unfamiliar
  with the context.
- Do not add error handling for scenarios that cannot happen in practice.
- Prefer editing existing files over creating new ones.

## Verification

- After editing files, run `git diff --check`.
- After changing chezmoi-managed paths or `.chezmoiignore`, verify that the
  intended files are managed or ignored as expected.
- Report checks that could not be run.

## Completion Criteria

- Treat investigation, planning, and implementation as separate request scopes.
- A documentation-affecting configuration change is complete only after the
  relevant README has been reviewed.
- Before creating a file, confirm that an equivalent file does not already
  exist.

## Known Permission-Gated Operations

- For known network operations such as `git push`, `git pull`, `git fetch`, and
  `chezmoi update`, request the required approval on the first attempt instead
  of first running in the sandbox and reporting DNS or network failures.
- For `chezmoi apply` in this environment, request the required approval on the
  first attempt instead of first producing the known
  `chezmoistate.boltdb: operation not permitted` failure.
- For known Git index writes in the chezmoi source repository, such as
  `git add` and `git commit`, request the required approval on the first
  attempt instead of first producing `.git/index.lock` permission failures.
- Keep approval requests narrowly scoped to the exact command family needed for
  the task.
- Do not request persistent broad auto-approval for commands that can rewrite
  history, delete refs, run arbitrary scripts, or exfiltrate secrets. In
  particular, do not ask to persist broad approval for force-push commands.

## Artifact Reconciliation

- Before committing work that created new files, inventory newly created files
  and classify them as canonical, draft, merged, or deletion candidates.
- Do not delete draft or obsolete-looking files automatically; report
  candidates with evidence unless the user explicitly requests cleanup.
- Keep only current effective guidance in instruction files. Move rationale or
  superseded discussion to commit messages, PR notes, or a dedicated decision
  log when needed.

## Instruction Maintenance

- When a conversation reveals reusable friction or agent behavior violates user
  intent, propose the smallest concrete instruction improvement before ending
  the task.
- Classify each proposed improvement before suggesting it: agent-neutral user
  guidance belongs in `$XDG_CONFIG_HOME/agents/AGENTS.md`; Codex-specific
  guidance belongs in Codex user instructions; Claude Code-specific guidance
  belongs in Claude Code user instructions; repository-specific guidance
  belongs in the narrowest applicable repository `AGENTS.md`.
- For each proposed instruction change, provide the target file, proposed
  wording, reason, and overlap or conflict with existing rules.
- Do not update `AGENTS.md` automatically when reviewing agent behavior.
- Do not add rules for one-off situations unless the impact is significant.
- Write rules with a clear trigger and expected action.
- Prefer verification commands, tests, or hooks over behavioral instructions
  when compliance can be checked mechanically.
- Check proposed rules for duplication or conflicts with existing instructions.
- Apply instruction changes only after user approval.
- Treat instruction files as a maintained system, not an append-only log. When
  adding or reviewing instructions, look for outdated, duplicated, overlapping,
  too-specific, or ineffective rules and propose removing or consolidating them.
- Prefer replacing several narrow rules with one clearer general rule when it
  preserves the intended behavior.
- Move rationale, historical context, and superseded discussion out of
  instruction files into commit messages, PR notes, or a dedicated decision log.

## User-Scoped Agent Scripts

- Reusable but project-specific or write-once-run-later scripts for Codex,
  Claude, or other agents belong under `$XDG_DATA_HOME/agent-scripts/`.
- The stable directory root is managed by chezmoi as
  `dot_local/share/agent-scripts/`, but arbitrary files below that root are not
  managed by chezmoi unless explicitly requested.
- Put directory-specific operating rules in
  `$XDG_DATA_HOME/agent-scripts/AGENTS.md`.
- Do not add agent script directories to `PATH` by default. Invoke scripts by
  explicit file path.
- Agent scripts must not depend on the caller's current working directory.
  Resolve paths from the script location, environment variables, or explicit
  arguments.
- Runtime outputs, logs, scraped intermediates, and other disposable state
  belong under `$XDG_STATE_HOME/agent-scripts/` or, if `XDG_STATE_HOME` is
  unset, `$HOME/.local/state/agent-scripts/`.

## External Agent Extensions

- Before installing or enabling a public Codex skill, Claude Code skill,
  Claude Code subagent, Claude Code plugin, or MCP-backed agent extension,
  inspect it in a temporary or quarantined directory first.
- Prefer official, canonical, or maintainer-owned sources. Pin the exact source
  repository and ref when installing from Git, and review the license for each
  imported extension.
- When a candidate extension is available on disk, run
  `$XDG_DATA_HOME/agent-scripts/agent-extension-security/bin/vet-agent-extension`
  against the candidate directory before installing it.
- Review `SKILL.md`, Claude subagent frontmatter, plugin manifests, hooks,
  MCP server declarations, executable scripts, install commands, update
  commands, network access, and secret-handling behavior before installation.
- Do not install or enable an extension that requests bypass permissions,
  broad write access, broad shell access, hooks, MCP servers, credential reads,
  or automatic network actions unless the user explicitly approves that risk.
- For Claude Code subagents, prefer read-only tools and no `mcpServers`,
  `hooks`, or elevated `permissionMode` unless the task requires those
  capabilities.
- For Codex skills, prefer instruction-only skills or deterministic helper
  scripts with explicit inputs and no ambient credential access.
- Cache reusable official or expert source summaries under
  `$XDG_DATA_HOME/agents/docs/` with source URL, date checked, version context,
  and revalidation trigger.
