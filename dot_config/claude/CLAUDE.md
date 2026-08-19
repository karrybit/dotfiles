# Claude Code Instructions

## Interpreting the Task

### Language

- Respond in the same language as the user's message. Default to Japanese when
  ambiguous.

### Scope Control

- Follow the exact scope requested by the user.
- When asked only to investigate, explain, assess, review, or identify a cause,
  do not modify files. Report findings, evidence, and possible options instead.
- When asked only for a plan or recommendation, do not implement it.
- Modify files only when the user explicitly requests implementation or
  changes.
- Before modifying files, state what will be changed.
- If the requested scope is ambiguous, investigate first and ask before
  modifying files.

### Reasoning From User Input

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

## Designing & Deciding

### External Knowledge and Practices

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
- Say which source was actually read, and distinguish cached knowledge and
  summaries from freshly checked source text; a claim resting on a summary must be
  marked as lower confidence, and say so when external verification is
  unavailable. Never build a verbatim quote from a summarizing fetch, a search
  snippet, or recall — those have produced quotes, error strings, and example
  sentences that do not exist in the source. For PDFs verify with
  `$XDG_DATA_HOME/agents/scripts/pdf-cite/bin/pdf-cite <abs-path> --find "<quote>"`,
  which exits non-zero when the quote is absent.
- A citation to a file, prior decision, or document inside the repository
  (e.g. "as documented in CLAUDE.md") is a claim about its contents, not just
  its existence. Open the cited location and confirm the claimed content is
  actually there before citing it; if it is not, name where the behavior
  actually comes from instead.
- Do not turn "not found" into "not there". An absence is evidence only about
  the region actually examined, so a partial view never supports a claim about
  the whole: an excerpt or sample of a document, a filtered or globbed search, a
  truncated file read, and a delegated excerpt-level search all fail this test.
  Before writing that something is absent, unsupported, or unaddressed, either
  bring the whole source into view or record the claim as unknown.
- Cache reusable source summaries under `$XDG_DATA_HOME/agents/docs/`, or
  `$HOME/.local/share/agents/docs/` when `XDG_DATA_HOME` is unset. Cache only
  what is likely to be reused, not one-off investigation notes; quote sparingly
  and keep source attribution rather than copying long passages; and treat the
  directory as a working set, marking stale, superseded, duplicated, or low-value
  entries as deletion candidates when you encounter them.

### Problem-Solving Discipline

- When facing a problem, analyze and structure its root cause critically.
  Treat the root cause as a hypothesis and confirm it with evidence before
  acting; a plausible story is not proof.
- Before retrying a failed action, capture the symptom, the last successful
  step, and the assumption being tested, then run one check that can falsify
  the leading hypothesis. Classify the failure by what the system reported,
  not by how the agent misbehaved.
- When the same blocker survives three focused recovery attempts, or the next
  step would be speculative rather than evidence-seeking, stop and escalate to
  the user with the evidence collected.
- Generalize the lesson instead of minimizing it to the immediate case, but
  stop at the level where the trigger is identifiable and a violation is
  detectable. Over-abstraction produces unactionable advice.
- Match analysis depth to recurrence and impact: do deep root-cause work for
  recurring or high-impact defects, and apply direct fixes for one-offs.
- Fix the cause rather than the symptom, and close the verification gap that let
  the defect through. Sublimate the lesson into the most durable enforceable form
  available — a test, hook, or generated artifact over a written instruction, and
  prose only when mechanical enforcement is impossible.

### Designing Against the Real Environment

- Before wiring an integration to a path, port, endpoint, or config key, confirm
  where the consuming program actually reads it in the current environment by
  resolving environment variables, config overrides, and XDG or platform
  defaults. Do not trust documented defaults; they can be overridden locally.
- When a change must work across multiple targets you cannot all observe (agents,
  machines, operating systems, runtimes), treat each unobserved target's behavior
  as an unverified assumption. Verify it directly, or make the mechanism
  self-verify at apply or run time, before depending on it.
- Generate artifacts that are fully derivable from a single source of truth
  instead of maintaining each by hand. Hand-maintained derived sets drift and
  scale with item count times target count.
- Before accepting a refactor, enumerate the invariants the current solution
  satisfies, such as the correct consumer path, coexistence with other writers,
  idempotency, and reversibility, then confirm the replacement preserves all of
  them. Reducing file or step count does not by itself justify a change.
- Do not assume exclusive ownership of a location that other tools also write to.
  Prefer per-item ownership over whole-directory ownership so external additions
  survive.

### Information Design

- When collecting or transforming information into durable artifacts (research
  notes, ledgers, analyses, reports, handoffs), keep three separable layers:
  policy-safe raw observations, normalized comparable records, and
  use-case-shaped outputs. The final artifact must never be the only source of
  truth; it must be rebuildable from the earlier layers when the use case
  changes. Grounding:
  `~/.local/share/agents/docs/medallion-information-design.md`.

## Making Changes Safely

### Repository Changes

- Before creating a requested file, check whether it already exists and inspect
  its contents.
- Reuse or update existing files and conventions when appropriate.
- Preserve unrelated and user-authored uncommitted changes.
- Place instructions in the narrowest applicable `CLAUDE.md`.
- Do not place directory-specific instructions in a broader file.
- When committing, group unrelated changes into separate logical commits
  instead of one mixed commit, unless the user requests a single commit.

### File Edits

- Change file contents with the file-editing tools, not by piping a file through
  a shell command. A script or stream editor is warranted only when the edit
  cannot be expressed as a set of string replacements: replacement text computed
  per occurrence, or one transformation applied across more sites than can be
  enumerated. Several occurrences of the same string do not qualify; `Edit`
  replaces all of them in one call.
- When a script or stream editor does write to files, count each target
  pattern's occurrences first, compare the count against the expected number,
  and exit without writing when they differ. Do not use in-place editing that
  cannot report what it matched, and start from a state the change can be undone
  from: a clean working tree for tracked files, an explicit backup otherwise.
- Verify a shell-driven edit by its result, not its exit status: the old pattern
  survives only where intended, the diff touches only the intended files and
  lines, and `git diff --check` passes.

### Code Style

- Write no comments unless the reason is non-obvious to a reader unfamiliar
  with the context.
- Do not add error handling for scenarios that cannot happen in practice.
- Prefer editing existing files over creating new ones.

### Artifact Reconciliation

- Before committing work that created new files, inventory newly created files
  and classify them as canonical, draft, merged, or deletion candidates.
- Do not delete draft or obsolete-looking files automatically; report
  candidates with evidence unless the user explicitly requests cleanup.
- Before finishing work that changed multiple artifacts, review the final set
  as one system: consistent terminology, correct placement and ownership,
  valid cross-references, and documented behavior matching the actual files.

### GitHub Issue Granularity (Default — Only Absent a Repo Policy)

Apply this section only when the current repository has no explicit issue-authoring
policy of its own (no repo `CLAUDE.md` rule, issue template, or CONTRIBUTING guidance
on issue scope/splitting). A repo-specific policy always takes precedence over this
default.

- Size each issue to an independently mergeable PR-sized unit of work — not by
  mirroring a source document's headings, and not by tool/component name alone.
  Default to more, smaller issues over fewer, larger ones whenever the sub-parts are
  independently actionable.
- A cross-cutting policy question spanning multiple concrete artifacts should not
  become its own issue with no code deliverable — resolve it locally inside each
  concretely affected issue instead, so every issue ships a decision + implementation
  together.
- Two changes to the same tool/component but of a different kind (e.g. version bump
  vs. config-content review) belong in separate issues when independent — don't
  bundle by component name alone.
- A core mechanism change and its optional/deferrable follow-ons belong in separate
  issues even when the follow-on depends on the core change landing first. Note the
  dependency in the follow-on's body rather than folding it into the core issue.
- Express cross-issue ordering dependencies as a short note in the dependent issue's
  body, not as a separate coordination/blocking issue.
- Don't pre-create speculative issues for follow-on scope that isn't concretely
  actionable yet. File the pilot/first-instance issue, validate the approach, and
  note in a parent/tracking issue that further issues will follow once it lands.
- A decision with no code deliverable right now is not an issue — record it as a
  caveat inside the nearest concrete issue's body.
- When new issues originate from an investigation/audit issue, keep that original
  issue open as a parent/tracking issue with a checklist linking to the new issues,
  rather than closing it — closing it loses the evidence that justified the split.
- Before creating any issue(s), confirm the proposed titles/boundaries with the user —
  issue creation is a visible, external action.

## Verification & Completion

- After editing files, run `git diff --check`.
- After changing chezmoi-managed paths or `.chezmoiignore`, verify that the
  intended files are managed or ignored as expected.
- A documentation-affecting configuration change is complete only after the
  relevant README has been reviewed.
- When fixing a bug that AI-assisted work introduced or a review missed, add
  the smallest deterministic regression test that fails on the old behavior,
  and cover the parallel paths the change touches (sandbox vs production,
  mock vs real provider, feature flag on vs off).
- Before any publish action such as `git push`, PR creation, sharing a diff,
  or making a repository public, inspect the exact outgoing content for
  secrets, personal data, real home paths, machine names, private
  organization names, and context that exists only inside this working
  session. Treat findings as blockers and prefer placeholders or template
  variables over real local values. An automated hook may block
  high-confidence secret patterns; it does not replace this inspection.
- Session-only context is anything a reader outside this session could not
  resolve: labels invented to organize this session's own work (e.g.
  "Tier2", "wave 3"), progress framing relative to a private artifact
  (filing-time vs. measured counts, "as of the earlier PR"), and names of the
  agent harness's own mechanisms rather than the project's (a sandbox-bypass
  flag, a background-execution mode, a subagent role name). State the
  underlying fact instead of the mechanism that produced it, e.g. "this test
  cannot run in this environment, for reasons unrelated to the change" rather
  than naming the flag that worked around it. This applies to code comments,
  commit messages, PR and issue bodies and comments, and any document
  committed to the repository.
- When delegating comment-, PR-, or document-writing to a subagent, give it
  only facts traceable to the repository itself, not this session's own
  labels or framing, since background context in a delegation prompt tends to
  be echoed verbatim into its output. Read that output against the rule above
  before it is published; only the delegating session knows which parts of it
  are session-only, so this check cannot itself be delegated.
- Report checks that could not be run.

## Maintaining Instructions

### Instruction Maintenance

- When a conversation reveals reusable friction or agent behavior violates user
  intent, propose the smallest concrete instruction improvement before ending
  the task.
- Classify each proposed improvement before suggesting it: user-level guidance
  belongs in `$XDG_CONFIG_HOME/claude/CLAUDE.md`; repository-specific guidance
  belongs in the narrowest applicable repository `CLAUDE.md`.
- For each proposed instruction change, provide the target file, proposed
  wording, reason, and overlap or conflict with existing rules.
- Do not update `CLAUDE.md` automatically when reviewing agent behavior.
- Do not add rules for one-off situations unless the impact is significant.
- Write rules with a clear trigger and expected action.
- Prefer verification commands, tests, or hooks over behavioral instructions
  when compliance can be checked mechanically. Compliance is mechanically
  checkable when the check can inspect the artifact itself, not when it would
  have to infer intent from a proxy such as a command string. A norm about how
  to reason belongs in prose, paired with a requirement to state the deviation
  so it is visible in the transcript.
- Check proposed rules for duplication or conflicts with existing instructions.
- Apply instruction changes only after user approval.
- Treat instruction files as a maintained system, not an append-only log. When
  adding or reviewing instructions, look for outdated, duplicated, overlapping,
  too-specific, or ineffective rules and propose removing or consolidating them.
- Prefer replacing several narrow rules with one clearer general rule when it
  preserves the intended behavior.
- Move rationale, historical context, and superseded discussion out of
  instruction files into commit messages, PR notes, or a dedicated decision log.

### Choosing a Reusable Mechanism

- Before adding a skill, choose the mechanism deliberately. A skill fires
  probabilistically and costs a description line in every session, so use one
  only for an on-demand workflow, specialized domain knowledge, a deterministic
  helper script, or bundled reference material.
- Put a norm that must apply every time its situation occurs in `CLAUDE.md`, not
  in a skill. A skill is the wrong mechanism when a missed trigger is a failure.
- Prefer a plugin when an official or maintained equivalent exists, and do not
  hand-copy upstream skill files into this environment. A copied skill has no
  ref to compare against and drifts silently as upstream renames, splits, or
  deletes it.
- Do not add a skill that repeats general engineering practice, an existing
  skill, or a capability the harness already provides.

## Environment & Tooling

### Command-Line Tool Preferences

- When searching file contents or file paths from the shell, use `rg` instead of
  `grep` and `fd` instead of `find`. Fall back to `grep` or `find` only when a
  required capability has no `rg` or `fd` equivalent, and state that reason.
- For structured data, reach for the structure-aware tool first: `jq` for JSON,
  `yq` for YAML, `qsv` for CSV/TSV. This covers data from command output as well
  as from files. Fall back to a general-purpose language (Python, Perl, Ruby,
  Node) or a text tool (`sed`/`awk`/`cut`) only when the structure-aware tool
  cannot express the transformation, and say which capability was missing.
  Finding the tool's syntax awkward is not such a reason. Load
  `csv-wrangling-with-qsv` for non-trivial CSV work.
- When a preferred tool does not resolve in the current environment, do not
  silently fall back to the tool it replaces. Recommend installing it, naming
  the package and where to declare it, and say which fallback is being used in
  the meantime.

### Chezmoi-Managed Files

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

### Known Permission-Gated Operations

- For known network operations such as `git push`, `git pull`, `git fetch`, and
  `chezmoi update`, request the required approval on the first attempt instead
  of first running in the sandbox and reporting DNS or network failures.
- Keep approval requests narrowly scoped to the exact command family needed for
  the task.
- Do not request persistent broad auto-approval for commands that can rewrite
  history, delete refs, run arbitrary scripts, or exfiltrate secrets. In
  particular, do not ask to persist broad approval for force-push commands.
- When pushing a new branch, do not add `-u`/`--set-upstream`. `push.default =
  current` is already configured, so a plain `git push` succeeds without
  upstream tracking. `-u` writes the tracking branch to `.git/config`
  regardless of `push.autoSetupRemote`, and that write fails with `could not
  lock config file .git/config: Operation not permitted` when the sandbox
  denies writes there; the push itself still succeeds, but the error is
  avoidable noise.
- `.env.example` (and similar template files) can be subject to the sandbox's
  filesystem read-deny for `.env*` paths. When that happens, `git status`/`git
  diff` can report the file as deleted even though it still exists on disk and
  in git history; this is a known false positive caused by the read block, not
  an actual deletion. Do not restore it, stage a deletion, or commit in
  response to this signal. Confirm real state with `git show HEAD:<path>` or
  ask the user before acting on an apparent `.env*` deletion.
- A running Claude Code session's Bash tool spawns a fresh shell per call, but
  that shell inherits environment variables frozen from whenever its actual
  long-lived ancestor process started (often a tmux server, which freezes the
  environment at server-start and hands it to every pane/window for the
  server's whole lifetime), not from re-sourcing the current dotfiles. When a
  `zshenv.d` file starts exporting a new variable, an already-running ancestor
  keeps the old (often unset) value until that ancestor itself restarts —
  restarting the terminal window or Claude Code client is not enough if both
  still attach to the same tmux server underneath. Before treating a
  var/sandbox-allowlist mismatch as a dotfiles or allowlist defect, check
  whether the variable's export was added after the current session started
  (compare `ps -o lstart -p $PPID` against the dotfile's last-applied mtime);
  if so, the fix is restarting the actual long-lived ancestor (e.g. `tmux
  kill-server`, or launching from a shell outside tmux), not editing the
  allowlist. `~/.config/zsh/dot_zshenv`'s double-sourcing guard
  (`_ZSHENV_SOURCED`) is deliberately unexported so this self-heals for any
  brand-new process tree without a restart — only process trees that already
  existed before that fix was deployed need the one-time restart.

### User-Scoped Agent Scripts

- Use a temp directory for a script only needed during the current session. A
  script expected to run again across sessions, be handed to another agent, or
  kept as an executable procedure belongs under `$XDG_DATA_HOME/agents/scripts/`,
  in a named subdirectory holding `README.md` and `bin/`.
- The stable directory root is managed by chezmoi as
  `dot_local/share/agents/scripts/`, but arbitrary files below that root are not
  managed by chezmoi unless explicitly requested. Promote a script set to explicit
  management only when the user asks to sync it across machines.
- Never put secrets, cookies, raw logs, scraped HTML, or other sensitive runtime
  data in a chezmoi-managed file.
- Do not add agent script directories to `PATH` by default. Invoke scripts by
  explicit file path.
- Agent scripts must not depend on the caller's current working directory.
  Resolve paths from the script location, environment variables, or explicit
  arguments.
- Runtime outputs, logs, scraped intermediates, and other disposable state
  belong under `$XDG_STATE_HOME/agents/scripts/` or, if `XDG_STATE_HOME` is
  unset, `$HOME/.local/state/agents/scripts/`.

### External Agent Extensions

- Before installing or enabling a public Claude Code skill, subagent, plugin, or
  MCP-backed agent extension, inspect it in a temporary or quarantined directory
  first, covering `SKILL.md`, subagent frontmatter, plugin manifests, hooks, MCP
  server declarations, executable scripts, install and update commands, network
  access, and secret-handling behavior.
- Prefer official, canonical, or maintainer-owned sources. Pin the exact source
  repository and ref when installing from Git, and review the license for each
  imported extension.
- Organization-required extensions are acceptable even when they are
  third-party, but do not record private employer or organization names in
  public dotfiles or reusable guidance unless explicitly requested.
- When a candidate extension is available on disk, run
  `$XDG_DATA_HOME/agents/scripts/agent-extension-security/bin/vet-agent-extension`
  against the candidate directory before installing it.
- Treat skills, plugins, MCP servers, hooks, and subagents installed by Claude
  Code commands as runtime state, not chezmoi-managed source, unless the
  corresponding source artifact or setting is explicitly added to this
  repository.
- Managed user-global skills must include `PROVENANCE.md` recording origin,
  source, license, and review date, plus the upstream version or ref for any
  vendored or external artifact. Keep it current when the artifact is updated or
  re-reviewed. Provenance is per-item and lives beside the artifact; do not
  reintroduce a hand-maintained registry of the whole collection.
- Do not vendor proprietary, unclear-license, or terms-restricted artifacts into
  shared dotfiles. Install them through a plugin or package manager, or leave
  them as runtime state outside this repository.
- Do not install or enable an extension that requests bypass permissions,
  broad write access, broad shell access, hooks, MCP servers, credential reads,
  or automatic network actions unless the user explicitly approves that risk.
- For Claude Code subagents, prefer read-only tools and no `mcpServers`,
  `hooks`, or elevated `permissionMode` unless the task requires those
  capabilities.
- Cache reusable official or expert source summaries under
  `$XDG_DATA_HOME/agents/docs/` with source URL, date checked, version context,
  and revalidation trigger.
