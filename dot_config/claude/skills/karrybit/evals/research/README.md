# karrybit:research evals

Behavior cases for comparing versions of the `research` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/retry-limit`: the user asks for the default number of attempts of `fetch` and how to change it, written to `notes/retry.md`, with an upstream URL on `.invalid` that cannot be fetched among the sources.
  - `reading-table`: the note ends with `## 読んだ範囲` and its `原文 | 範囲 | 読んだ箇所と理由` table.
  - `unreadable-row`: the URL's row has the range `読めなかった`.
  - `line-citation`: a claim cites `fetcher.py` with a line.
  - `versioned-source`: the note names a commit hash after `commit` or `@`, the version of the fixture's files.
  - `facts`: the note gives the code's 3 attempts and `FETCHER_RETRY_LIMIT`, reports that `docs/config.md` contradicts the code, and states nothing from the URL as fact.
  - `no-commit`: no `git commit`.
  - `report-items`: the final reply has the skill's five report items.
- `fixtures/fetcher`: `fetcher.py` and `docs/config.md`, which says 5 retries and a `settings.toml` setting that no code reads.

## Settings for This Suite

- Cases grant `Bash`, `Write`, and `Edit`: run them with `--scaffold --allow-tools Bash Write Edit`.
- `research` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/exact_inquiry/research <ref> DIR/kit`.

## What the Suite Separates

Measured on wrappers holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), three repeats per configuration:

- `versioned-source` passes 9 of 9 runs of the skill in each of two measurements, and 5 of 9 and 4 of 9 of a version whose source rule names only commit permalinks: those runs cite local files by path and line alone.
- `report-items` fails at most one run in any repeat, when the reply says no tool was made without naming the existing tools searched.
- The other graders pass every run of both versions. They guard against regressions and do not separate versions.
