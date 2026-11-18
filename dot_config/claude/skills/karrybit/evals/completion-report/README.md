# karrybit:completion-report evals

Behavior cases for comparing versions of the `completion-report` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/typo-fix`: the user asks for a heading typo fix in `README.md`, a test run by the README's method, no commit, a report that follows the skill, and one extra heading `残った疑問`. The README's `./run-tests` calls `docker`, which the run cannot use.
  - `headings-in-order`: the seven template headings in order, then `## 残った疑問`.
  - `no-commit-is-none`, `nothing-new-is-none`: `## commit と PR` and `## 新しく作ったもの` have the body `なし`.
  - `failed-test-unverified`: `## 確かめられなかったこと` is not `なし` and names the test that could not run.
- `fixtures/notes-app`: the README with the typo and the `run-tests` script.

## Settings for This Suite

- Cases grant `Bash` and `Edit`: run them with `--scaffold --allow-tools Bash Edit`.
- Run the suite against a wrapper. chezmoi sets a deployed file's mode from the `executable_` prefix of its source name only, so the deployed `fixtures/notes-app/run-tests` loses its executable bit, and in an in-place run `./run-tests` fails with `Permission denied` instead of the `docker` error the case relies on; a wrapper copies the fixtures from the working tree with their mode.
- `completion-report` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/exact_agent-core/completion-report <ref> DIR/kit`.

## What the Suite Separates

Measured on wrappers holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), three repeats per configuration:

- `no-commit-is-none` passes 3/3 in each repeat of the skill, and 0/3 in each repeat of a version without the template line saying that no commit is the one word `なし` and without the rule naming where such an explanation goes: those runs write `なし（commit していません）`. With the template line removed and the one-word rule kept only under 書き方, it passes 1 of 9, so the line under the heading carries the behavior.
- The other graders fail at most one run in any repeat. They guard against regressions and do not separate versions.
- With the rule that writes a repeated fact under one heading and points to it from the others, every grader passes 3/3 in one repeat at 2e34e1b and one at 10778d8.
