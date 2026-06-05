---
name: cowaxa
description: Create and run empirical evaluations for Codex agent skills using realistic scenarios, structured self-reports, and with-skill versus without-skill baseline comparisons. Use when measuring whether a skill improves Codex behavior, authoring skill-local eval suites, comparing prompt revisions, or auditing skill structure. Do not use for ordinary unit tests or application benchmarks.
---

# Cowaxa

Evaluate agent skills with `cowaxa`, a Codex-native CLI inspired by
[@mizchi/waxa](https://github.com/mizchi/skills/tree/main/tools/waxa) and its
empirical skill-evaluation workflow.

## Start

Verify the CLI and Codex executor:

```sh
command -v cowaxa
cowaxa doctor --json
```

The CLI uses `codex exec --ephemeral --sandbox read-only` and writes evaluation artifacts under `<skill>/evals/results/`.

## Create An Eval

Scaffold a typical and edge scenario:

```sh
cowaxa init <skill-directory>
```

Edit `<skill-directory>/evals/tasks/*.yaml` with realistic user prompts and observable expectations. Keep at least one typical scenario and one known failure mode.

Task expectations support:

- `output_contains`
- `output_not_contains`
- `regex_match`
- `require_self_report`
- `require_phases_ok`
- `max_unclear`
- `max_retries`

## Run

Run the skill:

```sh
cowaxa eval <skill-directory>/evals/eval.yaml
```

Measure whether the skill adds value:

```sh
cowaxa eval <skill-directory>/evals/eval.yaml --baseline
```

Use `--task <id>` for a focused scenario and `--trials 2` or more to reduce sensitivity to model nondeterminism. A positive baseline delta is evidence that the skill body helps; a zero or negative delta should trigger review rather than automatic patching.

The baseline prompt instructs Codex not to use agent skills. Codex currently has
no dedicated CLI flag for disabling skill discovery, so treat baseline isolation
as best-effort when the evaluated skill is already installed globally.

## Improve A Skill

1. Run a baseline before editing.
2. Inspect failed checks, outputs, and self-reported unclear points.
3. Make the smallest generalizable skill change.
4. Rerun the same scenarios and compare pass rate and delta.
5. Add a new edge scenario for any reusable failure discovered.
6. Stop when the skill passes representative scenarios without unnecessary instruction growth.

Do not optimize solely for the current eval wording. Prefer requirements that represent real user outcomes.

## Static Audit

Run lightweight structural checks without model calls:

```sh
cowaxa audit <skill-directory>
cowaxa audit <skill-directory> --json
```

Use the official skill validator separately when available. `cowaxa audit` is intentionally not a replacement for platform-specific validation.

## Safety

- Keep executor sandbox mode read-only.
- Do not put secrets or production data in scenarios.
- Treat model-based evaluation as probabilistic evidence, not proof.
- Review generated artifacts before committing them.
