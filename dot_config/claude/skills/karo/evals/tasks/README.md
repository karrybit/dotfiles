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
- `plugin-eval/bv-no-claim`: the owner asks to follow bv's top pick, whose output carries a claim command without `--actor` (`actions.claim`).
  - `show-before-change`: the answer does not run bv's claim command as given and reads the task with `bd show` before changing it.
- `plugin-eval/report-not-closed`: an agent reports its work done.
  - `report-comment`: the answer writes a `報告:` comment with `bd comment`.
  - `not-closed`: the answer does not close the task now (closing after landing may be named as a later step).
- `plugin-eval/pending-vs-decided`: the owner asks whether a question is decided while its decision bead is open.
  - `pending-not-decided`: the answer calls it undecided and the recommended option a recommendation.
- `plugin-eval/bv-unavailable`: bv exits 0 with `source_authority.state` `partial` and `claim_safe` false, after reading a Beads export with no valid row, and reports empty bottlenecks as `computed`.
  - `no-guessed-analysis`: the answer reports that the analysis is unavailable and names no bottleneck.
- Every case has `skill-fired`: the run loads the `tasks` skill.

## Settings for This Suite

- Run with `--eval-dir evals/tasks/plugin-eval --ablation none`, without `--scaffold` and `--allow-tools`, since the cases grant no gated tool and have no scaffold.
- Run against the whole karo plugin with `--ablation none`, since the cases depend on the karo session the skill describes rather than on a comparison with no plugin.
- The karo manifest sets `defaultEnabled: false`, and an eval run enables nothing, so a run against the plugin as deployed loads no karo skill: run the suite against a copy whose `.claude-plugin/plugin.json` sets `defaultEnabled` to true.

## What the Suite Separates

Measured on the karo plugin with this suite (`--ablation none`, `--runs 2`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), once with the plugin enabled and once on a run that loaded no karo skill:

- With the plugin, every grader but `skill-fired` passes 2/2; `skill-fired` passes 1/2 to 2/2 in `bv-no-claim`, where the pasted output lets the run answer without loading the skill.
- Without the plugin, `search-before-create`, `bd-update`, `uses-bv`, `show-before-change`, and `report-comment` pass 0/2, so they separate the skill; `no-bv`, `pending-not-decided`, and `no-guessed-analysis` pass 2/2 either way and guard against regressions only.
