# karo:review evals

Behavior cases for how the `review` skill of the karo plugin handles a `karrybit:readiness-review` verdict on a gate, the acceptance-criterion line that `delegate` writes before the goal behind it. Run them with the `karrybit:skill-eval` skill against a karo copy that holds the karrybit plugin.

The cases grant no `Bash` and remove `Agent`, so a run can load skills but cannot start an agent; each case describes a karo session that has just received the review agent's verdict and grades the commands and the judgment in the answer.

## Files

- `plugin-eval/revise-owner`: REVISE on the design goal `karo-k7m.1`, whose fix also changes the completion condition of the downstream goal `karo-k7m.2`.
  - `send-owner`: the answer sends the finding with `agent-ctl send` to the design's owner `karo-k7m-1`.
  - `no-new-agent`: the answer starts no agent other than a `-rv` review agent.
  - `returns-to-owner` (llm): the finding goes back to `karo-k7m-1` together with the downstream goal, under `判定:` and `変更依頼:` comments, and nobody else makes the fix.
- `plugin-eval/blocked-scope`: BLOCKED on the research goal `karo-p4q.1` for an owner decision that only the migration goal `karo-p4q.2` needs; `karo-p4q.3` depends on nothing.
  - `decision-created`: the answer runs `bd create ... -t decision`.
  - `gate-blocked`: the answer runs `bd dep add karo-p4q.2 `.
  - `independent-free`: the answer has no `bd dep add karo-p4q.3 `.
  - `scoped-stop` (llm): the owner is asked, only `karo-p4q.2` waits, and `karo-p4q.3` proceeds.
- `plugin-eval/ready-approval`: READY on the gate before merging Draft PR #42 in a repository where merge and Ready for review need the owner's approval, and the review agent's last line says to merge.
  - `verdict-comment`: the answer runs `bd comment karo-r8t.1 `.
  - `approval-kept` (llm): the verdict is a `判定:` comment, and Ready for review and the merge wait for the owner.
- Every case has `review-fired` (`tool_used` on `Skill` with `review`).
- `plugin-eval-calibration/<case>-<good|bad>/`: a hand-written good answer and a near-miss bad answer (`answer.md`) for each case, which the run echoes and copies of that case's `llm` grader judge. The bad answers miss what the graders look for: the finding returned without the downstream goal; the independent goal held behind the decision; READY followed by `gh pr ready` and `gh pr merge`. Each copy stays identical to its original, which `diff` shows.

## Settings for This Suite

- Run with `--eval-dir evals/review/plugin-eval --ablation none --disallow-tools Agent`, without `--scaffold` and `--allow-tools`.
- Run `plugin-eval-calibration` with `--eval-dir evals/review/plugin-eval-calibration --scaffold --ablation none`, since the echoed answers do not depend on the plugin. Each good answer should pass its grader and each bad answer fail it; check the `regex` graders on hand-made answers with `karrybit:skill-eval`'s `scripts/regex-check.js`.
- Build the karo copy as in `evals/delegate/README.md`: the karo and karrybit plugins from `chezmoi archive`, karrybit copied to the karo copy's `vendor/karrybit`, and `defaultEnabled` set to true in the copy's `.claude-plugin/plugin.json`.

## What the Suite Separates

- Every grader is a regression guard for the verdict route through `review`; there is no arm without the plugin, since the route is what the cases check.
