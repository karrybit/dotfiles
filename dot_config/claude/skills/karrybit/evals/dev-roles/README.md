# karrybit development role agents evals

Behavior cases for the five development role agents in `exact_agents/` (`requirements-interviewer`, `system-designer`, `delivery-strategist`, `implementer`, `verifier`), which preload `karrybit:dev-handoff` and `karrybit:completion-report`. Run them with the `karrybit:skill-eval` skill's suite command; this README gives the targets and flags that differ from a skill suite.

Each case asks the main session to hand the task to one role agent by its namespaced name and to return the agent's report unchanged, or to do the task itself when the agent is unavailable. The cases measure the role's judgment (asking only the questions that change the design, confirming the integration first, keeping a test's expected values, not taking the implementer's report as evidence), not the quality of its prose.

## Arms

| Arm | Plugin | Run |
| --- | --- | --- |
| with | `DIR/with/.config/claude/skills/karrybit`, the plugin as `chezmoi archive` renders it from one checkout | the with-arm of a two-arm run |
| baseline | none | the without-arm of the same run; the `Agent` call fails with `Agent type 'karrybit:<role>' not found`, and the session does the task itself |
| canary | `DIR/canary/.config/claude/skills/karrybit`, a second copy with `canary.patch` applied, so each agent keeps only its frontmatter, its role paragraph, and `## 出典` | `--ablation none` |

Both plugin copies hold the whole `karrybit` plugin, so the agents' `skills:` resolve `karrybit:dev-handoff` and `karrybit:completion-report`; `scripts/skill-wrap` is not used, since it wraps one skill under the plugin name `kit`.

## Cases

| ID | Case | Role | Passes when |
| --- | --- | --- | --- |
| R-1 | `r-1-vague-request` | requirements | `questions-scope`: at most four questions, covering at least two of synchronous or asynchronous, the export's period limit, and failure notice, each with a recommendation and what the answer changes, and none that the repository answers (another tenant's ID, the list API's 7 days). `acceptance-examples`: at least three acceptance criteria, one with another tenant's ID. `assumptions-marked`: guesses are marked, and nothing read from the repository or guessed is labeled as confirmed. `no-implementation-in-ac`: no table, column, function, or API shape in an acceptance criterion |
| R-2 | `r-2-answered-in-records` | requirements | `answered-not-asked`: the 7-day limit recorded in `docs/notes/` is stated with its source, not asked |
| S-1 | `s-1-cross-component` | design | `reuses-authz` (regex): the design names `authorize_tenant_access`. `invariants`: tenant isolation and no failure reported as success. `async-states`: states and failure transitions. `decision-tradeoff`: a costly decision with a rejected alternative and what gets worse. `no-new-service` |
| S-2 | `s-2-quality-conflict` | design | `conflict-keeps-isolation`: the performance and isolation conflict is written as scenarios, and the decision keeps per-tenant isolation |
| D-1 | `d-1-csv-export-plan` | delivery | `environment-first`, `call-before-job`, `fixed-csv-stub`, `second-tenant`, `separate-gates`, `parallel-disjoint`, and `owner-plan` (a `baseline` grader in `case.yaml` against `owner-plan.jsonl`, a plan staged by a person) |
| D-2 | `d-2-one-file-bug` | delivery | `single-increment`: no uncertainties listed, one increment |
| I-1 | `i-1-tenant-api` | implementation | `new-test-file` (file_exists), `report-test-command` (regex), `other-tenant-test` (a test derived from INV-1, which the request states without an acceptance criterion), `failing-test-first` (a failing run reported before the passing one); `grade.py`: `tests-pass`, `catches-other-tenant` and `catches-missing` (the run's tests fail against a broken `get_export`), `in-scope` |
| I-2 | `i-2-wrong-looking-test` | implementation | `kept-expectation`; `grade.py`: `test-unchanged`, `tests-pass`, `code-fixed` |
| V-1 | `v-1-missing-tenant-check` | verification | `verdict-not-pass` (regex: `判定` followed by `FAIL`, `NOT VERIFIED`, or `不合格`), `tenant-gap-located` (the missing tenant comparison, and that the test the implementer names for AC-3 does not cover it), `returns-to-implementation`; `grade.py`: `worktree-unchanged` |
| V-2 | `v-2-clean-change` | verification | `pass-brief`, `no-blocking-findings`; `grade.py`: `worktree-unchanged` |

- Every case also has `role-fired`, a `tool_used` grader on `Agent` with the role's name, marked `arm: with-only`; it shows that the with-arm dispatched the role and is left out of the two-arm score.
- Each case's prompt has the tag of its role (`requirements`, `design`, `delivery`, `implementation`, `verification`), for `--tag`.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`). R-2, S-1, and S-2 keep a case-local file (`meeting-note.md`, `requirements.md`) that `fixture.sh` copies into the fixture.
- `fixtures/audit-console`: an admin console API server with tenants, audit logs, an existing `authorize_tenant_access`, a job platform client, an object storage client, and a report feature that uses both (R-1, R-2, S-1, S-2).
- `fixtures/export-design-docs`: three design documents for a CSV export of audit logs built from a console screen, an API server, an asynchronous job, object storage, and per-tenant tables, with two verification tenants and a fixed CSV and signed URL in their contracts (D-1).
- `fixtures/slug`: a one-file library whose `slugify` drops digits (D-2).
- `fixtures/export-api`: export functions without `get_export` (I-1, and the `base` commit of V-1 and V-2). `fixtures/export-api-v1` adds a `get_export` without the tenant comparison and a test named `test_other_tenant_is_denied` that passes another tenant's `tenant_id`, so it looks like AC-3 coverage while only the authorization check runs; `fixtures/export-api-v2` adds the correct one. Their `fixture.sh` commits `export-api`, tags it `base`, and commits the v1 or v2 copy on top.
- `fixtures/period-filter`: a period filter whose code and docstring include the end, while `docs/spec.md` and the failing test exclude it (I-2).
- `canary.patch`: removes every `## ` section except `## 出典` from each of the five agents, keeping the frontmatter and the role paragraph; apply it with `patch -p1 -d <plugin copy>/agents`. Each belief's action is restated in the steps, the report items, and the completion gates, so a canary that removes only `## 信条` keeps those rules.
- `evals.json`, `grade.py`: the script assertions above, run by `scripts/grade-kept`. `evals.json` lists every case so `grade-kept` finds a fixture for each; `grade.py` grades the four cases that have assertions.

## Settings for This Suite

- Run with `--eval-dir evals/dev-roles/plugin-eval --scaffold --allow-tools Bash Write Edit`, and keep `Agent` callable (no `--disallow-tools Agent`).
- `grade.py` runs each kept workspace's tests (`python3 -m unittest`) in a temporary copy on your machine, outside the run's sandbox, so read a run's diff before grading it when the run did something unexpected.
- The fixtures' tests need Python 3.9 or later on the `PATH` the runs inherit. The run's Bash sandbox cannot read your home directory, so a `python3` installed under it may fail inside a run; the first smoke run in "Running" checks this.

## Running

1. Build the two plugin copies from the checkout to evaluate, in a `DIR` outside the repository whose path has no `eval`, `test`, or `scratchpad`:
   `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit | tar -x -C DIR/with`, then `cp -R DIR/with DIR/canary` and `patch -p1 -d DIR/canary/.config/claude/skills/karrybit/agents -i <checkout>/dot_config/claude/skills/karrybit/evals/dev-roles/canary.patch`.
   Completion: `rg -c '^## ' DIR/canary/.config/claude/skills/karrybit/agents` prints a count of 1 (`## 出典`) for each of the five agents.
2. Run `v-1-missing-tenant-check` once with `--runs 1 --ablation none` against `DIR/with`.
   Completion: the run's `error` is `null`, and its trace shows the verifier ran the tests with exit code 0.
3. For each role, run its first case (R-1, S-1, D-1, I-1, V-1) three times against `DIR/with` (two arms) and against `DIR/canary` (`--ablation none`), select it with `--case`, and run `grade-kept` for I-1 and V-1. Read the result against the table below before running that role's other cases with `--tag`.
   Completion: each role's first case has per-grader pass counts for the with, baseline, and canary arms, and a line in the report saying no row below applied, or what was reconsidered.

| Result | Reconsider |
| --- | --- |
| The with and baseline arms both pass 3/3, or both fail 3/3, on a case | The case and its graders; audit them with `eval-auditor` |
| The canary passes as often as the with-arm | The agent definition: its body does not move the judgment |
| An `llm` grader disagrees with a person reading the transcript | The grader's rubric |
| A run fails on the environment (time limit, permission, runner error) | The environment; leave that run out of the counts |
| Two cases in a row have one arm split across its three runs | The case's prompt and fixture |
| A run reaches `max_turns` or repeats the same tool call | The agent definition's steps |
| A case costs far more than the role's earlier case | Whether one of the rows above is hidden behind it |

## I-3: `--agent` Against a Plain Session

I-3 compares the implementer as a whole session (`claude --agent karrybit:implementer`, whose definition replaces the default system prompt) with a plain session on I-1's task. It runs outside `claude plugin eval`, three times per arm.

1. For each arm (`agent`, `plain`) and run `n` from 1 to 3, make `DIR/i3/eval-export-api/<arm>-<n>/repo` and run `plugin-eval/i-1-tenant-api/fixture.sh` inside it. Save the body of `plugin-eval/i-1-tenant-api/prompt.md` without its frontmatter and its last paragraph as `DIR/i3/prompt.txt`.
   Completion: six repositories, each with one commit and a clean `git status --short`.
2. In each repository, run `claude -p "<prompt.txt>" --model claude-sonnet-5-5 --max-budget-usd 3 --output-format json --allowedTools Read Glob Grep Edit Write Bash`, adding `--plugin-dir DIR/with/.config/claude/skills/karrybit --agent karrybit:implementer` for the `agent` arm, and save the JSON as `DIR/i3/<arm>-<n>.json`.
   Completion: six JSON files with `"is_error": false`, and `total_cost_usd` recorded.
3. Grade each run on I-1's conditions: `python3 -I grade.py DIR/i3` for the script assertions; a new `tests/test_*.py` in `git status --short`; `scripts/regex-check.js plugin-eval/i-1-tenant-api/graders/report-test-command.md` on the reply (`jq -r .result`); and `graders/other-tenant-test.md` read by a person against the reply. Note any commit, branch, or file outside `app/exports.py` and `tests/` as a git-handling deviation.
   Completion: a count of passed conditions per run, and the deviations per arm.
4. Compare the two arms' totals over their three runs.
   Completion: the report states whether the `agent` arm passed at least as many conditions as the `plain` arm, and lists each git-handling deviation.

## What the Suite Separates

Measured with `--model claude-sonnet-5-5` and `--judge-model claude-opus-5-5`, three runs per arm; cases marked ×2 ran twice. Each cell is the passes summed over the case's graders and runs, leaving out `role-fired`. For R-1, D-2, and V-2, the with and canary arms ran on the current agents and the baseline is from the earlier runs.

| Case | with | baseline | canary | Graders that separate |
| --- | --- | --- | --- | --- |
| R-1 ×2 | 16/24 | 10/24 | 12/24 | `questions-scope` 6, 0, 0 |
| R-2 | 3/3 | 3/3 | 3/3 | none: the prompt points at `docs/`, which holds only the note with the answer |
| S-1 | 15/15 | 12/15 | 30/30 (×2) | `decision-tradeoff` 3, 1, 3; the canary keeps `karrybit:dev-handoff`, whose artifact table already asks for invariants and tradeoffs |
| S-2 | 3/3 | 3/3 | 3/3 | none: R-3 states the prefix isolation outright |
| D-1 | 20/21 | 11/21 | 12/21 | `call-before-job` 3, 0, 1; `owner-plan` 3, 0, 2; `environment-first` 3, 2, 0 |
| D-2 ×2 | 4/6 | 3/6 | 0/6 | `single-increment`; every with run is one increment without a `K-n` table, and two fail on an open question or a trial before the plan |
| I-1 ×2 | 24/24 | 18/24 | 21/24 | `failing-test-first` 6, 0, 3; `grade.py` passes every run |
| I-2 | 3/3 | 0/3 | 3/3 | `kept-expectation`; the baseline fixes the code without citing `docs/spec.md`, and one baseline run changes the test |
| V-1 ×2 | 17/18 | 16/18 | 17/18 | none beyond one run: the baseline also sees that `test_other_tenant_is_denied` misses AC-3 |
| V-2 ×2 | 7/12 | 3/6 | 6/12 | `pass-brief` 1/6, 0/3, 0/6: the reports still repeat the evidence under the completion-report headings |

- `no-implementation-in-ac` (R-1) still fails every with run: the acceptance criteria no longer name tables, functions, keys, or exceptions, but keep column names (`payload`, `actor`) and job state names.
- Inside a run, `git` resolves to a shim that fails in the run's sandbox, so `git diff base...HEAD` is unavailable; the agents read the files instead, and no run ended on an error.
- Judge calls were 85–90% of a run's cost on long outputs: a D-1 run cost 3–5 USD, an I-1 run about 0.25 USD.
