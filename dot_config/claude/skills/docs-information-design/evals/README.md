# docs-information-design evals

Behavior cases for comparing the skill against a no-skill baseline, across skill versions and models. Not deployed (see `.chezmoiignore`).

- `evals.json`: one case per fixture. `expected_output` describes one good outcome, not the only one; `assertions` are either `script` (checked by `grade.py`) or `judge` (needs a reader's judgment).
- `fixtures/`: small repositories, one per case. Several deliberately reward leaving things alone (cases 4, 5, 7, 11).
- `grade.py ITERATION_DIR`: runs the script assertions over `eval-<fixture>/<config>/repo`, where each repo is the fixture committed once and then edited by a run. Writes `grading.json` per run.
- `trigger-evals.json`: should-trigger and near-miss should-not-trigger queries for the description.

## Running a comparison

1. Copy each fixture to `ITERATION_DIR/eval-<fixture>/<config>/repo`, then `git init && git add -A && git commit -m fixture` inside it.
   Completion: `git log` in each repo shows the one `fixture` commit.
2. Give each run only the case prompt and the repo path; for skill runs, also the path to the `SKILL.md` under test. Ask for the user-facing reply in `outputs/response.md`.
   Completion: each `<config>` directory has `outputs/response.md`.
3. Run `python3 -I grade.py ITERATION_DIR`.
   Completion: `grading.json` exists next to each repo.
4. Script assertions rarely separate strong configurations. Compare pairs blind: copy both results to neutral `A`/`B` paths, let a judge read the diffs and replies against the case's judge assertions, allow ties, and unblind afterwards.
   Completion: each pair has a verdict (`A`, `B`, or tie) recorded before unblinding.

For trigger tests with skill-creator's `run_eval`, run queries one at a time. Parallel workers each write an identically described command file into the same `.claude/commands/`, so the model often invokes a sibling's copy and the run counts it as not triggered.

## Running with Plugin Evals

`claude plugin eval` runs each case in a fresh workspace, once with the skill loaded as a plugin and once without, and scores each run with the case's graders.

- `plugin-eval/`: the suite used to judge skill and suite changes, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`). Case names match `evals.json`; each `fixture.sh` copies its fixture from `fixtures/`.
- `plugin-eval-holdout/`: cases kept out of suite work, run only to check a change before adopting it.
- `plugin-eval-activation/`: `trigger-evals.json` as cases, tagged `fire` or `nofire`.
- `canary.patch`: removes from `SKILL.md` the equal-outcomes rule, the diff-boundary rule, and section 5. A grader that measures the skill passes less often on the canary than on the skill.
- `bin/skill-wrap REF OUT_DIR`: builds a plugin directory from the skill at git `REF` and the suites and fixtures from this working tree.
- `bin/grade-kept RESULT_JSON ITER_DIR`: runs `grade.py` over the workspaces a `--keep-temp` run left behind, for the assertions graders cannot express (searches across files, link resolution, files whose names are not known in advance).
- `bin/regex-check.js GRADER.md FILE`: applies a `regex` grader to a file, to check a pattern against one passing and one failing input before a paid run.
- `eval-auditor.md`: a subagent that audits the suite against result files and proposes grader changes without applying them; `bin/to-agents-json` converts it for `claude -p --agents`.

Run `claude plugin eval` and `bin/grade-kept` outside the OS sandbox: the runs write under the system temp directory, and the kept workspaces there are mode 000. Keep `DIR` below outside this repository, on a path without words such as `eval` or `test`, since each run sees the plugin path.

1. Build the wrappers: `bin/skill-wrap HEAD DIR/kit`. For the canary, build `DIR/kit-c` the same way and run `patch -p1 -d DIR/kit-c/skills/docs-information-design -i <absolute path of canary.patch>`. For an older skill, pass its commit as `REF`.
   Completion: `claude plugin validate DIR/kit` reports `Validation passed` (warnings about author, README, LICENSE, and icon are expected).
2. Run the suite: `claude plugin eval DIR/kit --scaffold --allow-tools Write Edit --runs 3 -j 3 --model claude-sonnet-5-5 --judge-model claude-opus-5-5 --max-cost-usd 15 --no-publish --trust-plugin --threshold 0 --keep-temp --json DIR/results/kit.json`. For the canary or an older skill, add `--ablation none`; for the holdout, add `--eval-dir evals-holdout`; for activation, replace `--scaffold --allow-tools Write Edit` with `--eval-dir evals-activation --ablation none --runs 2 -j 8`.
   Completion: the JSON has `"partial": false`, every run has `"error": null`, and `costUsd` is recorded.
3. Run `bin/grade-kept DIR/results/kit.json DIR/grade/kit`.
   Completion: `grade.py` prints one line per run with its script-assertion pass count.
4. Tabulate pass counts per case, grader, and arm: `jq -r '.cases[] | .name as $c | .arms | to_entries[] | .key as $a | [.value[].graders[]] | group_by(.name)[] | [$c, .[0].name, $a, "\(map(select(.passed)) | length)/\(length)"] | @tsv' DIR/results/kit.json`.
   Completion: each grader has a pass count per arm.

### Reading results

- Compare skill versions by per-grader pass counts, not by case scores: with two arms the `tool_used: Skill` grader is unscored, and with `--ablation none` it counts.
- Repeat a run before trusting a difference: repeating the same command has moved an `llm` grader's pass count by one run in three.
- Select several cases with `--tag` or a separate eval directory; `--case` keeps only its last value when repeated.
- Cases grant no Bash, so a `tool_used` grader with `max: 0` on `Edit` or `Write` shows that no file changed, as long as no run delegates edits: `allowed_tools` leaves `Agent` callable, and `--disallow-tools Agent` removes it.
- `regex` patterns run as JavaScript and count UTF-16 code units.
- An `llm` judge sees only the output, so a rubric states the fixture facts it relies on; check each against the fixture.

### What the suite separates

Measured with the step 2 command, two repeats per configuration:

- `good-docs-audit/no-change-verdict` scores the skill above both the canary and no skill (skill 3/3 in both repeats, canary 1/3, no skill 1/3).
- `good-docs-audit/no-fabricated-issues` scores the skill above no skill (3/3 against 1/3 and 2/3); the canary keeps the rule it checks and scores like the skill.
- `splittable-but-cohesive/runbook-mismatch-reported` passes less often with the skill (5 of 15 runs) than without it (7 of 15) or with the canary (11 of 15): runs that never open `docs/runbook.md` miss the mismatch.
- The other graders fail at most one run in any repeat of any configuration. They guard against regressions and do not separate configurations.
- `local-paragraph-edit` never fires the skill, since its description excludes local wording fixes, so the case measures the model alone.

### Changing the suite

- Commit suite changes separately from skill changes.
- Before adopting a suite change, run the changed suite twice against the skill and twice against the canary.
- Adopt it when the canary still passes less often than the skill on at least as many graders as before, the holdout score does not fall and its failing-grader count does not rise, and any rise in score comes with closer agreement with the fixture's facts.
- After two consecutive rejected suite changes, stop changing the suite and keep the results so far.
- Run `eval-auditor` only when changing the suite or when results disagree, and decide adoption from reruns rather than from its predictions. Write a request naming `DIR/kit` and each result file with its label (skill with baseline, canary, older version, repeat), leaving the holdout out, then run `bin/to-agents-json eval-auditor.md`, save its output as `DIR/agents.json`, and run `claude -p "Follow the audit request in <request path>." --agents DIR/agents.json --agent eval-auditor --add-dir <system temp directory> --add-dir DIR --max-budget-usd 15 --output-format json --allowedTools Read Glob Grep 'Bash(jq *)'`. Run `bin/grade-kept` on each named result file first, since it opens the kept workspaces the auditor reads.
