# qsv Patterns Reference

Last checked: 2026-06-07

Use this reference to choose concrete qsv commands for CSV-aware inspection, transformation, and validation.

## Source Summary

- qsv is a command-line data-wrangling toolkit for tabular data including CSV and Excel-like workflows. Its documented scope includes querying, slicing, sorting, analyzing, filtering, enriching, transforming, validating, joining, formatting, converting, and documenting tabular data.
- qsv is built for composable command-line use and supports both ordinary CSV workflows and larger data tasks through commands such as `join`, `joinp`, and `sqlp`.
- qsv command pages document focused subcommands: `select` for column selection, `stats` for summary statistics and type inference, `sample` for row sampling, `join` for joining two CSV data sets, and `validate` for JSON Schema based validation.
- qsv is a fork/evolution of xsv. xsv's original scope was fast CSV indexing, slicing, analysis, splitting, and joining; qsv expands that direction into a broader data-wrangling toolkit.

## Practical Use

### Inspect before changing

```sh
qsv headers data.csv
qsv count data.csv
qsv stats data.csv
qsv sample 20 data.csv
```

Use these before writing a transformation so column names, row count, rough value distributions, and representative rows are known.

### Select, reorder, or drop columns

```sh
qsv select name,email,status input.csv > selected.csv
qsv select '!debug_column' input.csv > without-debug.csv
```

Prefer column names when headers exist. Use `qsv headers` first if names or order are uncertain.

### Filter rows

```sh
qsv search --select status '^active$' input.csv > active.csv
qsv search --exact --select status completed input.csv > completed.csv
```

Prefer qsv regex/literal filtering over line-oriented `grep` when matching fields in CSV.

### Sample safely

```sh
qsv sample 100 input.csv > sample.csv
```

Use sampling before asking an agent to inspect or summarize a large file. Keep the original file untouched.

### Summarize distributions

```sh
qsv stats input.csv > stats.csv
qsv frequency --select status input.csv > status-frequency.csv
```

Use `stats` for numeric and type-oriented summaries. Use `frequency` for categorical distributions.

### Join tables

```sh
qsv join id left.csv id right.csv > joined.csv
```

Use `joinp` when the join is large, requires stronger validation, or benefits from qsv's parallel join features.

### Generate and use schemas

```sh
qsv schema input.csv > input.schema.json
qsv validate input.csv input.schema.json
```

Use schema generation and validation when similar CSV files must conform to expected columns, types, or value domains.

## Guardrails

- Do not parse CSV with `awk`, `sed`, `cut`, or shell `IFS=,` loops when quoted delimiters, embedded newlines, or headers may matter.
- Do not overwrite source CSV files unless explicitly requested.
- Do not upload sensitive CSV data to web demos or external services. Prefer the local CLI.
- Validate transformed output structurally before presenting results.
- Use a more expressive engine when the qsv command chain becomes harder to review than SQL or code.

## Sources

- qsv official site: https://qsv.dathere.com/
- qsv GitHub README: https://github.com/dathere/qsv
- qsv `select` command page: https://qsv.dathere.com/web/select
- qsv `stats` command page: https://qsv.dathere.com/web/stats
- qsv `sample` command page: https://qsv.dathere.com/web/sample
- qsv `join` command page: https://qsv.dathere.com/web/join
- qsv `validate` command page: https://qsv.dathere.com/web/validate
- xsv GitHub README: https://github.com/BurntSushi/xsv

Revalidation trigger: Recheck when changing installed qsv major/minor versions, when qsv command names or options appear to differ from this reference, or when adding deterministic scripts that depend on qsv command output.
