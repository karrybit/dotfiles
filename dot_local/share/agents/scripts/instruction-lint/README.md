# instruction-lint

Checks the machine-checkable rules of
`~/.local/share/agents/docs/instruction-writing-standard.md` on instruction
files: `CLAUDE.md`, `AGENTS.md`, `SKILL.md`, subagent definitions, and rule
files.

```sh
$XDG_DATA_HOME/agents/scripts/instruction-lint/bin/instruction-lint FILE...
```

It prints one finding per line as `FILE:LINE: message` and exits 1 when there
is any finding, 2 on a usage error. Dependencies: `rg` (with PCRE2), `yq`
(mikefarah), and POSIX `awk`, `wc`, and `sh`.

## What It Checks

The kind of file comes from its name and its parent directory.

| File | Checks |
| --- | --- |
| `CLAUDE.md`, `AGENTS.md`, `rules/*.md` | at or under 200 lines |
| `SKILL.md` | under 500 lines; frontmatter on line 1 that is valid YAML; a `description`; `description` plus `when_to_use` within 1,536 characters |
| `agents/*.md` | frontmatter on line 1 that is valid YAML; a `name` and a `description` |
| every file | no emphasis word (`MUST`, `IMPORTANT`, `NEVER`, `ALWAYS`, `CRITICAL`, `必ず`, `絶対`); every numbered list item followed by a `Completion:` or `完了条件:` line before the next item or heading |

Fenced code blocks, inline code, and spans quoted with `"…"` or `「…」` are
skipped, so a command, an example, or a word being mentioned is not reported.
`絶対パス` (absolute path) is not an emphasis word.

## What It Does Not Check

- Whether a line has a trigger and one action, duplication, and contradictions:
  these need a reader. Use review, and `/doctor prompt-audit` for
  contradictions and stale references.
- Markdown structure such as heading levels and line length: run `rumdl check`.
- Plugin-level skill and agent fields: `claude plugin validate <dir>` covers
  those, but it does not check the description length and reports
  plugin-catalog items unrelated to user-scope files.

A file that is not one of the five kinds gets only the every-file checks, so
running it on a source summary or a README reports numbered lists that are not
steps.
