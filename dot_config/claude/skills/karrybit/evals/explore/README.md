# karrybit:explore evals

Behavior cases for comparing versions of the `explore` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill. The skill sets `disable-model-invocation`, so each prompt invokes it as `/kit:explore`, the wrapper's plugin name.

## Files

- `plugin-eval/no-parts`: the user asks for research and an explanation of a topic without passing the three components the skill requires.
  - `asks-parts`: the reply asks for the components instead of starting.
  - `no-agent`, `no-write`: no subagent and no `Write` call before the components arrive. The case grants `Bash`, so `no-write` does not show that no file was written: a write through `Bash` passes it.

## Settings for This Suite

- Cases grant `Agent`, `Bash`, `Write`, and `Edit`, so that `no-agent` and `no-write` can fail, and have no scaffold: run them with `--allow-tools Bash Write Edit`.
- `explore` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/exact_explain/explore <ref> DIR/kit`.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`): every grader passes 3/3. The graders guard against regressions; no other configuration has been measured against them.
