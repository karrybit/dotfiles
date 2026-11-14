---
name: skill-eval
description: Evaluate an existing skill unchanged with `claude plugin eval`, comparing it with no skill, an older version, a canary, or a holdout.
disable-model-invocation: true
---

# Evaluating a Skill With Plugin Evals

This skill measures a skill by running `claude plugin eval` against a plugin
directory that wraps it, so the skill's own files stay unchanged. Paths below
that start with `scripts/` or name a `.md` file are relative to this skill's
base directory.

## Rules for the Whole Task

- Run `claude plugin eval`, `claude -p`, and `scripts/grade-kept` outside the
  OS sandbox and every other command inside it: runs write under the system
  temp directory, and the workspaces they keep there are mode 000.
- Pass `--max-cost-usd` to every `claude plugin eval` and `--max-budget-usd`
  to every `claude -p`, and keep a running total of the reported costs.
- Run each `claude plugin eval` as one plain command without variables, `cd`,
  or redirects, so one approval covers exactly one run.
- Keep `DIR`, the directory for wrappers and results, outside the repository
  and on a path without words such as `eval` or `test`, since each run sees
  the plugin path.
- Decide from repeated runs: repeating one command has moved an `llm` grader's
  pass count by one run in three.
- Commit suite changes separately from skill changes, and commit the suite
  before a run, since the wrapper copies the suite from the working tree.

## The Evaluated Skill's `evals/` Directory

Each skill keeps its evaluation data in its own `evals/` directory:

| Path | Holds |
| --- | --- |
| `plugin-eval/` | The suite: one directory per case with `prompt.md`, `graders/*.md`, and optionally `case.yaml` and a scaffold script |
| `plugin-eval-holdout/` | Cases kept out of suite work, run only to check a change before adopting it |
| `plugin-eval-activation/` | Requests tagged `fire` or `nofire` that test the skill's description |
| `fixtures/` | Repositories that a scaffold script copies with `cp -R "$(dirname "$0")/../../fixtures/<name>/." .` |
| `canary.patch` | A `patch -p1` diff, relative to the skill directory, that removes load-bearing rules from `SKILL.md` |
| `evals.json`, `grade.py` | Script assertions that graders cannot express, run by `scripts/grade-kept` |
| `README.md` | What each case and file is for, the flags this suite needs, and what the suite separates |

`scripts/skill-wrap` copies each `plugin-eval*` directory to `evals*` in the
wrapper, so `plugin-eval-holdout/` runs with `--eval-dir evals-holdout`.

## Comparisons

| Comparison | Wrappers | Flags beyond the suite command |
| --- | --- | --- |
| Skill against no skill | `DIR/kit` at `HEAD` | none (two arms: with and without the plugin) |
| Older against newer version | one wrapper per ref | `--ablation none` on each |
| Canary | `DIR/kit-c`: a second `HEAD` wrapper with `canary.patch` applied | `--ablation none` |
| Holdout | `DIR/kit` | `--eval-dir evals-holdout` |
| Activation | `DIR/kit` | `--eval-dir evals-activation --ablation none`, without `--scaffold` |

Compare configurations by per-grader pass counts, not by case scores: with two
arms the `tool_used: Skill` grader is left out of the score, and with
`--ablation none` it counts.

## Steps

1. Build the wrappers: `scripts/skill-wrap <skill dir> HEAD DIR/kit`, one per
   ref the comparison needs. For the canary, build `DIR/kit-c` the same way and
   run `patch -p1 -d DIR/kit-c/skills/<skill name> -i <absolute path of canary.patch>`.
   Completion: `claude plugin validate DIR/kit` reports `Validation passed`
   for each wrapper; warnings about author, README, LICENSE, and icon are
   expected.
2. Check each new or changed `regex` grader with
   `scripts/regex-check.js <grader.md> <file>` against one file it must pass
   and one it must fail.
   Completion: each new or changed `regex` grader printed `PASS` for one file
   and `FAIL` for the other.
3. Run the suite with the command in `running.md`, once per wrapper and eval
   directory the comparison needs.
   Completion: each result JSON has `"partial": false`, every run has
   `"error": null`, and `costUsd` is recorded.
4. When the skill's `evals/` holds `grade.py`, run
   `scripts/grade-kept <evals dir>/grade.py DIR/results/<label>.json DIR/grade/<label>`
   for each scaffold suite result.
   Completion: `grade.py` printed one line per run with its pass count.
5. Tabulate pass counts per case, grader, and arm with the `jq` command in
   `running.md`.
   Completion: each grader has a pass count per arm for every result file.

## Reference Files

- Read `running.md` before step 3: the suite command, what each flag is for,
  selecting cases, the kept workspace, and the `grade-kept` contract.
- Read `graders.md` when writing or changing a case or grader.
- Read `changing-the-suite.md` when changing a suite's graders or cases, or
  when two results disagree: the adoption conditions and the `eval-auditor`
  run.

## Report

Report these items in this order:

- Per-grader pass counts per arm, one column per result file, labeled with
  the wrapped commit.
- `--model`, `--judge-model`, and `--runs` for each result file.
- The summed `costUsd` of every run, plus `total_cost_usd` of any `claude -p`.
- Which differences rest on one run, and which held across repeats.
