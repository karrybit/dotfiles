# karrybit development role agents evals

Behavior cases for the five development role agents in `exact_agents/` (`requirements-interviewer`, `system-designer`, `delivery-strategist`, `implementer`, `verifier`), which preload `karrybit:dev-handoff` and `karrybit:completion-report`. Run them with the `karrybit:skill-eval` skill's suite command; this README gives the targets and flags that differ from a skill suite.

Each case asks the main session to hand the task to one role agent by its namespaced name and to return the agent's report unchanged, or to do the task itself when the agent is unavailable. The cases measure the role's judgment (asking only the questions that change the design, confirming the integration first, keeping a test's expected values, not taking the implementer's report as evidence), not the quality of its prose.

## Arms

| Arm | Plugin | Run |
| --- | --- | --- |
| with | `DIR/with/.config/claude/skills/karrybit`, the plugin as `chezmoi archive` renders it from one checkout | the with-arm of a two-arm run |
| baseline | none | the without-arm of the same run; the `Agent` call fails with `Agent type 'karrybit:<role>' not found`, and the session does the task itself |
| canary | `DIR/canary/.config/claude/skills/karrybit`, a second copy with `canary.patch` applied, so each agent keeps only its frontmatter, its role paragraph, and `## 出典` where it has one | `--ablation none` |

Both plugin copies hold the whole `karrybit` plugin, so the agents' `skills:` resolve `karrybit:dev-handoff` and `karrybit:completion-report`; `scripts/skill-wrap` is not used, since it wraps one skill under the plugin name `kit`.

## Cases

| ID | Case | Role | Passes when |
| --- | --- | --- | --- |
| R-1 | `r-1-vague-request` | requirements | `questions-scope`: at most four questions, covering at least two of synchronous or asynchronous, the export's period limit, and failure notice, each with a recommendation and what the answer changes, and none that the repository answers (another tenant's ID, the list API's 7 days). `acceptance-examples`: at least three acceptance criteria, one with another tenant's ID. `assumptions-marked`: guesses are marked, and nothing read from the repository or guessed is labeled as confirmed. `no-implementation-in-ac`: no acceptance criterion names an internal table, column, function, exception class, job state, or storage key, or a new endpoint; what the user observes, in plain words, is fine |
| R-2 | `r-2-answered-in-records` | requirements | `answered-not-asked`: the 7-day limit recorded in `docs/notes/` is stated with its source, not asked |
| R-3 | `r-3-vague-quality` | requirements | `no-means-in-ac`: no acceptance criterion requires Redis or another mechanism. `quality-concrete`: "fast" and "does not fail on large data" become numbers and scenarios, or questions asking for them. `means-separated`: Redis is kept as the requester's proposed means, apart from the goal |
| R-4 | `r-4-public-contract` | requirements | `keeps-public-contract`: an acceptance criterion or a constraint it refers to keeps the documented public fields and status codes. `no-internal-names-in-ac`: no internal module, function, class, or exception in an acceptance criterion, while public names are allowed |
| S-1 | `s-1-cross-component` | design | `reuses-authz` (regex): the design names `authorize_tenant_access`. `invariants`: tenant isolation and no failure reported as success. `async-states`: states and failure transitions. `decision-tradeoff`: a costly decision with a rejected alternative and what gets worse. `no-new-service` |
| S-2 | `s-2-quality-conflict` | design | `conflict-keeps-isolation`: the performance and isolation conflict is written as scenarios, and the decision keeps per-tenant isolation |
| S-3 | `s-3-unverified-premise` | design | `read-vendor-doc` (tool_used: `Read` on `docs/vendor/job-platform.md`). `respects-run-limit`: every run stays within the platform's 15 minutes and the export still fits in 30. `concurrency-not-assumed`: the undocumented concurrency limit is an unconfirmed premise that blocks adoption, with a way to settle it and what it changes; `grade.py`: `product-unchanged` |
| D-1 | `d-1-csv-export-plan` | delivery | `environment-first`, `call-before-job`, `fixed-csv-stub`, `second-tenant`, `separate-gates`, `parallel-disjoint`, and `owner-plan` (a `baseline` grader in `case.yaml` against `owner-plan.jsonl`, a plan staged by a person) |
| D-2 | `d-2-one-file-bug` | delivery | `single-increment`: no uncertainties listed, one increment |
| D-3 | `d-3-design-issue-in-plan` | delivery | `design-issue-returned`: the contradiction between the two documents on who signs the download URL and for how long goes back to design. `no-design-choice`: the plan does not pick one side. `later-u-to-k`: the later premise U7 becomes a check in the plan. `blocking-u-returned`: the blocking premise U6 goes back to design to settle before the one-run-per-request job is built |
| I-1 | `i-1-tenant-api` | implementation | `new-test-file` (file_exists), `report-test-command` (regex), `other-tenant-test` (a test derived from INV-1, which the request states without an acceptance criterion), `failing-test-first` (a failing run reported before the passing one); `grade.py`: `tests-pass`, `catches-other-tenant` and `catches-missing` (the run's tests fail against a broken `get_export`), `in-scope` |
| I-2 | `i-2-wrong-looking-test` | implementation | `kept-expectation`; `grade.py`: `test-unchanged`, `tests-pass`, `code-fixed` |
| I-4 | `i-4-design-contradiction` | implementation | `design-issue-returned`: the design's premise that `export_id` is unique across tenants, which the code does not hold, goes back to design with evidence and an alternative. `cites-store-line` (regex): `store.py` with a line number; `grade.py`: `contract-kept` |
| V-1 | `v-1-missing-tenant-check` | verification | `verdict-not-pass` (regex: `判定` followed by `FAIL`, `NOT VERIFIED`, or `不合格`), `tenant-gap-located` (the missing tenant comparison, and that the test the implementer names for AC-3 does not cover it), `returns-to-implementation`; `grade.py`: `worktree-unchanged` |
| V-2 | `v-2-clean-change` | verification | `pass-brief` (regex: `判定` followed by `PASS` or `合格`, and the whole reply within 71 lines; a report that keeps every required heading and item takes about 57), `no-blocking-findings`; `grade.py`: `worktree-unchanged` |
| V-3 | `v-3-env-vs-defect` | verification | `verdict-fail` (regex), `defect-vs-environment`: the missing-ID failure is a product defect and the `EXPORT_BUCKET` error, failing the same way at `base`, is the environment. `base-rerun` (tool_used: a `git worktree add`, `git archive`, or `git clone` that brings out `base` without changing the work tree) |

- Every case also has `role-fired`, a `tool_used` grader on `Agent` with the role's name, marked `arm: with-only`; it shows that the with-arm dispatched the role and is left out of the two-arm score.
- Each case's prompt has the tag of its role (`requirements`, `design`, `delivery`, `implementation`, `verification`), for `--tag`.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`). R-2, R-4, S-1, and S-2 keep a case-local file (`meeting-note.md`, `exports-api.md`, `requirements.md`) that `fixture.sh` copies into the fixture; D-3's `fixture.sh` appends a blocking premise U6, a later premise U7, and a contradicting section on the download URL to `export-job.md`.
- `fixtures/audit-console`: an admin console API server with tenants, audit logs, an existing `authorize_tenant_access`, a job platform client, an object storage client, and a report feature that uses both (R-1, R-2, R-3, S-1, S-2).
- `fixtures/audit-console-limits`: what S-3 lays over `audit-console`: requirements for a one-year export of 5 million rows in 30 minutes, and the job platform's limits in `docs/vendor/job-platform.md` (15 minutes per run, concurrency limited but not given), which no other file points to.
- `fixtures/export-design-docs`: three design documents for a CSV export of audit logs built from a console screen, an API server, an asynchronous job, object storage, and per-tenant tables, with two verification tenants and a fixed CSV and signed URL in their contracts (D-1, D-3).
- `fixtures/export-api-tenant-ids`: an `export-api` whose store counts `export_id` per tenant, with an approved design that assumes ids unique across tenants (I-4).
- `fixtures/export-api-v3`: a `get_export` that returns `None` for a missing ID, and a settings test that needs `EXPORT_BUCKET`, which V-3's `fixture.sh` commits at `base` (V-3).
- `fixtures/slug`: a one-file library whose `slugify` drops digits (D-2).
- `fixtures/export-api`: export functions without `get_export` (I-1, R-4, and the `base` commit of V-1, V-2, and V-3). `fixtures/export-api-v1` adds a `get_export` without the tenant comparison and a test named `test_other_tenant_is_denied` that passes another tenant's `tenant_id`, so it looks like AC-3 coverage while only the authorization check runs; `fixtures/export-api-v2` adds the correct one, with tests for the caller's own export, a missing ID, another tenant's export, and, on a store that fails when read, another tenant's ID and a member. Their `fixture.sh` commits `export-api`, tags it `base`, and commits the v1 or v2 copy on top.
- `fixtures/period-filter`: a period filter whose code and docstring include the end, while `docs/spec.md` and the failing test exclude it (I-2).
- `canary.patch`: removes every `## ` section except `## 出典` from four agents, keeping the frontmatter and the role paragraph; `system-designer` already has only its frontmatter and role paragraph, so the canary leaves it as it is; apply it with `patch -p1 -d <plugin copy>/agents`. Each belief's action is restated in the steps, the report items, and the completion gates, so a canary that removes only `## 信条` keeps those rules.
- `evals.json`, `grade.py`: the script assertions above, run by `scripts/grade-kept`. `evals.json` lists every case so `grade-kept` finds a fixture for each; `grade.py` grades the six cases that have assertions. `grade-kept` lays out runs by fixture name, so run it on a result file whose cases have distinct fixtures (R-4 shares `export-api` with I-1).

## Settings for This Suite

- Run with `--eval-dir evals/dev-roles/plugin-eval --scaffold --allow-tools Bash Write Edit`, and keep `Agent` callable (no `--disallow-tools Agent`).
- `grade.py` runs each kept workspace's tests (`python3 -m unittest`) in a temporary copy on your machine, outside the run's sandbox, so read a run's diff before grading it when the run did something unexpected.
- The fixtures' tests need Python 3.9 or later on the `PATH` the runs inherit. The run's Bash sandbox cannot read your home directory, so a `python3` installed under it may fail inside a run; the first smoke run in "Running" checks this.

## Running

1. Build the two plugin copies from the checkout to evaluate, in a `DIR` outside the repository whose path has no `eval`, `test`, or `scratchpad`:
   `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit | tar -x -C DIR/with`, then `cp -R DIR/with DIR/canary` and `patch -p1 -d DIR/canary/.config/claude/skills/karrybit/agents -i <checkout>/dot_config/claude/skills/karrybit/evals/dev-roles/canary.patch`.
   Completion: `rg -c '^## ' DIR/canary/.config/claude/skills/karrybit/agents` prints a count of 1 (`## 出典`) for each of the four agents other than `system-designer`, which has no `## ` section.
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

Measured with `--model claude-sonnet-5-5` and `--judge-model claude-opus-5-5`, three runs per arm; cases marked ×2 ran twice. Each cell is the passes summed over the case's graders and runs, leaving out `role-fired` and `grade.py`.

- "branch" is the with-arm on the role definitions and `karrybit:dev-handoff` at the commit in parentheses; a cell with several commits lists one count per commit.
- "798ceb2" is the with-arm on the definitions at 798ceb2, which the branch's first commit builds on.
- baseline and canary are as in "Arms"; the canary ran on the 798ceb2 definitions.
- "earlier" marks a cell from runs made before the branch, whose commit was not recorded. Every other 798ceb2, baseline, and five-run cell ran on the same day as the branch cells.
- A dash is an arm that did not run. No cell ran the definitions at 02cca0e or later.

| Case | branch | 798ceb2 | baseline | canary | Graders that separate |
| --- | --- | --- | --- | --- | --- |
| R-1 | 9/12 (438a659) | 16/24 ×2 earlier | 10/24 ×2 earlier | 12/24 ×2 earlier | `questions-scope` 3, 6, 0, 0; the earlier cells used an earlier `no-implementation-in-ac`, which the branch fails every run |
| R-2 | 3/3 (438a659) | 3/3 earlier | 3/3 earlier | 3/3 earlier | none: the prompt points at `docs/`, which holds only the note with the answer |
| R-3 | 9/9 (438a659) | 9/9 | 8/9 | - | `no-means-in-ac` 3, 3, 2 |
| R-4 | 6/6 (438a659) | 5/6 | 5/6 | - | none over five runs: `keeps-public-contract` 5/5 (438a659) and 5/5, `no-internal-names-in-ac` 4/5 (438a659) and 5/5 |
| S-1 | 15/15 (438a659) | 30/30 ×2 earlier | 12/15 earlier | 30/30 ×2 earlier | `decision-tradeoff` 3, 6, 1, 6; `system-designer` keeps only its role paragraph, so its canary is the same file |
| S-2 | 3/3 (438a659) | 3/3 earlier | 3/3 earlier | 3/3 earlier | none: R-3 states the prefix isolation outright |
| S-3 | 9/9 (438a659) | 9/9 | 9/9 | - | none: every arm reads `docs/vendor/job-platform.md`, splits the export, and holds the concurrency limit as a blocking premise; `product-unchanged` passes every run |
| D-1 | 18/21 (6ac7c2b), 12/21 (005cd46), 15/21 (438a659) | 19/21 | 11/21 earlier | 12/21 earlier | `fixed-csv-stub` 2, 0, 0 against 2; `owner-plan` 2, 0, 1 against 3; `call-before-job` 2, 0, 2 against 2. 6ac7c2b has the 798ceb2 delivery-strategist with the branch's `karrybit:dev-handoff`, so the dev-handoff change does not account for the drop. At 438a659 and 005cd46, delivery-strategist placed increment boundaries only where the checked `K-n`, the visible result, or the rollback unit changed, and its plans built the real job before the API server first called it |
| D-2 | 3/3 (005cd46), 1/3 (438a659) | 4/6 ×2 earlier | 3/6 ×2 earlier | 0/6 ×2 earlier | none over five runs: `single-increment` 5/5 (438a659) and 5/5 |
| D-3 | 8/9 (438a659) | 8/9 | 8/9 | - | none: `no-design-choice` fails one run in every arm |
| I-1 | 12/12 (438a659) | 24/24 ×2 earlier | 18/24 ×2 earlier | 21/24 ×2 earlier | `failing-test-first` 3, 6, 0, 3; `grade.py` passes every run |
| I-2 | 2/3 (438a659) | 3/3 earlier | 0/3 earlier | 3/3 earlier | none over five runs: `kept-expectation` 4/5 (438a659) and 4/5; a failing run reads the docstring as the contract and misses `docs/spec.md` |
| I-4 | 6/6 (438a659) | 6/6 | 6/6 | - | none: every arm returns the per-tenant id to design with `store.py` lines; `contract-kept` passes every run |
| V-1 | 9/9 (438a659) | 17/18 ×2 earlier | 16/18 ×2 earlier | 17/18 ×2 earlier | none: the baseline also sees that `test_other_tenant_is_denied` misses AC-3 |
| V-2 | 3/6 (68a2bba) | 3/6 | - | - | none: `no-blocking-findings` 3/3 in both; `pass-brief` fails every run of every arm, since no reply fits a clean PASS in 71 lines (73–100) |
| V-3 | 8/9 (438a659) | 6/9 | 6/9 | - | `base-rerun` 2, 0, 0 |

- Inside a run, `/usr/bin/git` is a shim that fails in the run's sandbox, while `/opt/homebrew/bin/git` by its absolute path works; agents that need `git diff base...HEAD` either find it or read the files instead, and no run ended on an error.
- Judge calls were 85–90% of a run's cost on long outputs: a D-1 run cost 3–5 USD, an I-1 run about 0.25 USD, and the other cases 0.25–1.2 USD.
