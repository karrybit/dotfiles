# karrybit:explain evals

Behavior cases for comparing versions of the `explain` skill. Run them with the `karrybit:skill-eval` skill, which runs `claude plugin eval` against the deployed `karrybit` plugin or against a wrapper plugin holding one version of this skill.

`explain` writes one request for one subagent and hands the work to it. The cases measure what `explain` itself decides: whether it starts, what the request carries, and how it sets up an evaluation. They do not measure the HTML a full run would produce, because an eval run loads only the plugin under test, so the HTML plugin and the browser MCP server that `visualize`'s request relies on are absent.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`).
  - `no-destination`: an HTML explanation is requested without a destination; the skill asks for one before it starts.
  - `brief`: the destination is given; the request carries both the organize and the visualize request, absolute paths, the two rubric paths, and no unfilled `<…>`.
  - `evaluate`: an HTML explanation with three planted defects is to be evaluated; one evaluator receives both rubrics, and the reply reports each defect under the gate of the right rubric. The defects are a claim contradicting the source (`organize`'s G1), a diagram edge the source does not support (`visualize`'s G1), and an inference marked by colour alone (`visualize`'s S6). Since the run cannot render the HTML, `no-unrendered-pass` also requires that no `visualize` gate needing the rendering step is marked passed.
- `plugin-eval-holdout/from-doc`: the source is already an explanation document; the request skips the organize step and marks the document read-only. Run only to check a change before adopting it.
- `canary.patch`: removes from `SKILL.md` the rule to ask for a missing HTML destination, the rule to write absolute paths into the request, and the rule to hand an evaluation to one new subagent with both rubrics and have it name each gate's rubric.
- `fixtures/retry-lib`: a one-file Python retry helper and its README. `fixtures/retry-explained` adds an explanation document of it and an HTML explanation with the planted defects.

## Settings for This Suite

- Cases grant `Read`, `Glob`, `Grep`, `Skill`, and `Agent`, and no gated tool: run them with `--scaffold` and without `--allow-tools`. Without `Write`, the subagent of `brief` and `from-doc` stops at its first write, which keeps the runs short; the graders read only the request it was given.
- `explain` reads `organize` and `visualize` as sibling skill directories, so a wrapper needs them too: build it with `skill-wrap <karrybit>/exact_skills/explain <ref> DIR/kit organize visualize`.
- Run `plugin-eval-holdout/` with `--eval-dir evals-holdout` against a wrapper.

## What the Suite Separates

Measured on wrappers holding `explain`, `organize`, and `visualize` at one commit, with `karrybit:skill-eval`'s suite command (`--ablation none`, `--runs 3`, `--model claude-sonnet-5-5`, `--judge-model claude-opus-5-5`):

- The canary drops `no-destination/asks-destination` and `no-destination/no-agent` to 0/3 (skill 6/6 over two runs) and `evaluate/one-evaluator` to 0/3.
- `brief/absolute-html-path` does not separate the canary (3/3): the request template's `<HTML の絶対パス>` and step 2's completion condition ask for absolute paths too.
- `evaluate/no-unrendered-pass` passes 6/6 over two runs; with the `visualize` rubric's rule that a rendering gate passes only after rendering taken out, it passed 2/3.
- `evaluate/attempt-count-error`, `diagram-error`, and `color-only-marker` fail at most one run in any configuration; the evaluator finds the planted defects with or without the canary.
- The holdout's `skill-fired` fails one run in three in both versions, when the model loads `visualize` directly for an input that is already an explanation document; its other graders pass.
