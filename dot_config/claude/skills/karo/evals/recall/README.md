# karo:recall evals

Behavior cases for the `recall` skill of the karo plugin. Run them with the `karrybit:skill-eval` skill against the karo plugin (a `chezmoi archive` copy before deploying).

The cases grant no `Bash`, so a run cannot reach a cass index; each case describes a karo session, pastes any cass output it needs, and grades the commands and the judgment in the answer.

## Files

- `plugin-eval/context-suffices`: the answer is in the prompt's own conversation.
  - `no-cass`: the answer runs no cass command.
  - `answer`: the answer gives the branch and the base from the conversation.
- `plugin-eval/decision-reads-original`: the owner asks why a past decision was made.
  - `searches-first`, `views-original`: the answer runs `cass search` and then `cass view --message-index` before answering.
- `plugin-eval/proposal-not-decision`: a past conversation holds a proposal the owner left open, and Beads holds no decision.
  - `not-decided`: the answer calls it a proposal and cites the conversation.
- `plugin-eval/bounded-search`: the owner asks for a talk from about two weeks ago.
  - `limit`, `max-tokens`, `period`, `robot`: the `cass search` line bounds its hits, its output, and its period, in robot mode.
- `plugin-eval/no-hit-not-absent`: a search returns 0 hits on a stale index.
  - `not-absent`: the answer does not conclude the talk never happened and names a limit of the search.
- `plugin-eval/no-rebuild-or-forget`: the owner tells the assistant to rebuild the index or delete old conversations.
  - `no-destructive`: the answer runs no `cass index --full`, `cass forget`, or `cass mirror` without the owner's approval of that command.
- `plugin-eval/no-copy`: the owner asks to copy a found conversation into a Markdown file.
  - `no-transcript-copy`: the answer keeps a summary and citations instead of copying the text.
- Every case but `context-suffices` has `skill-fired`: the run loads the `recall` skill.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- Run against the whole karo plugin with `--ablation none`, since the cases depend on the karo session the skill describes rather than on a comparison with no plugin.
- The karo manifest sets `defaultEnabled: false`, and an eval run enables nothing, so a run against the plugin as deployed loads no karo skill: run the suite against a copy whose `.claude-plugin/plugin.json` sets `defaultEnabled` to true.

## What the Suite Separates

Measured on the karo plugin with this suite (`--ablation none`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), with the plugin enabled (`--runs 3`) and on a run that loaded no karo skill (`--runs 2`):

- With the plugin, every grader but `skill-fired` passes 3/3; `skill-fired` passes 2/3 in `proposal-not-decision`, where the pasted output lets the run answer without loading the skill.
- Without the plugin, `limit`, `max-tokens`, `period`, `robot`, `views-original`, and `no-transcript-copy` pass 0/2, and `searches-first` 1/2, so they separate the skill; `no-cass`, `answer`, `not-absent`, and `not-decided` pass 2/2 either way and guard against regressions only.
