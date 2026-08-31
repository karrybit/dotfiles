# Claude Code Instructions

## Interpreting the Task

### Language

- Respond in the same language as the user's message. Default to Japanese when
  ambiguous.

### Scope Control

- Modify files only when the user explicitly requests implementation or changes.
  When asked to investigate, explain, assess, review, identify a cause, plan, or
  recommend, report findings, evidence, and options instead.
- Before modifying files, state what will be changed.
- When the requested scope is ambiguous, investigate first, then ask.

### Reasoning From User Input

- A user's statement carries one of two weights. Observed facts, explicit goals,
  and confirmed constraints are inputs to the design. Hypotheses, implementation
  ideas, and preferences are signals: evaluate them against the facts and choose
  the approach the evidence supports.
- Gather missing facts from the environment yourself. Ask the user only for what
  the environment cannot answer or what requires human judgment.
- Weigh lateral ideas, reverse-planned goals, and domain intuition as evidence
  about goals, constraints, and options the current facts do not show.
- Before turning a strong preference into a standing instruction, ask for the
  reason. Adopt it only when the reason is clear, reusable, and consistent with
  existing instructions.

## Designing & Deciding

### External Knowledge and Practices

- Consult established external knowledge before settling on any design,
  recommendation, durable instruction, or tool choice. Adapt what exists rather
  than re-deriving a solved problem.
- Prefer official docs, standards, maintainer guidance, canonical repositories,
  and recognized domain experts over novel local reasoning.
- When the user's idea conflicts with established practice, lay out the evidence
  and tradeoffs, then recommend what the sources support.
- Say which source you actually read, and mark a claim resting on a summary as
  lower confidence. Build a verbatim quote only from the source text itself,
  never from a summarizing fetch, a search snippet, or recall — those produce
  quotes, error strings, and example sentences the source does not contain.
  Verify a PDF quote with the `pdf-cite` script under
  `$XDG_DATA_HOME/agents/scripts/`; it exits non-zero when the quote is absent.
- Citing a file, prior decision, or repository document claims something about
  its contents. Open it and confirm the claim before citing; if it is not there,
  name where the behavior actually comes from.
- An absence is evidence only about the region actually examined. An excerpt, a
  filtered search, a truncated read, and a delegated excerpt-level search all
  fail this test. Before writing that something is absent or unaddressed, bring
  the whole source into view or record the claim as unknown.
- Cache reusable source summaries under `$XDG_DATA_HOME/agents/docs/` (or
  `~/.local/share/agents/docs/` when unset), recording source URL, date checked,
  version context, and revalidation trigger. Cache what will be reused, not
  one-off investigation notes; keep attribution instead of copying long passages;
  and prune stale, superseded, or duplicated entries when you encounter them.

### Problem-Solving Discipline

- Treat a root cause as a hypothesis and confirm it with evidence before acting.
  A plausible story is not proof.
- Before retrying a failed action, capture the symptom, the last successful step,
  and the assumption being tested, then run one check that can falsify the
  leading hypothesis. Classify the failure by what the system reported, not by
  how the agent misbehaved.
- When the same blocker survives three focused recovery attempts, or the next
  step would be speculative rather than evidence-seeking, stop and escalate with
  the evidence collected.
- Generalize the lesson, but stop at the level where the trigger is identifiable
  and a violation is detectable. Over-abstraction produces unactionable advice.
- Match analysis depth to recurrence and impact: deep root-cause work for
  recurring or high-impact defects, direct fixes for one-offs.
- Close the verification gap that let the defect through, not just the defect.

### Designing Against the Real Environment

- Before wiring an integration to a path, port, endpoint, or config key, confirm
  where the consuming program actually reads it here, resolving environment
  variables, config overrides, and XDG or platform defaults. Documented defaults
  can be overridden locally.
- When a change must work across targets you cannot all observe (agents,
  machines, operating systems, runtimes), each unobserved target's behavior is an
  unverified assumption. Verify it directly, or make the mechanism self-verify at
  apply or run time, before depending on it.
- Generate derived artifacts from a single source of truth. Hand-maintained
  derived sets drift and scale with item count times target count.
- Before accepting a refactor, enumerate the invariants the current solution
  satisfies — correct consumer path, coexistence with other writers, idempotency,
  reversibility — and confirm the replacement preserves all of them. A lower file
  or step count does not by itself justify a change.
- Prefer per-item ownership over whole-directory ownership, so additions by other
  tools survive.

### Information Design

- When collecting information into a durable artifact (research notes, ledgers,
  analyses, reports, handoffs), keep three separable layers: policy-safe raw
  observations, normalized records, and use-case-shaped outputs. The artifact
  must stay rebuildable from the earlier layers when the use case changes.
  Grounding: `~/.local/share/agents/docs/medallion-information-design.md`.

## Making Changes Safely

### Repository Changes

- Check whether a requested file already exists, and read it, before creating it.
- Preserve unrelated and user-authored uncommitted changes.
- Place instructions in the narrowest applicable `CLAUDE.md`.
- When committing, group unrelated changes into separate logical commits instead
  of one mixed commit, unless the user requests a single commit.
- Before creating any GitHub issue, confirm the proposed titles and boundaries
  with the user — issue creation is a visible, external action.
- Size each issue to an independently mergeable PR-sized unit of work. Load
  `size-github-issues` before splitting a document, investigation, or audit into
  issues.

### File Edits

- Edit files with the file-editing tools. A script or stream editor earns its
  place only when the edit cannot be expressed as string replacements:
  replacement text computed per occurrence, or one transformation across more
  sites than can be enumerated. Repeated occurrences of the same string do not
  qualify — `Edit` replaces all of them in one call.
- When a script does write to files, count each target pattern's occurrences
  first, compare against the expected number, and exit without writing when they
  differ. Use editing that reports what it matched, and start from a state the
  change can be undone from: a clean working tree for tracked files, an explicit
  backup otherwise.
- Verify a shell-driven edit by its result, not its exit status: the old pattern
  survives only where intended, the diff touches only the intended files and
  lines, and `git diff --check` passes.

### Code Style

- Write no comments unless the reason is non-obvious to a reader unfamiliar with
  the context.
- Add error handling only for scenarios that can happen in practice.
- Prefer editing existing files over creating new ones.
- Write documents and comments to describe the current design as if it were the
  original design, not the revisions or conversations that produced it. Rationale
  and historical context worth keeping belongs in the commit message, PR
  description, or a decision log — tied to the decision to commit now, not to the
  artifact's ongoing self-description.

### Artifact Reconciliation

- Before committing work that created new files, inventory them and classify each
  as canonical, draft, merged, or deletion candidate.
- Report deletion candidates with evidence; delete drafts and obsolete-looking
  files only when the user requests cleanup.
- Before finishing work that changed multiple artifacts, review the final set as
  one system: consistent terminology, correct placement and ownership, valid
  cross-references, and documented behavior matching the actual files.

## Verification & Completion

- After editing files, run `git diff --check`.
- A documentation-affecting configuration change is complete only after the
  relevant README has been reviewed.
- When fixing a bug that AI-assisted work introduced or a review missed, add the
  smallest deterministic regression test that fails on the old behavior, and
  cover the parallel paths the change touches (sandbox vs production, mock vs
  real provider, feature flag on vs off).
- Before any publish action — `git push`, PR creation, sharing a diff, making a
  repository public — inspect the exact outgoing content for secrets, personal
  data, real home paths, machine names, private organization names, and
  session-only context. Treat findings as blockers and prefer placeholders over
  real local values. A hook may block high-confidence secret patterns; it does
  not replace this inspection.
- Session-only context is anything a reader outside this session could not
  resolve: labels invented to organize this session's work ("Tier2", "wave 3"),
  progress framed against a private artifact, and the agent harness's own
  mechanism names rather than the project's. State the underlying fact instead of
  the mechanism that produced it — "this test cannot run in this environment, for
  reasons unrelated to the change", not the flag that worked around it. This
  binds code comments, commit messages, PR and issue bodies and comments, and any
  committed document.
- When delegating comment-, PR-, or document-writing to a subagent, give it only
  facts traceable to the repository itself, since background context in a
  delegation prompt tends to be echoed verbatim into its output. Read that output
  against the rule above before it is published; only the delegating session
  knows which parts are session-only, so this check cannot itself be delegated.
- Report checks that could not be run.

## Maintaining Instructions

### Instruction Maintenance

- Load `writing-for-agents` before editing any `CLAUDE.md`, rule, or skill file.
- When a conversation reveals reusable friction, or agent behavior violates user
  intent, propose the smallest concrete instruction improvement before ending the
  task.
- Classify each proposed improvement: user-level guidance belongs in
  `$XDG_CONFIG_HOME/claude/CLAUDE.md`, repository-specific guidance in the
  narrowest applicable repository `CLAUDE.md`.
- For each proposed change, give the target file, proposed wording, reason, and
  overlap or conflict with existing rules.
- Apply instruction changes only after user approval.
- Add a rule for a one-off situation only when the impact is significant.
- Write rules with a clear trigger and expected action.
- Prefer verification commands, tests, or hooks over behavioral instructions when
  compliance can be checked mechanically — that is, when the check can inspect
  the artifact itself, not when it would have to infer intent from a proxy such
  as a command string. A norm about how to reason belongs in prose, paired with a
  requirement to state the deviation so it is visible in the transcript.
- Treat instruction files as a maintained system, not an append-only log. When
  adding or reviewing instructions, look for outdated, duplicated, overlapping,
  too-specific, or ineffective rules and propose removing or consolidating them.
- Prefer replacing several narrow rules with one clearer general rule when it
  preserves the intended behavior.

### Choosing a Reusable Mechanism

- Before adding a skill, choose the mechanism deliberately. A skill fires
  probabilistically and costs a description line in every session, so use one
  only for an on-demand workflow, specialized domain knowledge, a deterministic
  helper script, or bundled reference material.
- Put a norm that must apply every time its situation occurs in `CLAUDE.md`, not
  in a skill. A skill is the wrong mechanism when a missed trigger is a failure.
- Prefer a plugin when an official or maintained equivalent exists, and keep
  upstream skill files upstream. A hand-copied skill has no ref to compare
  against and drifts silently as upstream renames, splits, or deletes it.
- Add a skill only when it does something general engineering practice, an
  existing skill, and the harness itself do not already cover.

## Environment & Tooling

### Command-Line Tool Preferences

- Search file contents with `rg` and file paths with `fd`. Fall back to `grep` or
  `find` only when a required capability has no equivalent, and state that reason.
- For structured data, reach for the structure-aware tool first: `jq` for JSON,
  `yq` for YAML, `qsv` for CSV/TSV — for command output as well as files. Fall
  back to a general-purpose language or a text tool (`sed`/`awk`/`cut`) only when
  the structure-aware tool cannot express the transformation, and say which
  capability was missing; awkward syntax is not such a reason. Load
  `csv-wrangling-with-qsv` for non-trivial CSV work.
- When a preferred tool does not resolve here, say which fallback you are using
  and recommend installing the preferred one, naming the package and where to
  declare it.

### Chezmoi-Managed Files

- Make a durable change to a chezmoi-managed file in the source repository, not
  the live target: `chezmoi update`, edit the source file, commit and push, then
  `chezmoi apply`.
- If `chezmoi apply` fails because the state database or another managed path is
  permission-gated, rerun the same command with the required approval rather than
  changing the path or flags.

### Known Permission-Gated Operations

- For known network operations such as `git push`, `git pull`, `git fetch`, and
  `chezmoi update`, request the required approval on the first attempt rather
  than reporting a sandbox DNS or network failure first.
- Keep approval requests narrowly scoped to the exact command family needed.
- Keep broad auto-approval off the table for commands that can rewrite history,
  delete refs, run arbitrary scripts, or exfiltrate secrets — force-push above
  all.
- Do not add `-u`/`--set-upstream` when pushing a new branch; `push.default =
  current` already covers it.
- Inventory merged local branches with `git branch --merged <base-branch>`, not
  by looking for `[gone]` markers.
- Branch from a remote ref with `git branch --no-track <new> <remote-ref> && git
  checkout <new>`, never with `git switch -c` or `git checkout -b`.
- An apparent `.env*` deletion in `git status`/`git diff` is a sandbox read-deny
  artifact, not a real deletion. Confirm with `git show HEAD:<path>`; never
  restore, stage, or commit in response to it.
- When an environment variable does not match what the dotfiles export, suspect
  the session's long-lived ancestor process before the dotfiles or the sandbox
  allowlist.
- Why the five rules above hold, and how to diagnose each failure:
  `~/.local/share/agents/docs/sandbox-and-environment-gotchas.md`.

### User-Scoped Agent Scripts

- Keep a script needed only during the current session in a temp directory. One
  expected to run again across sessions, be handed to another agent, or kept as
  an executable procedure belongs under `$XDG_DATA_HOME/agents/scripts/`, in a
  named subdirectory holding `README.md` and `bin/`.
- That root is chezmoi-managed, but files below it are not unless explicitly
  requested. Promote a script set to explicit management only when the user asks
  to sync it across machines.
- Keep secrets, cookies, raw logs, scraped HTML, and other sensitive runtime data
  out of every chezmoi-managed file.
- Invoke agent scripts by explicit file path; leave their directories off `PATH`.
- Agent scripts resolve paths from the script location, environment variables, or
  explicit arguments, never from the caller's working directory.
- Runtime outputs, logs, scraped intermediates, and other disposable state belong
  under `$XDG_STATE_HOME/agents/scripts/` (or `~/.local/state/agents/scripts/`
  when unset).

### External Agent Extensions

- Do not install or enable a public Claude Code skill, subagent, plugin, or
  MCP-backed agent extension without vetting it first. Load
  `install-agent-extension` for the vetting procedure.
- Treat skills, plugins, MCP servers, hooks, and subagents installed by Claude
  Code commands as runtime state, not chezmoi-managed source, unless the
  corresponding source artifact or setting is added to this repository.
- Managed user-global skills must include `PROVENANCE.md` recording origin,
  source, license, and review date, plus the upstream version or ref for any
  vendored artifact. Keep it current across updates and re-reviews. Provenance is
  per-item and lives beside the artifact, never a registry of the collection.
- Install proprietary, unclear-license, or terms-restricted artifacts through a
  plugin or package manager, or leave them as runtime state outside this
  repository.
- Do not install or enable an extension that requests bypass permissions, broad
  write access, broad shell access, hooks, MCP servers, credential reads, or
  automatic network actions unless the user explicitly approves that risk.
