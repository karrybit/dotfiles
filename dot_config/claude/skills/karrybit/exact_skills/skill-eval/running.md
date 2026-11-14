# Running a Suite

Read when: running `claude plugin eval` against a plugin in place or a wrapper
built by `scripts/skill-wrap`, or grading and tabulating its results.

## The Suite Command

```sh
claude plugin eval <target> --scaffold --allow-tools <tools> --runs 3 -j 3 --model claude-sonnet-5-5 --judge-model claude-opus-5-5 --max-cost-usd <ceiling> --no-publish --trust-plugin --threshold 0 --keep-temp --output-dir DIR/out/<label> --json DIR/results/<label>.json
```

Take `<target>` and the flags beyond this command from the Comparisons table
in `SKILL.md`, and `<tools>` from the `README.md` in the skill's eval
directory.

| Flag | Purpose |
| --- | --- |
| `--scaffold` | Runs each case's scaffold script, which is off by default; omit it for a suite without scaffold scripts |
| `--allow-tools` | Grants the gated tools (`Bash`, `Write`, `Edit`, `WebFetch`, `mcp__*`) that cases list in `allowed_tools`; a case cannot grant them alone |
| `--disallow-tools Agent` | Removes `Agent`, which stays callable under `allowed_tools`; add it when a `tool_used` grader on `Edit` or `Write` must see every edit |
| `--runs`, `-j` | Runs per case, and runs at once (1 to 8, sharing one rate limit) |
| `--model`, `--judge-model` | The executor and the `llm` judge; fix and record both, since the judge defaults to `haiku` |
| `--max-cost-usd` | Hard ceiling, checked before each run starts, so an overrun is bounded to the runs in flight |
| `--trust-plugin` | Answers the first-run trust prompt, which a non-interactive run cannot |
| `--threshold 0` | Keeps the exit status 0 when a case scores below 1.0, so low scores are read from the JSON |
| `--keep-temp` | Keeps each run's workspace and trace; without it `tracePath` names a deleted file |
| `--no-publish` | Keeps the HTML report local |
| `--output-dir` | Writes `aggregate-result.json` and the HTML report there instead of into the plugin's eval directory, or the current directory for a target named by id |
| `--json <path>` | Writes the full result: prompts, graders, per-run scores, `costUsd` |

## Selecting Cases

- `--case <glob>` keeps only its last value when repeated; select several
  cases with `--tag` or with a separate eval directory.
- Tag cases in the `prompt.md` frontmatter (`tags: [fire]`).

## The Result JSON and the Kept Workspace

- Read runs at `.cases[].arms.<arm>[]`; each run has `graders[]` with `name`,
  `passed`, and `judgeVotes` for `llm` graders, plus `error` and `tracePath`.
- The JSON records the models once per suite (`.suite.modelOverride`,
  `.suite.judgeModel`), and for a wrapper the wrapped commit in
`.suite.plugins[].version`;
  a run's own model is in the `system` `init` line of its trace.
- A kept run directory, two levels above `tracePath`, holds `config/`,
  `out/trace.jsonl`, and `sealed/` (mode 000, holding `home/` and `tmp/`); the
  agent's working directory is `sealed/home/cwd`.
- Open a kept directory with `chmod 700` and run git only in a fresh copy, so
  no git command reads a `.git/config` the agent wrote.
- A run's final reply is the `result` field of the trace line whose `type` is
  `result`.

## Tabulating Pass Counts

```sh
jq -r '.cases[] | .name as $c | .arms | to_entries[] | .key as $a | [.value[].graders[]] | group_by(.name)[] | [$c, .[0].name, $a, "\(map(select(.passed)) | length)/\(length)"] | @tsv' DIR/results/<label>.json
```

## The `grade-kept` Contract

`scripts/grade-kept GRADE_PY RESULT_JSON ITER_DIR` rebuilds each run as
`ITER_DIR/eval-<fixture>/<arm>-<n>/repo`, a git repository whose `HEAD`
commit is the fixture and whose working tree is the run's workspace, then runs
`python3 -I GRADE_PY ITER_DIR`.

- `evals.json` sits beside `GRADE_PY`, and each case in the result file has an
  entry in `.evals[]` whose `name` is the case name and whose `files[0]` is the
  fixture directory relative to `evals.json`.
- `GRADE_PY` takes `ITER_DIR` as its only argument and reads that layout.
- Run it on scaffold suite results only: activation cases have no fixture.
