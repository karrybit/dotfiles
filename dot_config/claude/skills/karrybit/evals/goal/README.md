# karrybit:goal evals

Behavior cases for comparing versions of the `goal` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/two-goals`: the user asks for /goal completion conditions for two goals in `fixtures/csvtool`: fixing `split_row`, checkable with `bin/parse-test`, and making `README.md` easier to read, with no criterion.
  - `test-goal-condition`: goal 1 gets one line with `bin/parse-test`, its expected output or exit status, and an attempt limit.
  - `vague-goal-asked`: goal 2 gets a question to the user instead of an invented condition.
  - `stall-rule`: the reply carries the stall rule (the condition is not loosened, `緩め`).
  - `no-edit`, `no-write`: the skill writes conditions only; it changes no file.
- `fixtures/csvtool`: `parse.py`, whose `split_row` splits on every comma, and `bin/parse-test`.

## Settings for This Suite

- Cases grant `Bash`, `Edit`, and `Write`, so that `no-edit` and `no-write` can fail: run them with `--scaffold --allow-tools Bash Edit Write`.
- `goal` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/goal <ref> DIR/kit`.

## What the Suite Separates

Measured on wrappers holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), three repeats per configuration:

- `test-goal-condition` passes 9 of 9 runs of the skill, and 8 of 9 of a version without the rule to build the predicate from the workspace's existing checks; the failing run wrote its own one-line check instead of `bin/parse-test`. The difference rests on one run.
- The other graders pass every run of both versions. They guard against regressions and do not separate versions.
