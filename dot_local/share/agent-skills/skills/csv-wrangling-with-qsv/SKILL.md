---
name: csv-wrangling-with-qsv
description: Use when inspecting, transforming, validating, joining, filtering, sampling, summarizing, or exporting local CSV/TSV/tabular data from files or command output. Prefer qsv for CSV-aware command-line work before ad hoc awk/sed/cut parsing, especially when quoted fields, headers, large files, sampling, joins, schema checks, or reproducible data-cleaning pipelines matter.
---

# CSV Wrangling With qsv

Prefer `qsv` for local CSV/TSV manipulation because it handles CSV structure explicitly and composes well in shell pipelines.

## Workflow

1. Confirm the input files, delimiter, header row, desired output file, and whether the task is read-only or transformative.
2. Inspect structure before transforming:
   - `qsv headers <file>`
   - `qsv count <file>`
   - `qsv stats <file>`
   - `qsv sample 20 <file>`
3. Use qsv subcommands for CSV-aware operations instead of parsing CSV with `awk`, `sed`, `cut`, or line-oriented shell loops.
4. Preserve source files. Write transformed output to a new path unless the user explicitly asks for replacement.
5. Validate the result with at least one structural check such as `qsv headers`, `qsv count`, `qsv stats`, or a small `qsv sample`.

## Tool Choice

- Use `qsv select`, `search`, `filter`, `sort`, `slice`, `sample`, `stats`, `frequency`, `join`, `joinp`, `schema`, `validate`, `to`, and related commands for common CSV work.
- Use command-level delimiter flags such as `qsv stats --delimiter '\t' <file>` for TSV or non-comma separated files.
- Use `duckdb`, SQL, or Python when the task needs multi-step analytical modeling, complex window functions, non-tabular formats, or logic that becomes clearer as code.
- If `qsv` is missing, do not silently fall back to unsafe text parsing. Check the local package manager or ask before installing when installation is outside the requested scope.

## References

Read [references/qsv-patterns.md](references/qsv-patterns.md) when choosing concrete qsv commands, handling large files, validating schemas, or deciding whether qsv is the right tool.
