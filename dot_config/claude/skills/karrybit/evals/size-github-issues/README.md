# karrybit:size-github-issues evals

Behavior cases for comparing versions of the `size-github-issues` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/audit-split`: the user asks for issue titles and boundaries for the five findings in `docs/audit.md`, which was written in issue #12. Each grader is an `llm` rubric over the proposal.
  - `eslint-split`: the ESLint upgrade and the ESLint rule-set review are separate issues.
  - `follow-on-split`: the retry change and its nice-to-have dashboard panel are separate, with the dependency as a note.
  - `no-policy-issue`: the semantic-versioning question is not an issue of its own.
  - `parent-kept`: issue #12 stays open as a tracking issue with a checklist.
  - `confirm-first`: the user confirms the titles and boundaries before any issue is created.
- `fixtures/web-audit`: the audit and a README; no issue template or policy.

## Settings for This Suite

- Cases grant no gated tool: run them with `--scaffold` and without `--allow-tools`.
- `size-github-issues` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/size-github-issues <ref> DIR/kit`.

## What the Suite Separates

Measured on a wrapper holding only this skill, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`): every grader passes 3/3. The graders guard against regressions; no other configuration has been measured against them.
