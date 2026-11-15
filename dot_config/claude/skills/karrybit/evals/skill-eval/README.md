# karrybit:skill-eval evals

Behavior cases for comparing versions of the `skill-eval` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill. The skill sets `disable-model-invocation`, so each prompt invokes it as `/kit:skill-eval`, the wrapper's plugin name.

## Files

- `plugin-eval/version-commands`: the user asks for the commands that compare a skill at `abc1234` with `HEAD`, without running them.
  - `wrap-both`: a `skill-wrap` per ref.
  - `ablation-none-each`: at least two `claude plugin eval` lines with `--ablation none`.
  - `cost-ceiling-each`: no `claude plugin eval` line without `--max-cost-usd`.
  - `dir-outside`: wrapper and result paths are outside the repository and avoid `eval`, `test`, and `scratchpad`.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- `skill-eval` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/skill-eval <ref> DIR/kit`.
