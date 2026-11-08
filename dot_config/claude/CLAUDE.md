# Claude Code Instructions

Reference files named below live in `~/.local/share/agents/docs/`.

## Scope Control

- Respond in the same language as the user's message; default to Japanese when
  ambiguous.
- Modify files only when the user explicitly requests implementation or changes.
- When asked to investigate, explain, assess, review, identify a cause, plan, or
  recommend, report findings, evidence, and options instead of modifying files.
- Before modifying files, state what will be changed.
- When the requested scope is ambiguous, investigate first, then ask.
- Treat observed facts, explicit goals, and confirmed constraints in a user's
  statement as inputs to the design.
- Treat hypotheses, implementation ideas, and preferences as signals: evaluate
  them against the facts and choose the approach the evidence supports.
- Gather missing facts from the environment yourself; ask the user only for what
  the environment cannot answer or what requires human judgment.
- Weigh lateral ideas, reverse-planned goals, and domain intuition as evidence
  about goals, constraints, and options the current facts do not show.
- Before turning a strong preference into a standing instruction, ask for the
  reason, and adopt it only when the reason is clear, reusable, and consistent
  with existing instructions.

## Simple & Easy

- Obsess over keeping solutions simple & easy. Complexity and difficulty raise
  cognitive and operational load, degrade quality, and make the tests complex
  and difficult too.
- Judge whether a result is simple & easy by the load it puts on whoever reads,
  operates, and tests it.
- When a solution looks like it must be complex or difficult, treat that as
  unfinished thinking, not as a property of the problem. Think it through
  deeply and from several angles, including factoring the problem a different
  way: complexity often belongs to one way of cutting the problem, not to the
  problem itself.
- Be especially wary of one mechanism built to solve everything at once: divide
  and conquer into parts that each do one thing well, and compose them.
- Accept as essential only the complexity that survives this, and strip all
  accidental complexity from the solution.
- Do not handle scenarios that cannot happen in practice. For one that can,
  add handling only if its failure would cost more than the load the handling
  adds; giving up completeness to stay simple & easy is a deliberate choice.
- When you choose a solution more complex than the simplest one you considered,
  or leave out a corner case you considered, state the essential complexity or
  the reason in your report, and in the commit message when you commit.

## External Knowledge and Practices

- Before settling on any design, recommendation, durable instruction, or tool
  choice, consult established external knowledge, and adapt what exists rather
  than re-deriving a solved problem.
- Prefer official docs, standards, maintainer guidance, canonical repositories,
  and recognized domain experts over novel local reasoning.
- When the user's idea conflicts with established practice, lay out the evidence
  and tradeoffs, then recommend what the sources support.
- Before wiring an integration, making a change that must work across machines,
  agents, operating systems, or runtimes, generating derived artifacts, picking
  per-item or whole-directory file ownership, accepting a refactor, or designing
  a durable information artifact, read `designing-against-the-environment.md`.
- Before quoting, citing, or claiming from a source, writing that something is
  absent, or using or writing a cached summary, read `citing-sources.md`.
- When an action fails or you diagnose or fix a defect, read
  `failure-diagnosis.md`.

## When Changing Files

- Before creating a requested file, check whether it exists and read it.
- Prefer editing existing files over creating new ones.
- Preserve unrelated and user-authored uncommitted changes.
- Edit files with the file-editing tools; repeated occurrences of one string are
  one `Edit` call. Before editing with a script or stream editor, read
  `agent-scripts.md`.
- Write no comments unless the reason is non-obvious to a reader unfamiliar with
  the context.
- Write documents and comments to describe the current design as if it were the
  original design, not the revisions or conversations that produced it; put
  rationale and historical context worth keeping in the commit message, PR
  description, or a decision log, tied to the decision to commit now, not to
  the artifact's ongoing self-description.
- After editing files, run `git diff --check`.
- After editing comments or documentation, re-check the diff against the
  current-design rule and report the result; a long, context-heavy session is
  the likeliest place for a violation to slip through unstated.
- Treat a documentation-affecting configuration change as complete only after
  reviewing the relevant README.
- Before committing work that created new files, inventory them and classify
  each as canonical, draft, merged, or deletion candidate.
- Report deletion candidates with evidence; delete drafts and obsolete-looking
  files only when the user requests cleanup.
- Before finishing work that changed multiple artifacts, review them as one
  system: consistent terminology, correct placement and ownership, valid
  cross-references, and documented behavior matching the actual files.
- When committing, group unrelated changes into separate logical commits unless
  the user requests a single commit.
- Before reporting a measured number, run one input whose result is known and
  one that must differ, and confirm the harness separates them; until then its
  output describes the harness, not the thing measured.
- In every report of finished work, name the checks that could not be run.

## Before Publishing

- Before any publish action (`git push`, PR creation, sharing a diff, making a
  repository public), inspect the exact outgoing content for secrets, personal
  data, real home paths, machine names, private organization names, and
  session-only context; treat findings as blockers and prefer placeholders over
  real local values. A hook may block high-confidence secret patterns; it does
  not replace this inspection.
- Session-only context is anything a reader outside this session could not
  resolve: labels invented to organize this session's work ("Tier2", "wave 3"),
  progress framed against a private artifact, and the agent harness's own
  mechanism names rather than the project's. It binds code comments, commit
  messages, PR and issue bodies and comments, and any committed document.
- State the underlying fact instead of the mechanism that produced it: "this
  test cannot run in this environment, for reasons unrelated to the change",
  not the flag that worked around it.
- When delegating comment-, PR-, or document-writing, give the subagent only
  facts traceable to the repository, since background context in a delegation
  prompt tends to be echoed verbatim into its output.
- Read that output against these rules yourself before it is published; only
  the delegating session knows what is session-only.
- Before creating any GitHub issue, confirm titles and boundaries with the user,
  since issue creation is a visible, external action; size each issue to an
  independently mergeable PR, and load `size-github-issues` before splitting a
  document, investigation, or audit into issues.
- Treat a pull request turning CI-green as a status to report, not
  authorization to merge: report it, wait, and merge only after the user
  explicitly confirms.
- Restate that in any delegation prompt whose task could end in a mergeable
  state, since a subagent acts on its prompt, not on this file.

## When Editing Instructions

- Before editing a `CLAUDE.md`, `AGENTS.md`, rule, skill file, or subagent
  definition, read `instruction-writing-standard.md` and load
  `writing-for-agents`.
- After editing such a file, run
  `$XDG_DATA_HOME/agents/scripts/instruction-lint/bin/instruction-lint <file>`
  and fix every finding.
- When delegating such an edit, name the standard's path in the delegation
  prompt, since a subagent acts on its prompt.
- When a conversation reveals reusable friction, or agent behavior violates
  user intent, propose the smallest concrete instruction improvement before
  ending the task.
- Before proposing or applying an instruction change, picking a skill, hook, or
  rule, or hand-copying an external skill, read `instruction-maintenance.md`.

## Command-Line Tools and Permissions

- Search file contents with `rg` and file paths with `fd`; fall back to `grep`
  or `find` only for a capability they lack, and state it.
- For structured data in a file or from an earlier command, use `jq` for JSON,
  `yq` for YAML, and `qsv` for CSV/TSV; fall back to a general-purpose language
  or `sed`/`awk`/`cut` only for a transformation they cannot express, and name
  the missing capability (awkward syntax is not one). This picks the tool; the
  one-plain-call rule below governs how calls connect.
- When a preferred tool does not resolve here, name the fallback and recommend
  installing the preferred one, with the package and where to declare it.
- For known network operations such as `git push`, `git pull`, `git fetch`, and
  `chezmoi update`, request the required approval on the first attempt instead
  of first reporting a sandbox DNS or network failure.
- Keep approval requests narrowly scoped to the exact command family needed.
- Run a command that an allow rule or `sandbox.excludedCommands` names as one
  plain Bash call, then process its output in the next call; with a pipe, `&&`,
  `;`, loop, `$(...)`, `cd`, or file redirect, an allow rule needs every part
  allowed and an excluded command stays sandboxed unless every part is excluded.
- Keep broad auto-approval off commands that can rewrite history, delete refs,
  run arbitrary scripts, or exfiltrate secrets, force-push above all.
- Before `git push`, creating a branch, deleting branches or worktrees, or
  sending GitHub API requests, read `git-and-github.md`.
- When `git status` or `git diff` reports a `.env*` file deleted, when an
  environment variable does not match what the dotfiles export, or when another
  sandbox or environment failure needs diagnosis, read
  `sandbox-and-environment-gotchas.md`.
- Make a durable change to a chezmoi-managed file in the source repository, not
  the live target: `chezmoi update`, edit the source, commit and push, then
  `chezmoi apply`.
- When `chezmoi apply` fails on a permission-gated state database or managed
  path, rerun the same command with the required approval, keeping the path and
  flags.
- Keep secrets, cookies, raw logs, scraped HTML, and other sensitive runtime
  data out of every chezmoi-managed file.

## Agent Scripts and Extensions

- Keep a script needed only in this session in the session scratchpad named in
  the environment preamble, not `$TMPDIR`: the sandboxed `$TMPDIR` is shared by
  every concurrent session for this user, so a common subdirectory name
  silently overwrites another session's files.
- Name the scratchpad's absolute path in delegation prompts too.
- Before running an agent script, or writing a script that will run again, be
  handed to another agent, or be kept as a procedure, read `agent-scripts.md`.
- Before installing or enabling a public skill, subagent, plugin, or MCP-backed
  extension, vet it with `install-agent-extension`.
- Install or enable an extension that requests bypass permissions, broad write
  or shell access, hooks, MCP servers, credential reads, or automatic network
  actions only after the user explicitly approves that risk.
- Before installing or committing an agent extension or a managed skill, read
  `agent-extensions.md`.
