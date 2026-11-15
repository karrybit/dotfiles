# karrybit:organize evals

Behavior cases for comparing versions of the `organize` skill. Run them with the `karrybit:skill-eval` skill, which runs `claude plugin eval` against the deployed `karrybit` plugin or against a wrapper plugin holding one version of this skill.

`organize` gathers the materials for one request, fills the request template in `brief.md`, hands the work to one new subagent, and returns the document's path and the number of claims it checked. The cases measure both what `organize` decides (whether it starts, what the request carries) and the explanation document the subagent writes.

## Files

- `plugin-eval/`: the suite, one directory per case (`prompt.md`, `case.yaml`, `fixture.sh`, `graders/`).
  - `no-destination`: an explanation document is requested without a destination; the skill asks for one before it starts, without an `Agent` or `Write` call.
  - `document`: the destination and the reader are given, and the subagent writes the whole document.
    - Request graders: the request is built from the template, with the fixture's full commit hash, the absolute destination path, the `rubric.md` path, frontmatter `なし`, and no unfilled `<…>`.
    - Document graders: the document has the `この文書が答える問い:` list with at least three anchor links, at least one relation written as `A —動詞→ B`, and source references as `jobq.py:<line>`. `answer-first` fails when any `##` or `###` heading is followed directly by a list item or a table row instead of the answer sentence that `brief.md` step 5 puts first. `retry-count-mismatch` checks that it states the code's three attempts and reports the README's five retries as a contradiction.
    - Reply graders: the final reply has the document's absolute path and the number of checked claims.
- `plugin-eval-holdout/frontmatter`: the request names a frontmatter rule file whose check command is `tools/check_frontmatter.py`; the request carries that rule and command instead of `なし`. Run only to check a change before adopting it.
- `canary.patch`: removes from `SKILL.md` the rule to ask for a missing destination, the full commit hash from the materials, and the rule that fills the template's rubric path.
- `fixtures/jobq`: a one-file Python job queue and its README, which says a failed job is retried up to 5 times while the code stops after 3 attempts. `fixtures/jobq-frontmatter` adds the frontmatter rule file and its check script.

## Settings for This Suite

- `plugin-eval/` cases grant `Bash`, `Write`, and `Edit`: run them with `--scaffold --allow-tools Bash Write Edit`. `plugin-eval-holdout/` grants no gated tool, so its subagent stops at its first write and its graders read only the request.
- `organize` reads no sibling skill: build the wrapper with `skill-wrap <karrybit>/exact_skills/organize <ref> DIR/kit`.
- Run `plugin-eval-holdout/` with `--eval-dir evals-holdout` against a wrapper.
