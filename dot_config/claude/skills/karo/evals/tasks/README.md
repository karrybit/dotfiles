# karo:tasks evals

Behavior cases for the `tasks` skill of the karo plugin. Run them with the `karrybit:skill-eval` skill against the karo plugin (a `chezmoi archive` copy before deploying).

The cases grant no `Bash`, so a run cannot reach a Beads database or bv; each case describes a karo session, pastes any tool output it needs, and grades the commands and the judgment in the answer.

## Files

- `plugin-eval/create-dedup`: the owner asks to record new work as a task.
  - `search-before-create`: the answer searches existing tasks (`bd search` or `--desc-contains`) before `bd create`.
- `plugin-eval/update-no-bv`: the owner asks to raise one task's priority.
  - `bd-update`: the answer changes it with `bd update <ID> -p 1`.
  - `no-bv`: the answer does not run bv for a plain update.
- `plugin-eval/priority-bv`: the owner asks what to do first and which tasks are bottlenecks.
  - `uses-bv`: the answer runs a `bv --robot-triage`, `--robot-insights`, or `--robot-plan` command.
- `plugin-eval/bv-no-claim`: the owner asks to follow bv's top pick, whose output carries a `claim_command`.
  - `show-before-change`: the answer does not run bv's claim command as given and reads the task with `bd show` before changing it.
- `plugin-eval/report-not-closed`: an agent reports its work done.
  - `report-comment`: the answer writes a `報告:` comment with `bd comment`.
  - `not-closed`: the answer does not close the task.
- `plugin-eval/pending-vs-decided`: the owner asks whether a question is decided while its decision bead is open.
  - `pending-not-decided`: the answer calls it undecided and the recommended option a recommendation.
- `plugin-eval/bv-unavailable`: bv exits 0 with `source_authority.state` `unknown` and `claim_safe` false.
  - `no-guessed-analysis`: the answer reports that the analysis is unavailable and names no bottleneck.
- Every case has `skill-fired`: the run loads the `tasks` skill.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- Run against the whole karo plugin with `--ablation none`, since the cases depend on the karo session the skill describes rather than on a comparison with no plugin.
