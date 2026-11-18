# karrybit:system-investigation evals

Behavior cases for the `system-investigation` skill, which answers questions about an existing system with evidence and follows pstack's `how` and `why` by reading their `SKILL.md`. Run them with the `karrybit:skill-eval` skill's suite command; this README gives the layout and flags that differ from a skill suite.

## Arms

| Arm | Eval dir | Plugins | Run |
| --- | --- | --- | --- |
| with | `plugin-eval` | the whole `karrybit` plugin as `chezmoi archive` renders it, plus a copy of pstack at `vendor/pstack` inside it | the with-arm of a two-arm run |
| baseline | `plugin-eval` | none | the without-arm of the same run |
| direct | `plugin-eval-direct` | the pstack copy only; each prompt starts with `/pstack:how`, `/pstack:why`, or both | `--ablation none` |

- Each case's `plugins:` lists the plugin and `vendor/pstack` relative to the case directory, since `claude plugin eval` loads only plugins inside the target's directory.
- Inside a run, `claude plugin list --json` prints `[]`, and Glob and directory listings outside the workspace are refused, so the skill cannot find pstack the way it does in a session. `locate.patch` replaces that one line of the copy's `SKILL.md` with `${CLAUDE_PLUGIN_ROOT}/vendor/pstack`; the suite measures everything after pstack is found.

## Cases

All cases share `fixtures/orders`, built by `fixtures/orders/build.sh` into four commits: a base service whose API sends the confirmation mail itself, the move to an outbox with ADR-0002, batched sends to the queue, and a change of the relay interval from 5 to 7 seconds with no reason given. `docs/architecture.md` keeps the base design.

| ID | Case | Passes when |
| --- | --- | --- |
| SI-1 | `si-1-request-path` | `path-traced`: API, order and outbox in one transaction, relay to queue, worker confirms and sends the mail. `cites-lines` (regex): a `.py` file with a line |
| SI-2 | `si-2-components-state` | `states`: the processes, the queue and its dead-letter queue, the tables, and who changes each state. `cites-infra` (regex): `main.tf` |
| SI-3 | `si-3-why-outbox` | `reason`: the lost confirmations of 2026-03-04, with the ADR or commit as source and one consequence. `cites-source` (regex): ADR-0002 |
| SI-4 | `si-4-how-and-why` | `how-and-why`: the batch of up to 50 rows, and the queue API's request limit from the commit message |
| SI-5 | `si-5-doc-contradiction` | `contradiction`: `docs/architecture.md` against the code, answered from the code |
| SI-6 | `si-6-unknown-reason` | `no-invented-reason`: the 7 seconds has no recorded reason; candidates are marked as guesses, with a way to confirm |
| SI-7 | `si-7-simple-question` | `answer` (regex): `切り捨て` or `ROUND_DOWN`. `no-pstack`, `no-agent`: no Read of a pstack file and no subagent |
| SI-8 | `si-8-simple-with-skill` | SI-7's question with the prompt starting `/karrybit:system-investigation`, so the direct-reading row is measured with the skill loaded; the same three graders |

- Every case in `plugin-eval` has `no-edit` and `no-write` (no `Edit` or `Write` call) and `no-research` (no `Skill` call on `research`). SI-1 through SI-7 have `skill-fired` (`tool_used: Skill`, `arm: with-only`); SI-8 loads the skill by its slash command, which makes no `Skill` call.
- `uses-how` and `uses-why` (`tool_used: Read` on `skills/how/SKILL.md` or `skills/why/SKILL.md`, `arm: with-only`) show which pstack procedure the with-arm opened: SI-1, SI-2, and SI-4 `how`, SI-3, SI-4, and SI-6 `why`.
- `plugin-eval-direct` repeats SI-1, SI-3, and SI-4 with the same graders, less the with-only ones.

## Settings for This Suite

- Run with `--scaffold --allow-tools Bash Write Edit`, and keep `Agent` callable, since pstack's `how` and `why` start subagents.
- Inside a run, `git` on the `PATH` may resolve to `/usr/bin/git`, which fails in the run's sandbox, while `/opt/homebrew/bin/git` works; a run that does not find it cannot read commit messages, which SI-3, SI-4, and SI-6 rely on. Read such a run's trace before counting it.

## Running

1. Build the copy in a `DIR` outside the repository whose path has no `eval`, `test`, or `scratchpad`:
   `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit | tar -x -C DIR/with`, then copy the installed pstack (`installPath` in `claude plugin list --json`) to `DIR/with/.config/claude/skills/karrybit/vendor/pstack`, and run `patch -p1 -d DIR/with/.config/claude/skills/karrybit/skills/system-investigation -i <checkout>/dot_config/claude/skills/karrybit/evals/system-investigation/locate.patch`.
   Completion: `rg -c vendor/pstack DIR/with/.config/claude/skills/karrybit/skills/system-investigation/SKILL.md` prints `1`, and `claude plugin validate` passes on the copy.
2. Run `--eval-dir evals/system-investigation/plugin-eval` against `DIR/with/.config/claude/skills/karrybit` with two arms, and `--eval-dir evals/system-investigation/plugin-eval-direct` against the same copy with `--ablation none`.
   Completion: each result JSON has `"partial": false`, every run has `"error": null`, and `costUsd` is recorded.
3. Compare per-grader pass counts and the summed `costUsd` per case across with, baseline, and direct.
   Completion: each grader has a pass count per arm, and each case a cost per arm.

## What the Suite Separates

Measured with `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`, three runs per arm, and pstack 0.15.36. Each cell is a grader's passes; `no-edit` and `no-write` pass every run of every arm and are left out. A column named by a commit is the with-arm on the skill at that commit:

- d208033: the first version.
- bb12130: also routes every why question to `why`, and asks for pstack's procedure in full, subagents included, even on a small repository.
- 4e7599f: leaves subagents to pstack's procedure and drops the size clause.
- 22f72b2: opens the procedure's `SKILL.md` regardless of the repository's size, leaving subagents to the procedure.

"baseline" is the without-arm of d208033's run, and "direct" ran on pstack alone with ba31538's suite. A dash is a grader or case that did not exist or did not run in that arm.

| Case | Grader | d208033 | baseline | bb12130 | 4e7599f | 22f72b2 | direct |
| --- | --- | --- | --- | --- | --- | --- | --- |
| SI-1 | `path-traced` | 3/3 | 3/3 | 3/3 | 3/3 | 3/3 | 3/3 |
| SI-1 | `cites-lines` | 3/3 | 1/3 | 3/3 | 3/3 | 3/3 | 2/3 |
| SI-2 | `states`, `cites-infra` | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 | - |
| SI-3 | `reason`, `cites-source` | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 | 3/3, 3/3 |
| SI-4 | `how-and-why` | 2/3 | 0/3 | 2/3 | 1/3 | 3/3 | 1/3 |
| SI-5 | `contradiction` | 3/3 | 2/3 | 3/3 | 3/3 | 3/3 | - |
| SI-6 | `no-invented-reason` | 3/3 | 3/3 | 3/3 | 2/3 | 3/3 | - |
| SI-7 | `answer`, `no-pstack`, `no-agent` | 3/3 each | 3/3 each | 3/3 each | 3/3 each | 3/3 each | - |
| SI-8 | `answer`, `no-pstack`, `no-agent` | - | - | - | 3/3 each | 3/3 each | - |
| SI-1 to SI-5 | `skill-fired` | 3/3 each | - | 3/3 each | 3/3 each | 3/3 each | - |
| SI-6 | `skill-fired` | 2/3 | - | 3/3 | 3/3 | 3/3 | - |
| SI-7 | `skill-fired` | 0/3 | - | 0/3 | 0/3 | 0/3 | - |
| SI-1, SI-2 | `uses-how` | 3/3 each | - | 3/3 each | 3/3 each | 3/3 each | - |
| SI-4 | `uses-how`, `uses-why` | 3/3, 3/3 | - | 3/3, 3/3 | 2/3, 3/3 | 3/3, 3/3 | - |
| SI-3 | `uses-why` | 3/3 | - | 3/3 | 3/3 | 3/3 | - |
| SI-6 | `uses-why` | 0/3 | - | 3/3 | 0/3 | 3/3 | - |
| SI-1 to SI-8 | `no-research` | - | - | - | 3/3 each | 3/3 each | - |

- Summed `costUsd` over three runs: d208033 against baseline, SI-1 0.61 and 0.34, SI-2 0.62 and 0.43, SI-3 0.48 and 0.24, SI-4 0.53 and 0.26, SI-5 0.52 and 0.31, SI-6 0.47 and 0.35, SI-7 0.18 and 0.13. bb12130: SI-1 2.38, SI-2 2.30, SI-3 0.48, SI-4 0.61, SI-5 1.88, SI-6 0.44, SI-7 0.18. 4e7599f: SI-1 0.57, SI-2 0.60, SI-3 0.52, SI-4 0.53, SI-5 0.56, SI-6 0.50, SI-7 0.19, SI-8 0.22. 22f72b2: SI-1 0.54, SI-2 0.54, SI-3 0.48, SI-4 0.58, SI-5 0.50, SI-6 0.49, SI-7 0.18, SI-8 0.22. direct: SI-1 0.46, SI-3 0.55, SI-4 0.39.
- Only at bb12130 did with-arm runs start a subagent: every run of SI-1, SI-2, and SI-5 started one explainer, which accounts for their cost, with the same answer-quality counts as d208033. No run of SI-3, SI-4, or SI-6 in any column started `why`'s investigators, and no direct run started a subagent.
- d208033 and bb12130 had no `no-research` grader; no `Skill` call on `research` appears in their with-arm traces either.
- Every failing `how-and-why` and `no-invented-reason` run that was read (d208033's one, the baseline's three, direct's two, and 4e7599f's three) could not run `git` (see "Settings for This Suite") and said the commit body was unread, so the SI-4 and SI-6 gaps measure finding a working `git` more than the skill's rules. The failing SI-5 baseline run reports a gap between the ADR and the worker's code and leaves out `docs/architecture.md`.
- SI-7 does not fire the skill; it guards that a one-function question stays cheap. SI-8 measures the same question with the skill loaded.
