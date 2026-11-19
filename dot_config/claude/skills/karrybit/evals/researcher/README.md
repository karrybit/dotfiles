# karrybit:researcher evals

Behavior cases for the `researcher` agent in `exact_agents/`, which preloads `karrybit:research`. Run them with the `karrybit:skill-eval` skill's suite command; this README gives the target and flags that differ from a skill suite.

The case asks the main session to hand the task to `karrybit:researcher` and to return the agent's report unchanged, or to do the task itself when the agent is unavailable. It measures that the agent adds no save location, note rules, or check of its own, keeps the `karrybit:research` source rules, and changes and commits nothing beyond the note.

## Arms

| Arm | Plugin | Run |
| --- | --- | --- |
| with | `DIR/.config/claude/skills/karrybit`, the plugin as `chezmoi archive` renders it from one checkout | the with-arm of a two-arm run |
| baseline | none | the without-arm of the same run; the `Agent` call fails with `Agent type 'karrybit:researcher' not found`, and the session does the task itself |

The copy holds the whole `karrybit` plugin, so the agent's `skills:` resolves `karrybit:research`; `scripts/skill-wrap` is not used. The case loads no `imozuru`, so every run shows the agent working where `imozuru` is not installed.

## Cases

- `plugin-eval/other-repo`: a repository with no rules for notes (`../research/fixtures/fetcher`); the request asks for a note at `notes/retry.md` and names no note rules, check, or extra skill.
  - `reading-table`, `unreadable-row`, `line-citation`, `facts`: as in `evals/research`, the `karrybit:research` table and source rules on the same fixture.
  - `no-frontmatter`: the note does not start with `---`.
  - `report-items`: the reply has `karrybit:research`'s five report items and the files to commit.
  - `role-fired`: a `tool_used` grader on `Agent` with `researcher`, marked `arm: with-only`.
  - `no-commit`: a regex grader on the trace that finds no Bash command running `git commit`. The trace holds the subagent's tool calls, so it sees what the agent ran.
- `grade.py` (run by `scripts/grade-kept`): `note-only`, the note is the only path that differs from the fixture; `grade-kept` runs outside the sandbox, so `grade.py` runs no script from the workspace.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`).
- `evals.json`, `grade.py`: the script assertion above. `other-repo` uses the `research` suite's fixture, named by its path relative to `evals.json`.

## Settings for This Suite

- Run with `--eval-dir evals/researcher/plugin-eval --scaffold --allow-tools Bash Write Edit`, and keep `Agent` callable (no `--disallow-tools Agent`).
- Build the copy with `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit | tar -x -C DIR`, and run the suite against the archive copy, not the source tree.

## What the Suite Separates

Measured at da33726 against an archive copy (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), one measurement, with the kept runs graded by `grade.py` at 7ca2a7f:

- With the agent, every grader and `note-only` pass 3/3, and the agent, not the main session, writes the note in every run.
- Without the plugin, `reading-table`, `unreadable-row`, and `report-items` pass 0/3: the session writes the note without the `karrybit:research` table and report items. The other graders, including `no-frontmatter`, `no-commit`, and `note-only`, pass 3/3 either way and guard against regressions only.
- At d7e8a5b (`--runs 1`, the same models, `grade.py` not run), every grader passes with the agent, and `reading-table`, `unreadable-row`, and `report-items` fail without the plugin.
