# karo:record evals

Behavior cases for the karo plugin's `record` skill: the request karo writes when it hands a research or meeting-note task to the `karrybit:researcher` subagent (`調べ物を頼む`), and a note karo updates itself by the rules in the skill's `frontmatter.md`. Run them with the `karrybit:skill-eval` skill against a karo copy that holds the karrybit plugin, built and enabled as in `evals/delegate/README.md`.

The cases grant no `Bash` and remove `Agent`, so a run shows the request and the commands instead of sending or running them; the graders read the answer and the edited file.

## Files

- `plugin-eval/research-request`: the owner asks for a meeting note of the 2026-11-17 weekly sync from minutes in Google Drive.
  - `record-fired`: the run loads the `record` skill.
  - `names-researcher`: the answer names `karrybit:researcher`.
  - `subagent-not-herdr`: the answer names neither `agent-ctl` nor `karo:delegate`, since the researcher runs as a subagent, not as a Herdr agent.
  - `meeting-path`, `check-command`, `sources-rule`: the request has the note's path under `source/meeting/2026-11-17-`, `karo-check --only`, and the `情報源` section of `AGENTS.md`.
  - `rules-file`, `meeting-type`: the request names the rules file `record/frontmatter.md` and the note's type `Meeting Notes`, which the researcher needs to apply the rules without a karo skill.
  - `division` (llm): the request tells the agent not to commit or run `bd`, and karo commits the note.
- `plugin-eval/finish-draft`: the owner says a draft playbook is final. The rules file says to delete `status: draft`; `stable` is a valid status that the rules do not use.
  - `record-fired`, `rules-read`: the run loads the `record` skill and reads `record/frontmatter.md`.
  - `draft-removed`: the playbook has no `status:` line.
  - `rest-kept`: the rest of the frontmatter and the first heading are unchanged.
  - `commit-shown`: the answer shows the commit script with a subject, a body, and the playbook's path.
- `fixtures/vault`: a project note and its draft playbook.

## Settings for This Suite

- Run with `--eval-dir evals/record/plugin-eval --scaffold --allow-tools Edit --ablation none --disallow-tools Agent`. `research-request` lists no `Edit` and has no scaffold, so the flags leave it as it is.

## What the Suite Separates

Measured on the karo copy (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`):

- In `research-request`, every grader passes 3/3; each is a regression guard for what the request carries.
- `subagent-not-herdr` failed the one run of a `record` whose section said "the agent", which in karo means a Herdr agent: that run started the researcher through `karo:delegate`.
