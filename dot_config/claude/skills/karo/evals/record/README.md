# karo:record evals

Behavior cases for the `調べ物を頼む` section of the karo plugin's `record` skill: the request karo writes when it hands a research or meeting-note task to the `karrybit:researcher` subagent. Run them with the `karrybit:skill-eval` skill against a karo copy that holds the karrybit plugin, built and enabled as in `evals/delegate/README.md`.

The case grants no `Bash` and removes `Agent`, so the run shows the request instead of sending it; the graders read the request in the answer.

## Files

- `plugin-eval/research-request`: the owner asks for a meeting note of the 2026-11-17 weekly sync from minutes in Google Drive.
  - `record-fired`: the run loads the `record` skill.
  - `names-researcher`: the answer names `karrybit:researcher`.
  - `subagent-not-herdr`: the answer names neither `agent-ctl` nor `karo:delegate`, since the researcher runs as a subagent, not as a Herdr agent.
  - `meeting-path`, `frontmatter-skill`, `check-command`, `sources-rule`: the request has the note's path under `source/meeting/2026-11-17-`, `karo:frontmatter`, `karo-check --only`, and the `情報源` section of `AGENTS.md`.
  - `division` (llm): the request tells the agent not to commit or run `bd`, and karo commits the note.

## Settings for This Suite

- Run with `--eval-dir evals/record/plugin-eval --ablation none --disallow-tools Agent`, without `--scaffold` and `--allow-tools`.

## What the Suite Separates

Measured on the karo copy (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`):

- Every grader passes 3/3; each is a regression guard for what the request carries.
- `subagent-not-herdr` failed the one run of a `record` whose section said "the agent", which in karo means a Herdr agent: that run started the researcher through `karo:delegate`.
