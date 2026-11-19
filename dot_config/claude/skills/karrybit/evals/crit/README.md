# karrybit:crit evals

Behavior cases for comparing versions of the `crit` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

A run cannot start crit: in a run's sandbox the home folder is unreadable, and crit's binary sits under it. `pr-number` and `branch` grant no `Bash` and grade the answer. `url-only` grants `Bash` and gives the URL a started crit printed, so a run shows what the skill does with it.

## Files

- `plugin-eval/pr-number`: the user gives only a PR number.
  - `asks-url`: the answer asks for the PR's URL instead of guessing a repository.
- `plugin-eval/branch`: the user gives a branch that is not a PR and its worktree, and asks for the commands.
  - `worktree-command`: `cd /work/retry && crit`.
  - `no-range`: no `crit --range`, which would key the session to a SHA.
- `plugin-eval/url-only`: crit already runs and printed its review URL, in a run with no Herdr and no karo plugin.
  - `url-shown`: the answer shows `http://localhost:49809`.
  - `no-pane`: no `Bash` call names `crit-open`, `tb-view`, `terminal-browser`, or `herdr`.

## Settings for This Suite

- No case has a scaffold: run them without `--scaffold`. `url-only` lists `Bash`: run with `--allow-tools Bash`.
- `crit` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/crit <ref> DIR/kit`.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`): every `pr-number` grader passes 3/3. The `branch` case's prompt and graders are not measured. The graders guard against regressions; no other configuration has been measured against them.
