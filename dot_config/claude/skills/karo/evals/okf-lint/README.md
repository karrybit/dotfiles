# okf-lint evals

Behavior cases for the karo plugin's `scripts/okf-lint` as an agent uses it: whether its output lets an agent fix the notes, rerun the check, and report the result it got. The script's own checks are tested by `scripts/okf-lint-test`; no skill teaches the script, so the request names the command. Run them with the `karrybit:skill-eval` skill against a karo copy.

## Files

- `plugin-eval/fix-notes`: the user asks to check the folder's notes with `bin/okf-lint schema.yaml .` and fix what fails. The scaffold copies the plugin's `scripts/okf-lint` to `bin/okf-lint`. `notes/retry.md` has an empty `description` and a `derived_from` entry naming a file that does not exist.
  - `lint-rerun`: `okf-lint` runs with `schema.yaml` at least twice (the check and the rerun after the fix).
  - `description-filled`: `notes/retry.md` has a non-empty `description`.
  - `derived-fixed`: `notes/retry.md` no longer names the missing `notes/cache-design.md`.
  - `schema-unchanged`: `schema.yaml` is unchanged, so the fix is in the notes.
  - `zero-reported`: the reply reports zero problems.
  - `cause-reported`: the reply reports zero problems after a run, or names the tool that could not run and claims no pass.
- `fixtures/kb`: the schema and two notes.

## Settings for This Suite

- Run with `--eval-dir evals/okf-lint/plugin-eval --scaffold --allow-tools Bash Edit Write --ablation none` against a karo copy built as in `evals/delegate/README.md`, since the scaffold reads `scripts/okf-lint` from the plugin.
- `okf-lint` needs `bash`, `yq` (v4), `fd`, and `rg` on the run's `PATH`.

## What the Suite Separates

- `lint-rerun` and `zero-reported` need `yq`, `fd`, and `rg` to run inside the evaluated session. Where they cannot (a sandbox that blocks a tool installed under the home directory, where `okf-lint` stops with `okf-lint: cannot run yq`), these graders fail in every configuration, and `cause-reported` checks that the run names the tool instead.
- `description-filled` and `derived-fixed` pass where the run fixes the notes by reading them, so where `yq` cannot run a pass means a fix made without a passing `okf-lint` run.
- `zero-reported` also matches a reply that only promises to reach `0 problem(s)` once okf-lint can run.
- Measured at 7e03076 on the karo copy where `yq` cannot run (`--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`), one measurement: `cause-reported` and `schema-unchanged` pass 3/3; `description-filled`, `derived-fixed`, and `zero-reported` pass 0/3, since every run stopped at `okf-lint: cannot run yq`, named the tool, and left the notes unfixed; `lint-rerun` passes 1/3, from a run that called the script again after adding the tools' folder to `PATH`.
- Where `yq`, `fd`, and `rg` can run, the fix graders have not been measured.
