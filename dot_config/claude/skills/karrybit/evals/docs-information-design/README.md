# karrybit:docs-information-design evals

Behavior cases for comparing the skill against a no-skill baseline, across skill versions and models. Run them with the `karrybit:skill-eval` skill, which runs `claude plugin eval` against the deployed `karrybit` plugin or against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/`: the suite used to judge skill and suite changes, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`). Case names match `evals.json`; each `fixture.sh` copies its fixture from `fixtures/`.
- `plugin-eval-holdout/`: cases kept out of suite work, run only to check a change before adopting it.
- `plugin-eval-activation/`: should-trigger and near-miss should-not-trigger requests for the description, tagged `fire` or `nofire`.
- `canary.patch`: removes from `SKILL.md` the equal-outcomes rule, the diff-boundary rule, and section 5. A grader that measures the skill passes less often on the canary than on the skill.
- `fixtures/`: small repositories, one per case. Several deliberately reward leaving things alone (cases 4, 5, 7, 11).
- `evals.json`: one entry per `plugin-eval/` and `plugin-eval-holdout/` case, naming its fixture for `grade-kept`. `expected_output` describes one good outcome, not the only one; `assertions` are either `script` (checked by `grade.py`) or `judge` (needs a reader's judgment). A script assertion holds only what the case's graders cannot express.
- `grade.py ITERATION_DIR`: runs the script assertions over `eval-<fixture>/<config>/repo`, where each repo is the fixture committed once and then edited by a run. Writes `grading.json` per run. `karrybit:skill-eval`'s `grade-kept` builds that layout from a `--keep-temp` run, for the assertions graders cannot express (searches across files, link resolution, files whose names are not known in advance).

## Settings for This Suite

- `plugin-eval/` and `plugin-eval-holdout/` cases edit files and grant no Bash: run them with `--scaffold --allow-tools Write Edit`.
- `plugin-eval-activation/` cases have no scaffold: run them with `--eval-dir evals/docs-information-design/plugin-eval-activation --ablation none --runs 2 -j 8` against the plugin, or `--eval-dir evals-activation` against a wrapper.
- Pass `grade.py` in this directory to `grade-kept` for `plugin-eval/` and `plugin-eval-holdout/` results.
- Since cases grant no Bash, the `no-edit` and `no-write` graders (`tool_used` with `max: 0`) show that no file changed.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), two repeats per configuration:

- `good-docs-audit/no-change-verdict` scores the skill above both the canary and no skill (skill 3/3 in both repeats, canary 1/3, no skill 1/3).
- `good-docs-audit/no-fabricated-issues` scores the skill above no skill (3/3 against 1/3 and 2/3); the canary keeps the rule it checks and scores like the skill.
- `splittable-but-cohesive/runbook-mismatch-reported` passes exactly in the runs that open `docs/runbook.md`. The skill passes it in 9 of 9 runs in each of two measurements (three repeats of `--case splittable-but-cohesive`); a version without the rule in section 3 to find and read the documents that link to one whose boundary is in question, and without that rule in step 3's completion, passed it in 3 of 9 in each.
- The other graders fail at most one run in any repeat of any configuration. They guard against regressions and do not separate configurations.
- `local-paragraph-edit` never fires the skill, since its description excludes local wording fixes, so the case measures the model alone.
