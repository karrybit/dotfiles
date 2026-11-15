# karrybit:okf-lint evals

Behavior cases for comparing versions of the `okf-lint` skill. Run them with the `karrybit:skill-eval` skill against a wrapper plugin holding one version of this skill.

## Files

- `plugin-eval/fix-notes`: the user asks to check the folder's notes against `schema.yaml` and fix what fails. `notes/retry.md` has an empty `description` and a `derived_from` entry naming a file that does not exist.
  - `lint-rerun`: `okf-lint` runs with `schema.yaml` at least twice (the check and the rerun).
  - `description-filled`: `notes/retry.md` has a non-empty `description`.
  - `schema-unchanged`: `schema.yaml` is unchanged, so the fix is in the notes.
  - `zero-reported`: the reply reports zero problems.
  - `cause-reported`: the reply reports zero problems after a run, or names the tool that could not run and claims no pass.
- `fixtures/kb`: the schema and two notes.

## Settings for This Suite

- Cases grant `Bash`, `Edit`, and `Write`: run them with `--scaffold --allow-tools Bash Edit Write`. `okf-lint` needs `bash`, `yq` (v4), `fd`, and `rg` on the run's `PATH`.
- `okf-lint` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/okf-lint <ref> DIR/kit`.

## What the Suite Separates

- `lint-rerun`, `description-filled`, and `zero-reported` need `yq`, `fd`, and `rg` to run inside the evaluated session. Where they cannot (a sandbox that blocks a tool installed under the home directory), these graders fail in every configuration, and `cause-reported` checks that the run names the tool instead.
