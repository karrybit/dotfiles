# karrybit:skill-eval evals

Behavior cases for comparing versions of the `skill-eval` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill. The skill sets `disable-model-invocation`, so each prompt invokes it as `/kit:skill-eval`, the wrapper's plugin name.

## Files

- `plugin-eval/version-commands`: the user asks for the commands that compare a skill at `abc1234` with `HEAD`, without running them.
  - `wrap-both`: a `skill-wrap` per ref, with any form of the skill directory.
  - `ablation-none-each`: at least two `claude plugin eval` lines with `--ablation none`.
  - `cost-ceiling-each`: no `claude plugin eval` line without `--max-cost-usd`.
  - `dir-outside`: wrapper and result paths are outside the repository and avoid `eval`, `test`, and `scratchpad`.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- `skill-eval` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/skill-eval <ref> DIR/kit`.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`): every grader passes 3/3. The graders guard against regressions; no other configuration has been measured against them.

`scripts/skill-wrap` is measured through `install-agent-extension`'s suite instead: its `vet-output-seen` grader separates wrappers whose scripts keep their chezmoi source names.
