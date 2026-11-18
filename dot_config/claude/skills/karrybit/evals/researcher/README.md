# karrybit:researcher evals

Behavior cases for the `researcher` agent in `exact_agents/`, which preloads `karrybit:research`. Run them with the `karrybit:skill-eval` skill's suite command; this README gives the target and flags that differ from a skill suite.

Each case asks the main session to hand the task to `karrybit:researcher` and to return the agent's report unchanged, or to do the task itself when the agent is unavailable. The cases measure that the agent takes its save location, note rules, and check from the request and adds none of its own, keeps the `karrybit:research` source rules, and changes, commits, and records nothing beyond the note.

## Arms

| Arm | Plugin | Run |
| --- | --- | --- |
| with | `DIR/.config/claude/skills/karrybit`, the plugin as `chezmoi archive` renders it from one checkout | the with-arm of a two-arm run |
| baseline | none | the without-arm of the same run; the `Agent` call fails with `Agent type 'karrybit:researcher' not found`, and the session does the task itself |

The copy holds the whole `karrybit` plugin, so the agent's `skills:` resolves `karrybit:research`; `scripts/skill-wrap` is not used. No case loads `imozuru`, so every run shows the agent working where `imozuru` is not installed.

## Cases

- `plugin-eval/other-repo`: a repository that is not a record repository (`../research/fixtures/fetcher`); the request asks for a note at `notes/retry.md` and names no note rules, check, or extra skill.
  - `reading-table`, `unreadable-row`, `line-citation`, `facts`: as in `evals/research`, the `karrybit:research` table and source rules on the same fixture.
  - `no-frontmatter`: the note does not start with `---`.
  - `no-record-paths`: no new file under `investigation/` or `source/meeting/`.
  - `report-items`: the reply has `karrybit:research`'s five report items and the files to commit.
- `plugin-eval/record-rules`: a record repository (`fixtures/records`); the request has the six items a record repository passes: the note's path, a rule file for sources, a rule file for notes, a check command with its passing output, an extra skill for field surveys, and who commits and keeps the records.
  - `minutes-source`: the frontmatter's `sources` names the minutes.
  - `ran-check` (regex on the trace): a Bash call runs `bin/check-note`.
  - `report-check-line`: the reply has `check-note: 0 problem(s)`.
  - `reading-table`, `facts` (both decisions and both action items, and the undecided topic not written as decided), `report-items` (the five items, the check's last line, and the files to commit).
- Both cases also have `role-fired`, a `tool_used` grader on `Agent` with `researcher`, marked `arm: with-only`, and `no-commit` and `no-bd`, regex graders on the trace that find no Bash command running `git commit` or `bd`. The trace holds the subagent's tool calls, so these graders see what the agent ran.
- `grade.py` (run by `scripts/grade-kept`): `note-only`, the note is the only path that differs from the fixture; `check-passes`, `bin/check-note` exits 0 on the note (`record-rules`).

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`).
- `fixtures/records`: minutes of one meeting with two decisions, two action items, and one topic left undecided; `rule/note-rules.md` and `rule/sources.md`; and `bin/check-note`, which prints one line per problem and `check-note: N problem(s)`, exits 1 on a problem and 2 on a usage error.
- `evals.json`, `grade.py`: the script assertions above. `other-repo` uses the `research` suite's fixture, named by its path relative to `evals.json`.

## Settings for This Suite

- Run with `--eval-dir evals/researcher/plugin-eval --scaffold --allow-tools Bash Write Edit`, and keep `Agent` callable (no `--disallow-tools Agent`).
- Build the copy with `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit | tar -x -C DIR`. chezmoi gives `bin/check-note` its executable bit from the `executable_` prefix of its source name, so run the suite against the archive copy, not the source tree.

## What the Suite Separates

Measured at the commit that adds this suite, against an archive copy (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), one measurement:

- With the agent, every grader and both `grade.py` assertions pass 3/3 in both cases, and the agent, not the main session, writes the note in every run.
- Without the plugin, `reading-table`, `unreadable-row` (`other-repo`), and `report-items` pass 0/3: the session writes the note without the `karrybit:research` table and report items. The other graders, including `no-frontmatter`, `no-record-paths`, `no-commit`, `no-bd`, `ran-check`, and `grade.py`'s, pass 3/3 either way and guard against regressions only.
