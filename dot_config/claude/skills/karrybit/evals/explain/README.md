# karrybit:explain evals

Behavior cases for comparing versions of the `explain` skill. Run them with the `karrybit:skill-eval` skill, which runs `claude plugin eval` against the deployed `karrybit` plugin or against a wrapper plugin holding one version of this skill.

`explain` writes one request for one subagent and hands the work to it. The cases measure what `explain` itself decides: whether it starts, what the request carries, and how it sets up an evaluation. They do not measure the HTML a full run would produce, because an eval run loads only the plugin under test, so the HTML plugin and the browser MCP server that `visualize`'s request relies on are absent.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`).
  - `no-destination`: an HTML explanation is requested without a destination; the skill asks for one before it starts.
  - `brief`: the destination is given; the request carries both the organize and the visualize request, absolute paths, the two rubric paths, and no unfilled `<…>`.
  - `evaluate`: an HTML explanation with three planted defects is to be evaluated; one evaluator receives both rubrics, and the reply reports each defect under the gate of the right rubric. The defects are a claim contradicting the source (`organize`'s G1), a diagram edge the source does not support (`visualize`'s G1), and an inference marked by colour alone (`visualize`'s S6).
- `plugin-eval-holdout/from-doc`: the source is already an explanation document; the request skips the organize step and marks the document read-only. Run only to check a change before adopting it.
- `canary.patch`: removes from `SKILL.md` the rule to ask for a missing HTML destination, the rule to write absolute paths into the request, and the rule to give one evaluator both rubrics and have it name each gate's rubric.
- `fixtures/retry-lib`: a one-file Python retry helper and its README. `fixtures/retry-explained` adds an explanation document of it and an HTML explanation with the planted defects.

## Settings for This Suite

- Cases grant `Read`, `Glob`, `Grep`, `Skill`, and `Agent`, and no gated tool: run them with `--scaffold` and without `--allow-tools`. Without `Write`, the subagent of `brief` and `from-doc` stops at its first write, which keeps the runs short; the graders read only the request it was given.
- `explain` reads `organize` and `visualize` as sibling skill directories, so a wrapper needs them too. After `skill-wrap <karrybit>/exact_skills/explain <ref> DIR/kit`, add each at the same ref:
  `mkdir DIR/kit/skills/organize && git -C <karrybit>/exact_skills/organize archive <ref> . | tar -x -C DIR/kit/skills/organize`, and the same for `visualize`.
- Run `plugin-eval-holdout/` with `--eval-dir evals-holdout` against a wrapper.
