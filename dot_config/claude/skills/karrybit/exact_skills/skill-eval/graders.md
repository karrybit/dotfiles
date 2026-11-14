# Writing Cases and Graders

Read when: writing or changing a case or a grader in a skill's
`evals/plugin-eval*` directories. The full schema is in the Plugin Evals
documentation: <https://code.claude.com/docs/en/plugin-evals.md>.

## Case Files

- `prompt.md`: frontmatter with `max_turns`, `timeout_seconds`,
  `allowed_tools`, and optionally `tags`, then the user's request as body.
- `case.yaml`: `schema_version`, `name`, and `context.scaffold_script` naming
  the scaffold script beside it.
- `graders/<name>.md`: frontmatter naming the grader `type` and its settings;
  an `llm` grader's rubric is the body.
- `claude plugin eval init` drafts a suite through an interview, and
  `init --bare <name>` writes a blank single-case template; `init` has no cost
  ceiling of its own.

## Choosing a Grader Type

| Type | Checks | Settings |
| --- | --- | --- |
| `regex` | A file (`target: { source: file, path: README.md }`) or the list of new files (`target: files`) | `pattern`, `flags`, `match` (`contains`, `not_contains`, `count:N`) |
| `tool_used` | Calls to one tool, optionally only those whose input matches `input_match` | `tool`, `input_match`, `min`, `max` |
| `llm` | The run's output against a rubric, by three judge votes | rubric in the body |

- Prefer `regex` and `tool_used`, and use `llm` only for what needs a reader's
  judgment, since judge votes vary between repeats.
- Check that the skill fired with `type: tool_used`, `tool: Skill`, and
  `input_match: '"skill"\s*:\s*"(?:[\w-]+:)?<skill name>"'`, so the plugin
  prefix does not matter.

## Patterns That Replace a Diff

- No file changed: when a case grants no `Bash`, `Edit` and `Write` are the
  only tools that change files, so `tool_used` with `max: 0` on each shows
  that nothing changed; `input_match` narrows it to paths outside the allowed
  file.
- Nothing outside a section changed: embed the original text outside the
  section in the pattern and leave only the section as `[\s\S]*?`.
- A length bound: `^[\s\S]{0,N}$`, where `N` counts UTF-16 code units, since
  `regex` patterns run as JavaScript.
- For searches across files, link resolution, or files whose names are not
  known in advance, write the assertion in the skill's `grade.py` and run
  `scripts/grade-kept`.

## Writing an `llm` Rubric

- The judge sees only the output, so state in the rubric every fixture fact
  the verdict relies on, and check each stated fact against the fixture.
- Write a `PASS if` line and a `FAIL if` line.
