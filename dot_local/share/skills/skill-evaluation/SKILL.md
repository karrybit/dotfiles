---
name: skill-evaluation
description: Create and run empirical evaluations for agent skills using realistic scenarios, structured self-reports, and with-skill versus without-skill baseline comparisons. Use when measuring whether a skill improves Codex or Claude Code behavior, authoring skill-local eval suites, comparing prompt revisions, or auditing skill structure. Do not use for ordinary unit tests or application benchmarks.
---

# Skill Evaluation

Evaluate agent skills with the available skill-evaluation runner. Prefer
`cowaxa` for Codex runs and `waxa` or a Claude Code-specific runner when present.

## When to Use

Use this skill when:

- Measuring whether an agent skill improves Codex or Claude Code behavior.
- Authoring or extending a skill-local eval suite (`evals/tasks/*.yaml`).
- Comparing two prompt revisions with a baseline delta.
- Auditing a skill's structure for correctness or completeness.

Do **not** use this skill for:

- Writing unit tests or integration tests for application code.
- Benchmarking application throughput, latency, or resource use.
- Load testing or stress testing a running service.
- Any evaluation that is not specifically about agent skill behavior.

## Executor Selection

| Environment | Executor | Detection |
|-------------|----------|-----------|
| Codex | `cowaxa` | `command -v cowaxa` succeeds |
| Claude Code | `waxa` or project runner | `command -v waxa` succeeds |
| Neither found | Static audit only | Both commands absent |

When both executors are present, prefer `cowaxa` for Codex-backed runs and
`waxa` for Claude Code runs. Do not treat them as interchangeable without
checking their `--help` output and output directory behavior first.

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

## Output Format

After each eval run, report:

1. **Pass rate** — fraction of grader checks that passed per scenario.
2. **Baseline delta** — difference in pass rate with vs. without the skill body.
3. **Unclear points** — list of items the model flagged as ambiguous; aim for ≤ 1 per run.
4. **Next action** — the single smallest change to make before the next run, or "converged" if the skill passes representative scenarios without unnecessary instruction growth.

Artifacts are written to `<skill>/evals/results/` by the executor. Commit
them only after review.

## Safety

- Keep executor sandbox mode read-only.
- Do not put secrets or production data in scenarios.
- Treat model-based evaluation as probabilistic evidence, not proof.
- Review generated artifacts before committing them.
