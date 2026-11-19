# karo:herdr-agent evals

Behavior cases for comparing versions of the `herdr-agent` skill of the karo plugin. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

The cases grant no `Bash`, so a run cannot reach a real Herdr server or start an agent; each case asks for the command to run and grades the answer.

## Files

- `plugin-eval/send-working`: the user wants to add an instruction to the agent `fixer`, which is `working`.
  - `script-path`: the answer calls `karo-agent-ctl send` by the name that the settings rules match.
  - `working-not-sent`: the answer waits for `idle` or `done`, or offers `--interrupt` only after asking whether interrupting is acceptable.
- `plugin-eval/send-goal`: the user wants to send a /goal condition to the `idle` agent `fixer`.
  - `goal-flag`: the answer uses `agent-ctl send --goal` by the `~/` form of the path.
  - `no-slash-text`: the answer does not send `/goal` as the text of a plain `agent-ctl send`, which the script refuses.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- `herdr-agent` reads no sibling skill: build the wrapper with `skill-wrap <karo>/exact_skills/herdr-agent <ref> DIR/kit`.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`): every grader passes 3/3. The graders guard against regressions; no other configuration has been measured against them.
