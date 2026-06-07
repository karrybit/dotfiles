---
name: skill-evaluation
description: Create and run empirical evaluations for agent skills using realistic scenarios, structured self-reports, and with-skill versus without-skill baseline comparisons. Use when measuring whether a skill improves Codex or Claude Code behavior, authoring skill-local eval suites, comparing prompt revisions, or auditing skill structure. Do not use for ordinary unit tests or application benchmarks.
---

# Skill Evaluation

Evaluate agent skills with the available skill-evaluation runner. Prefer
`cowaxa` for Codex runs and `waxa` or a Claude Code-specific runner when present.

## Start

Verify the available executor:

```sh
command -v cowaxa || command -v waxa
```

For Codex-backed evaluation, also run:

```sh
cowaxa doctor --json
```

`cowaxa` uses `codex exec --ephemeral --sandbox read-only` and writes evaluation
artifacts under `<skill>/evals/results/`. Treat other runners as equivalent only
after checking their help output and output directory behavior.

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

The baseline prompt should instruct the evaluated agent not to use agent skills.
When the target runner has no dedicated flag for disabling skill discovery, treat
baseline isolation as best-effort when the evaluated skill is already installed
globally.

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

Use the official skill validator separately when available. Static runner audits
are intentionally not replacements for platform-specific validation.

## Safety

- Keep executor sandbox mode read-only.
- Do not put secrets or production data in scenarios.
- Treat model-based evaluation as probabilistic evidence, not proof.
- Review generated artifacts before committing them.
