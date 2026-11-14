# karrybit:docs-information-design evals

Behavior cases for comparing the skill against a no-skill baseline, across skill versions and models. Not deployed (see `.chezmoiignore`). Run them with the `karrybit:skill-eval` skill, which wraps this skill as a plugin and runs `claude plugin eval`.

## Files

- `plugin-eval/`: the suite used to judge skill and suite changes, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`). Case names match `evals.json`; each `fixture.sh` copies its fixture from `fixtures/`.
- `plugin-eval-holdout/`: cases kept out of suite work, run only to check a change before adopting it.
- `plugin-eval-activation/`: `trigger-evals.json` as cases, tagged `fire` or `nofire`.
- `canary.patch`: removes from `SKILL.md` the equal-outcomes rule, the diff-boundary rule, and section 5. A grader that measures the skill passes less often on the canary than on the skill.
- `fixtures/`: small repositories, one per case. Several deliberately reward leaving things alone (cases 4, 5, 7, 11).
- `evals.json`: one case per fixture. `expected_output` describes one good outcome, not the only one; `assertions` are either `script` (checked by `grade.py`) or `judge` (needs a reader's judgment).
- `grade.py ITERATION_DIR`: runs the script assertions over `eval-<fixture>/<config>/repo`, where each repo is the fixture committed once and then edited by a run. Writes `grading.json` per run. `karrybit:skill-eval`'s `grade-kept` builds that layout from a `--keep-temp` run, for the assertions graders cannot express (searches across files, link resolution, files whose names are not known in advance).
- `trigger-evals.json`: should-trigger and near-miss should-not-trigger queries for the description.

For trigger tests with skill-creator's `run_eval`, run queries one at a time. Parallel workers each write an identically described command file into the same `.claude/commands/`, so the model often invokes a sibling's copy and the run counts it as not triggered.

## Settings for This Suite

- `plugin-eval/` and `plugin-eval-holdout/` cases edit files and grant no Bash: run them with `--scaffold --allow-tools Write Edit`.
- `plugin-eval-activation/` cases have no scaffold: run them with `--eval-dir evals-activation --ablation none --runs 2 -j 8`.
- Pass `grade.py` in this directory to `grade-kept` for `plugin-eval/` and `plugin-eval-holdout/` results.
- Since cases grant no Bash, the `no-edit` and `no-write` graders (`tool_used` with `max: 0`) show that no file changed.

## What the Suite Separates

Measured with `karrybit:skill-eval`'s suite command (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), two repeats per configuration:

- `good-docs-audit/no-change-verdict` scores the skill above both the canary and no skill (skill 3/3 in both repeats, canary 1/3, no skill 1/3).
- `good-docs-audit/no-fabricated-issues` scores the skill above no skill (3/3 against 1/3 and 2/3); the canary keeps the rule it checks and scores like the skill.
- `splittable-but-cohesive/runbook-mismatch-reported` passes less often with the skill (5 of 15 runs) than without it (7 of 15) or with the canary (11 of 15): runs that never open `docs/runbook.md` miss the mismatch.
- The other graders fail at most one run in any repeat of any configuration. They guard against regressions and do not separate configurations.
- `local-paragraph-edit` never fires the skill, since its description excludes local wording fixes, so the case measures the model alone.
