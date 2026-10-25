# docs-information-design evals

Behavior cases for comparing the skill against a no-skill baseline, across skill versions and models. Not deployed (see `.chezmoiignore`).

- `evals.json`: one case per fixture. `expected_output` describes one good outcome, not the only one; `assertions` are either `script` (checked by `grade.py`) or `judge` (needs a reader's judgment).
- `fixtures/`: small repositories, one per case. Several deliberately reward leaving things alone (cases 4, 5, 7, 11).
- `grade.py ITERATION_DIR`: runs the script assertions over `eval-<fixture>/<config>/repo`, where each repo is the fixture committed once and then edited by a run. Writes `grading.json` per run.
- `trigger-evals.json`: should-trigger and near-miss should-not-trigger queries for the description.

## Running a comparison

1. Copy each fixture to `ITERATION_DIR/eval-<fixture>/<config>/repo`, then `git init && git add -A && git commit -m fixture` inside it.
2. Give each run only the case prompt and the repo path; for skill runs, also the path to the `SKILL.md` under test. Ask for the user-facing reply in `outputs/response.md`.
3. Run `python3 -I grade.py ITERATION_DIR`.
4. Script assertions rarely separate strong configurations. Compare pairs blind: copy both results to neutral `A`/`B` paths, let a judge read the diffs and replies against the case's judge assertions, allow ties, and unblind afterwards.

For trigger tests with skill-creator's `run_eval`, run queries one at a time. Parallel workers each write an identically described command file into the same `.claude/commands/`, so the model often invokes a sibling's copy and the run counts it as not triggered.
