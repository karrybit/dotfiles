# karrybit:agent-work-design evals

Cases for the `agent-work-design` skill in `exact_skills/exact_agent-core/`. They measure what the agent decides and does on a large or small piece of work (whether it picks the skill on its own, which dependencies and gates its plan keeps, which goals it runs in parallel, what it creates), not the headings of its reply. Run them with the `karrybit:skill-eval` skill's suite command; this README gives the targets and flags that differ.

## What Each Behavior Is Measured By

| Behavior | Suite and case | Graders |
| --- | --- | --- |
| The skill is picked on its own for large work | `plugin-eval-activation` q01–q04 (`fire`): a staged library upgrade across three repositories, a staged merge of four plugins, a log platform move that starts with an investigation, a feature split across three agents. No prompt names the skill | `skill` (`tool_used` Skill, `min: 1`) |
| The skill is not picked for small work | `plugin-eval-activation` q05–q08 (`nofire`): a one-line typo, a paragraph rewrite, a one-function bug, one delegated task | `skill` (`min: 0, max: 0`) |
| The plan does not over-split | `one-goal-change`: an option, its test, and a README line, with "段取りを考えてから進めて" in the request | `one-goal`, `skill-not-fired` |
| The plan keeps the dependencies that matter | `deps-provider-switch`: an email provider switch whose vendor notes, linked from nowhere, require template approval before the first send, and whose `templates/` another team's batch reads | `read-vendor-notes`, `approval-before-switch`, `owner-before-delete` |
| Work that changes the same files is not run in parallel, and independent work is | `parallel-shared-file`: two API changes to the same handler and contract, and a translation that touches neither | `shared-files-not-parallel`, `independent-in-parallel` |
| No needless agent, script, or management file | `one-goal-change` and `parallel-shared-file`; `replan-after-review` | `no-agent` (`tool_used` Agent, `max: 0`, `arm: both`), `no-extra-files` (no new file but a test file), `no-new-files` |
| A changed premise is followed downstream, and the rest is kept | `replan-after-review`: a review moves G2 from a new column in another team's table to a table of the service's own; G3 depends on G2, G1 and G4 do not | `g3-follows`, `g1-kept`, `g4-kept`, `g2-replaced` |

`skill-fired` in the other cases is the plugin-fired indicator of a two-arm run and is left out of the score.

## Files

- `plugin-eval/`: the behavior suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`); each `fixture.sh` copies its fixture from `fixtures/` and commits it.
- `plugin-eval-activation/`: requests tagged `fire` or `nofire`, without a scaffold.
- `plugin-eval-calibration/`: a hand-written good answer and a near-miss bad answer (`answer.md`) for each behavior case, judged by copies of that case's `llm` graders. The bad answers miss exactly what the graders look for: a switch that does not wait for template approval and a `templates/` deletion beside the switch; two agents editing `handler.py` in parallel and a translation held back; a four-goal plan for one change; a G2 rewrite whose G3 still reads `products.search_text`. Each copy must stay identical to its original, which `diff` shows (see Running).
- `fixtures/notify-service`: an email sender on oldmail, `templates/`, `docs/ops.md` (another team's batch reads `templates/`), and `docs/vendor/newmail.md` (template approval of up to two business days, 5 messages a second).
- `fixtures/report-api`: `GET /reports` in `src/reports/handler.py`, its contract in `openapi.yaml`, and a Japanese guide.
- `fixtures/textwrap-lite`: `truncate` in `textlite.py`, its tests, and a README.
- `fixtures/search-plan`: a four-goal plan and a review of its G2.

## Settings for This Suite

- `plugin-eval/`: `--scaffold --allow-tools Bash Edit Write`, two arms, `Agent` kept callable so `no-agent` can fail.
- `plugin-eval-activation/`: `--ablation none`, no `--scaffold`.
- `plugin-eval-calibration/`: `--scaffold --ablation none`; the answers do not depend on the plugin.
- The skill reads no sibling skill. Run against the whole `karrybit` plugin as `chezmoi archive` renders it, so the activation cases compete with every other karrybit description.

## Running

1. Build the plugin copy from the checkout to evaluate, in a `DIR` outside the repository whose path has no `eval`, `test`, or `scratchpad`:
   `chezmoi archive -S <checkout> --format tar ~/.config/claude/skills/karrybit | tar -x -C DIR/with`.
   Completion: `DIR/with/.config/claude/skills/karrybit/skills/agent-core/agent-work-design/SKILL.md` exists.
2. Check that each calibration grader is a copy of its original: for each `plugin-eval-calibration/<case>-<good|bad>/graders/<g>.md`, `diff` it against `plugin-eval/<case>/graders/<g>.md`.
   Completion: every `diff` prints nothing.
3. Run the three eval directories against `DIR/with/.config/claude/skills/karrybit` with `--runs 3`.
   Completion: each result JSON has `"partial": false`, every run has `"error": null`, and every good calibration answer passes its graders more often than its bad one.
