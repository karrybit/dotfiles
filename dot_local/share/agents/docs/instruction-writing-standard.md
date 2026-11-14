# Instruction Writing Standard

Checked: 2026-11-08

Models checked: claude-opus-5-5

Sources:

- <https://code.claude.com/docs/en/memory.md>
- <https://code.claude.com/docs/en/best-practices.md>
- <https://code.claude.com/docs/en/skills.md>
- <https://code.claude.com/docs/en/sub-agents.md>
- <https://code.claude.com/docs/en/plugin-evals.md>
- <https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices.md>
- <https://github.com/agentsmd/agents.md>

Revalidate when:

- the model ID you are running as is not listed in Models checked;
- 90 days have passed since Checked;
- two rows in Cases share the same cause.

This file fixes the form and the numbers for five kinds of instruction file:
`CLAUDE.md`, `AGENTS.md`, `SKILL.md`, subagent definitions, and rule files.
The writing principles come from the `writing-for-agents` skill; where the two
disagree, this file wins.

Each rule carries the kind of evidence behind it: `[doc]` is stated in an
official source above, `[measured]` passed this file's evaluation (model ID and
date in Cases), `[inferred]` is unverified reasoning.

## Before Editing an Instruction File

- Compare your model ID with Models checked; when it is missing, or when another
  Revalidate when trigger holds, run Revalidation before the edit. [inferred]
- Keep the file's current language; write one language per file. [inferred]
- When delegating the edit, name this file's path in the delegation prompt,
  since a subagent acts on its prompt. [inferred]

## Common Rules

These apply to all five kinds.

- C1: Write one rule per bullet, in the form `When <situation>, <action>.`,
  with one action per bullet; omit the situation when the heading states it.
  [inferred]
- C2: Group rules under `##` headings that name a situation or topic, with
  bullets under each heading. [doc]
- C3: Use a table only to map a situation to a destination or a name to a
  meaning. [inferred]
- C4: Use a numbered list only for steps whose order matters, and end each step
  with a `Completion:` line (`完了条件:` in Japanese files) stating an outcome
  checkable from output. [inferred]
- C5: Wrap only non-rule material in XML tags: examples (`<example>`), pasted
  text, and output templates. [doc]
- C6: Write emphasis words and capitals (`MUST`, `IMPORTANT`, `NEVER`,
  `ALWAYS`, `CRITICAL`, `必ず`, `絶対`) as plain wording instead. [doc]
- C7: Move a rule that allows no exception into a hook, deny rule, or tool
  check, and leave one line saying what enforces it. [doc]
- C8: State what to do; when a prohibition is needed, put the action to take
  instead on the same line. [inferred]
- C9: Give a reason as one clause after the rule, and only when it changes how
  exceptions are judged; leave history to commit messages. [doc]
- C10: Write checkable terms (commands, paths, numbers, formats) in place of
  "appropriately", "sufficiently", or "as much as possible". [doc]
- C11: State each fact in one place and refer to it elsewhere by section name;
  after editing, search the file for lines that contradict the edited one.
  [doc]
- C12: Keep an always-loaded file at or under 200 lines, with the most important
  rules first. [doc]
- C13: Move a rule that only applies in some situations into a skill, a
  path-scoped rule, or a reference file, and leave a one-line pointer that names
  the trigger. [doc]
- C14: In Japanese, keep the subject and object explicit and end each sentence
  with a verb. [inferred]

## Per-Kind Rules

### `CLAUDE.md`

- User-scope files hold only behavior rules that apply in every repository; put
  repository rules in that repository's instruction file. [doc]
- Leave out what the code or configuration already shows. [doc]
- Name headings after the situation they govern (`## When Committing`).
  [inferred]

### `AGENTS.md`

- State the agent's role in the first sentence, then reference tables
  (information sources, write destinations), then one section per situation.
  [inferred]
- Put a tool's internals in its README or `--help`, and keep only when and what
  to run here. [inferred]
- Put an exception or standing permission directly under the rule it modifies.
  [inferred]

### `SKILL.md`

- Start the `description` with the main use case: what the skill does, then when
  to use it, within 1,536 characters together with `when_to_use`. [doc]
- Set `disable-model-invocation: true` on a skill whose steps have side effects.
  [doc]
- Keep `SKILL.md` under 500 lines, put the most important rules near the top,
  and move reference material into separate files. [doc]
- Word each rule so it applies to the whole task ("run the tests after every
  edit", not "run the tests"). [doc]
- Write each skill as a deep module that knows no other skill: describe what it
  needs from outside as an input contract instead of naming the skill that
  produces it. [inferred]
- When a skill exists to use one specific skill well, name that skill; this is
  the only exception to the rule above. [inferred]
- When a task needs several skills combined, put the combination in a separate
  orchestrator skill, and leave the combined skills unaware of it. [inferred]

### Subagent Definitions

- Write the `description` as the situations to delegate in, kept short; add
  "use proactively" when delegation should be eager. [doc]
- Order the body as: role in one sentence, what the request contains, numbered
  steps, numbered report items, then `Completion:`. [inferred]
- Make the body self-sufficient: the subagent sees only this prompt and basic
  environment details, not the caller's conversation. [doc]
- Limit `tools` to what the steps need. [doc]

### Rule Files and Reference Files

- Cover one topic per file and state in the first line when to read it.
  [inferred]
- Put the line that triggers reading the file in the caller's section for that
  situation. [doc]
- Scope a file under `.claude/rules/` with `paths`. [doc]

## What Enforces This

- After editing an instruction file, run
  `$XDG_DATA_HOME/agents/scripts/instruction-lint/bin/instruction-lint <file>`
  and fix every finding; it checks C4, C6, C12, and the `SKILL.md` and
  subagent frontmatter.
- Check C1, C11, and C13 by review: a passing lint shows form, not content.

## Revalidation

1. Compare Models checked with the model ID you are running as.
   Completion: the edit report states whether they match.
2. Reread the Sources and the official prompting page for the running model, and
   re-tag every rule `[doc]`, `[measured]`, or `[inferred]`.
   Completion: a list of rules to change exists, possibly empty.
3. Run Small Evaluation for each `[inferred]` rule and each rule on the list.
   Completion: each case has a pass count for the old and the new wording.
4. Edit this file, update Checked and Models checked, and commit with the
   changed rules and the evaluation results in the message.
   Completion: `instruction-lint` passes on this file.

## Small Evaluation

1. Write one case per rule: a one-sentence request that creates the situation, a
   grader (an output regex or the tool called), and the old and new wording.
   Completion: each case has all three parts.
2. For a `SKILL.md` or subagent, run the case with `claude plugin eval`; for a
   `CLAUDE.md` or `AGENTS.md`, place the candidate as `CLAUDE.md` in a scratch
   directory and run `claude -p "<request>" --model <model-id>` 3 times per
   wording (without `--bare`, which skips `CLAUDE.md`).
   Completion: each wording has a pass count out of 3.
3. Adopt the new wording when it passes at least as often as the old; rerun
   with 5 runs when the counts differ by one.
   Completion: each rule is tagged `[measured]` with the model ID and date in
   its Cases row, or the wording is reverted.

## Adding a Case

- When an agent breaks or misreads an instruction, append a row to Cases.
- Pick the cause from: (a) line form, (b) file too long, (c) contradicting
  lines, (d) a rule without exceptions that belongs in a hook.
- When one case points at a rule, fix only the line in that instruction file;
  when two cases share a cause, fix the rule here and name it in their rows.

## Cases

Append only.

| date | model | file:line | what happened | cause | fix | rule |
| --- | --- | --- | --- | --- | --- | --- |
