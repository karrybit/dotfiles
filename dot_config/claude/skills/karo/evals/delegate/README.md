# karo:delegate evals

Behavior cases for the goal requests that the `delegate` skill of the karo plugin handles in its `goal を渡す` section, calling `karrybit:goal` for the completion conditions. Run them with the `karrybit:skill-eval` skill against a karo copy that holds the karrybit plugin.

The cases grant no `Bash` and remove `Agent`, so a run can load skills but cannot start an agent; each case describes a karo session and grades the commands and the judgment in the answer.

## Files

- `plugin-eval/goal-one`: the owner sends `goal: ...` for one fix in `github.com/acme/csvtool`, done when `bin/parse-test` passes.
  - `claim-before-start`: the answer claims the task with `bd update <ID> --claim --actor` before `agent-ctl start --goal`.
- `plugin-eval/goal-two`: the owner hands two goals, the same fix and making `README.md` easier to read, which has no criterion.
  - `vague-held` (llm): goal 1 is delegated with its own condition, goal 2 is not started, and the owner is asked for its criterion, also when a Markdown lint or CI check might turn up.
- Both cases have `delegate-fired` and `goal-fired` (`tool_used` on `Skill` with `delegate` and `goal`), `goal-flag` (the answer runs `agent-ctl start --goal "`), and `goal-condition` (a condition after `/goal`, `--goal "`, or `完了の条件` names `bin/parse-test` and an attempt limit).

## Settings for This Suite

- Run with `--eval-dir evals/delegate/plugin-eval --ablation none --disallow-tools Agent`, without `--scaffold` and `--allow-tools`.
- Each case loads two plugins through `plugins:` in `prompt.md`: the karo copy and `vendor/karrybit` inside it, since a case can load only plugins under the target. Build the copy with `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit ~/.config/claude/skills/karo | tar -x -C DIR`, then `cp -R DIR/.config/claude/skills/karrybit DIR/.config/claude/skills/karo/vendor/karrybit`.
- The karo manifest sets `defaultEnabled: false`, and an eval run enables nothing: set `defaultEnabled` to true in the copy's `.claude-plugin/plugin.json`.

## What the Suite Separates

Measured on the karo copy (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`):

- Every grader is a regression guard for the goal route through `delegate`; there is no arm without the plugin, since the route is what the cases check.
- With the plugin and `karrybit:goal` at b7c01c7, every grader passes 3/3 in both cases.
- `vague-held` passed 1/3 with the `karrybit:goal` before b7c01c7: two runs planned to take a Markdown lint or CI check found later as goal 2's predicate and start it without asking. This rests on one measurement of three runs.
- The scenarios say that `Skill` works: with a scenario that says only that commands cannot run, one run of three described the `karrybit:goal` call instead of making it and wrote a condition without an attempt limit.
