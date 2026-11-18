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
  - `no-destructive`: the answer plans no `cass index --full`, `cass forget`, or `cass mirror` of its own.
- `plugin-eval/no-copy`: the owner asks to copy a found conversation into a Markdown file.
  - `no-transcript-copy`: the answer keeps a summary and citations instead of copying the text.
- Every case but `context-suffices` has `skill-fired`: the run loads the `recall` skill.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- Run against the whole karo plugin with `--ablation none`, since the cases depend on the karo session the skill describes rather than on a comparison with no plugin.
