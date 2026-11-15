# karrybit:crit evals

Behavior cases for comparing versions of the `crit` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

The cases grant no `Bash`, so a run cannot start crit or open a browser; each case grades the answer.

## Files

- `plugin-eval/pr-number`: the user gives only a PR number.
  - `asks-url`: the answer asks for the PR's URL instead of guessing a repository.
- `plugin-eval/branch`: the user gives a branch that is not a PR and its worktree, and asks for the commands.
  - `worktree-command`: `cd /work/retry && crit -p <port>`.
  - `no-range`: no `--range`, which would key the session to a SHA.
  - `port-from-target`: the port comes from `echo '/work/retry feature/retry' | cksum`.

## Settings for This Suite

- Cases grant no gated tool and have no scaffold: run them without `--scaffold` and `--allow-tools`.
- `crit` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/crit <ref> DIR/kit`.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`): every grader passes 3/3. The graders guard against regressions; no other configuration has been measured against them.
