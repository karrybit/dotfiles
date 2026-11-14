# Instruction Maintenance

Read when: proposing or applying a change to an instruction file, choosing
between a skill, a hook, and a `CLAUDE.md` rule, or copying an external skill
in by hand. The form of the lines is in
`instruction-writing-standard.md` beside this file.

## Proposing a Change

- Place instructions in the narrowest applicable repository `CLAUDE.md` or
  `AGENTS.md`.
- Classify each proposed improvement: user-level guidance belongs in
  `$XDG_CONFIG_HOME/claude/CLAUDE.md`, repository-specific guidance in the
  narrowest applicable repository `CLAUDE.md` or `AGENTS.md`.
- When a repository instruction repeats a user-scope rule, remove it from the
  repository file and keep the user-scope rule.
- For each proposed change, give the target file, proposed wording, reason, and
  overlap or conflict with existing rules.
- Apply instruction changes only after user approval.
- Add a rule for a one-off situation only when the impact is significant.
- Write rules with a clear trigger and expected action.
- Treat instruction files as a maintained system, not an append-only log: when
  adding or reviewing instructions, look for outdated, duplicated,
  overlapping, too-specific, or ineffective rules and propose removing or
  consolidating them.
- Prefer replacing several narrow rules with one clearer general rule when it
  preserves the intended behavior.

## Choosing a Mechanism

- Prefer verification commands, tests, or hooks over behavioral instructions
  when the check can inspect the artifact itself, not when it would have to
  infer intent from a proxy such as a command string.
- Write a norm about how to reason in prose, paired with a requirement to state
  the deviation so it is visible in the transcript.
- Before adding a skill, choose the mechanism deliberately: a skill fires
  probabilistically and costs a description line in every session, so use one
  only for an on-demand workflow, specialized domain knowledge, a deterministic
  helper script, or bundled reference material.
- Put a norm that must apply every time its situation occurs in `CLAUDE.md`, not
  in a skill, since a skill is the wrong mechanism when a missed trigger is a
  failure.
- Prefer a plugin when an official or maintained equivalent exists, and keep
  upstream skill files upstream, since a hand-copied skill has no ref to
  compare against and drifts silently as upstream renames, splits, or deletes
  it.
- Add a skill only when it does something general engineering practice, an
  existing skill, and the harness itself do not already cover.
