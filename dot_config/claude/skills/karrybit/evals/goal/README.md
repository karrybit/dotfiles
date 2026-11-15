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
