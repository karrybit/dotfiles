# waxa Eval Execution Guide

Procedures and gotchas for evaluating and improving user-global skills with
waxa (`@mizchi/waxa`).

- Source: https://github.com/mizchi/skills/tree/main/tools/waxa
- Checked: 2026-06-09 (waxa-src v0.3.1 / Deno native)

---

## Prerequisites

### Do not use the npm package

`@mizchi/waxa` npm package (v0.1.1) throws
`dntShim.Deno.Command is not a constructor` on Node.js, breaking the LLM
grader. Use the Deno-native source instead.

**Use the Deno-native source**:

- Source: `~/.local/share/agents/tools/waxa-src/tools/waxa/src/cli.ts`
- Wrapper: `~/.local/bin/waxa-deno` (chezmoi-managed)

`waxa-src` is a standalone git repository outside chezmoi. To update it:

```bash
cd ~/.local/share/agents/tools/waxa-src && git pull
```

---

## Sandbox restriction (critical)

waxa spawns `claude -p` as a subprocess. The `claude -p` SessionEnd hook
tries to write to `~/.config/claude/projects/...`, which Claude Code's default
sandbox blocks.

**Symptoms**:
- All graders score 0%
- `judge-error: claude exit 1`
- `self-report: (not extracted)`
- Execution finishes in a few seconds instead of several minutes

**Fix**: Always pass `dangerouslyDisableSandbox: true` to the Bash tool when
running waxa from within Claude Code.

---

## Run commands

```bash
# Run from the skill directory
cd ~/.local/share/skills/<skill-name>
deno run -A ~/.local/share/agents/tools/waxa-src/tools/waxa/src/cli.ts evals/eval.yaml

# Or via the waxa-deno wrapper
~/.local/bin/waxa-deno evals/eval.yaml
```

Running multiple skills in parallel:

```bash
WAXA_SRC="${HOME}/.local/share/agents/tools/waxa-src/tools/waxa"
run_skill() {
  local name="$1"
  cd "${HOME}/.local/share/skills/${name}" \
    && deno run -A "${WAXA_SRC}/src/cli.ts" evals/eval.yaml 2>&1 \
    | grep "^Overall pass rate"
}
run_skill agent-architecture-audit &
run_skill cli-creator &
wait
```

---

## Directory structure

```
~/.local/share/skills/<skill-name>/
├── SKILL.md
├── evals/
│   ├── eval.yaml              # eval definition
│   ├── ledger.yaml            # convergence log
│   └── tasks/
│       ├── scenario-typical.yaml   # happy path
│       └── scenario-edge.yaml      # out-of-scope / non-firing case
```

The `results/` directory is gitignored (`dot_local/share/skills/.gitignore`
contains `results/`).

### eval.yaml example

```yaml
id: my-skill-eval
skill_body: SKILL.md
layout: skill-local
tasks:
  - evals/tasks/scenario-typical.yaml
  - evals/tasks/scenario-edge.yaml
```

---

## task YAML format (waxa 0.3.1)

```yaml
id: scenario-typical
description: |
  Scenario description.

inputs:
  prompt: |
    User prompt text.
    Note: Real network fetches and external command execution are unavailable
    in this evaluation context; narrate the workflow you would follow.

graders:
  - name: self_report_check
    type: self-report
    config:
      max_unclear: 1

  - name: surface_check
    type: text
    config:
      regex_match:
        - "(?i)(pattern1|pattern2)"
      regex_not_match:
        - "(?i)(bad_pattern)"

  - name: llm_rubric
    type: llm
    config:
      rubric: |
        Evaluation criteria.
        Score PASS if <condition>.
```

---

## YAML gotchas

| Symptom | Cause | Fix |
|---------|-------|-----|
| `TypeError: Cannot read properties of undefined (reading 'prompt')` | Used top-level `prompt:` | Change to `inputs:\n  prompt:` |
| `negate: true` has no effect | Not supported by waxa | Use `regex_not_match` instead |
| YAML parse error on `\.` in a double-quoted string | YAML escape conflict | Use `.` directly — it matches the literal dot in regex too |
| YAML SyntaxError: `missing colon` | `: ` inside a list item parsed as a mapping | Wrap in a block scalar (`\|`) or single quotes |
| Multiple patterns in `regex_match` all fail | AND logic — every pattern must match | Split into separate graders |
| Long chained regex `.{0,N}` misses content | Distance too short or expression too strict | Increase N or split into independent patterns |

---

## Four-stage iteration pattern

| Stage | Symptom | Diagnosis | Fix |
|-------|---------|-----------|-----|
| 1. Structural fix | LLM + surface both fail | SKILL.md missing required instruction | Add the missing step, example, or classification rule to SKILL.md |
| 2. Grader breadth | LLM passes, surface fails (same axis) | Regex too narrow for actual model output | Widen alternation, increase `{0,N}` distance |
| 3. Surface-form coverage | Some patterns miss | English/Japanese/abbreviation variation | Add synonyms and variant forms |
| 4. Residual | Network constraint or structural eval limit | Cannot be fixed without changing eval environment | Record in ledger and close |

### Grader pair principle

Pair a `text` grader (regex) with an `llm` grader (semantic) for each
evaluation axis.

- LLM passes, surface fails → Stage 2 (regex too narrow)
- LLM fails, surface passes → Stage 1 or misclassification (model not following SKILL.md)
- Both fail → Stage 1 (structural SKILL.md issue)

---

## Prompt boilerplate for eval context

Since network access and external commands are unavailable during evals,
include this note in the prompt:

```
Note: Real network fetches and external command execution are unavailable
in this evaluation context; narrate the workflow you would follow and
describe the commands you would run, with expected outputs.
```

---

## Convergence log (ledger.yaml)

```yaml
iterations:
  - id: iter-1
    date: 2026-06-09
    overall_pass_rate: 75%
    actions:
      - widened regex alternation in failure_capture_surface
convergence:
  status: converged   # converged | near_convergence | converging
  rationale: |
    All graders pass. No residual unclear points.
```
