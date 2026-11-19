# karrybit:researcher evals for a record repository

Behavior cases for the `karrybit:researcher` agent under the request a record repository passes it: the note's path, the rule files, the check, an extra skill, and who commits and keeps the records. Run them with the `karrybit:skill-eval` skill against a karo copy that holds the karrybit plugin, built and enabled as in `evals/delegate/README.md`.

The case asks the main session to hand the task to `karrybit:researcher` and to return the agent's report unchanged, or to do the task itself when the agent is unavailable. It measures that the agent takes its save location, note rules, and check from the request, and changes, commits, and records nothing beyond the note. `karrybit`'s own `evals/researcher` checks the same agent in a repository with no such rules.

## Cases

- `plugin-eval/record-rules`: a record repository (`fixtures/records`); the request has six items: the note's path, a rule file for sources, a rule file for notes, a check command with its passing output, an extra skill for field surveys, and who commits and keeps the records.
  - `minutes-source`: the frontmatter's `sources` names the minutes.
  - `ran-check` (regex on the trace): a Bash call runs `bin/check-note`.
  - `report-check-line`: the reply has `check-note: 0 problem(s)`.
  - `reading-table`, `facts` (both decisions and both action items, and the undecided topic not written as decided), `report-items` (the five items, the check's last line, and the files to commit).
  - `role-fired`: a `tool_used` grader on `Agent` with `researcher`.
  - `no-commit`, `no-bd`: regex graders on the trace that find no Bash command running `git commit` or `bd`. The trace holds the subagent's tool calls, so these graders see what the agent ran.
  - `no-record-paths`: no new file under `investigation/`, and none under `source/meeting/` but the requested note.
- `grade.py` (run by `scripts/grade-kept`): `note-only`, the note is the only path that differs from the fixture; `check-passes`, the fixture's own `bin/check-note` exits 0 on the run's note; `grade-kept` runs outside the sandbox, so `grade.py` runs no script from the workspace.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`).
- `fixtures/records`: minutes of one meeting with two decisions, two action items, and one topic left undecided; `rule/note-rules.md` and `rule/sources.md`; and `bin/check-note`, which prints one line per problem and `check-note: N problem(s)`, exits 1 on a problem and 2 on a usage error.
- `evals.json`, `grade.py`: the script assertions above.

## Settings for This Suite

- Run with `--eval-dir evals/researcher/plugin-eval --scaffold --allow-tools Bash Write Edit --ablation none`, and keep `Agent` callable (no `--disallow-tools Agent`).
- The case loads two plugins through `plugins:` in `prompt.md`, the karo copy and `vendor/karrybit` inside it, so `karrybit:researcher` resolves. chezmoi gives `bin/check-note` its executable bit from the `executable_` prefix of its source name, so run the suite against the archive copy, not the source tree.

## What the Suite Separates

Measured in `karrybit`'s `evals/researcher` at da33726 against an archive copy (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), one measurement, with the kept runs graded by `grade.py` at 7ca2a7f; this case had no `no-record-paths` grader there:

- With the agent, every grader and both `grade.py` assertions pass 3/3, and the agent, not the main session, writes the note in every run.
- Without the plugin, `reading-table` and `report-items` pass 0/3. The other graders and `grade.py`'s pass 3/3 either way and guard against regressions only.

On the karo copy at d7e8a5b (`--ablation none`, `--runs 1`, the same models), every grader passes in the one run, `no-record-paths` included. `no-record-paths` fails on a list of new files that adds a file under `investigation/` or a second file under `source/meeting/` (`scripts/regex-check.js`), and passes on one that holds only the note.
