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
- `completion-report` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/completion-report <ref> DIR/kit`.

## What the Suite Separates

Measured on wrappers holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), three repeats per configuration:

- `no-commit-is-none` passes 3/3 in each repeat of the skill, and 0/3 in each repeat of a version without the template line saying that no commit is the one word `なし` and without the rule naming where such an explanation goes: those runs write `なし（commit していません）`.
- The other graders fail at most one run in any repeat. They guard against regressions and do not separate versions.
