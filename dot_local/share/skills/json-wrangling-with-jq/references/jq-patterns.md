# jq Patterns Reference

Last checked: 2026-06-08

Use this reference to choose concrete jq filters for JSON-aware inspection, transformation, and validation.

## Source Summary

- jq is a lightweight, portable command-line JSON processor. Its documented scope includes transforming JSON data with the same ease that `sed`, `awk`, `grep`, and their friends let you play with text.
- jq programs are filters: they take a JSON value as input, produce one or more outputs, and compose with pipes (`|`). Built-in functions cover arithmetic, string manipulation, type testing, path operations, and streaming.
- jq is designed for composable command-line use. The `--raw-output` (`-r`), `--arg`, `--argjson`, `--slurp`, `--null-input`, and `--compact-output` (`-c`) flags extend it for shell integration.

## Practical Use

### Inspect before changing

```sh
jq '.' data.json              # pretty-print the whole document
jq 'keys' data.json           # top-level keys (object)
jq '.[0]' data.json           # first element (array)
jq 'length' data.json         # element count
jq 'type' data.json           # "object", "array", "string", ...
jq '[.[0] | keys]' data.json  # keys of first array element
```

Use these before writing a transformation so structure, key names, and representative values are known.

### Select (filter array elements)

```sh
jq '[.[] | select(.status == "active")]' data.json
jq '[.[] | select(.amount > 100)]' data.json
jq '[.[] | select(.tags | contains(["beta"]))]' data.json
```

Prefer `select()` over text grep for field-conditional filtering.

### Extract fields

```sh
jq '.[] | {id, name}' data.json          # pick fields from each element
jq '.[] | .name' data.json               # scalar values, one per line
jq -r '.[] | .name' data.json            # plain text (no JSON quotes)
```

Use `-r` (`--raw-output`) when the result feeds a shell variable or non-JSON consumer.

### Map and transform

```sh
jq 'map(.amount * 1.1)' data.json                        # numeric transform
jq 'map(select(.status == "active") | {id, name})' data.json  # filter + project
jq 'map(.created_at |= split("T")[0])' data.json         # field update
```

`map(f)` is shorthand for `[.[] | f]`.

### Reshape with to_entries / from_entries

```sh
jq 'to_entries | map(select(.value != null)) | from_entries' data.json
jq 'to_entries | map({key: .key, value: (.value | tostring)}) | from_entries' data.json
```

Use `to_entries` / `from_entries` when renaming keys or filtering by key name.

### Group and aggregate

```sh
jq 'group_by(.status)' data.json
jq 'group_by(.status) | map({status: .[0].status, count: length})' data.json
jq '[.[] | .amount] | add' data.json      # sum a numeric field
jq '[.[] | .amount] | (add / length)' data.json  # average
```

### Formatted output

```sh
jq -r '.[] | [.id, .name, .status] | @tsv' data.json   # TSV for shell pipelines
jq -r '.[] | [.id, .name, .status] | @csv' data.json   # CSV
jq -r '.[] | .name | @base64' data.json                # base64-encode values
```

Use `@tsv` or `@csv` to bridge from JSON to tabular tools like `qsv`.

### Inject shell variables safely

```sh
jq --arg status "active" '[.[] | select(.status == $status)]' data.json
jq --argjson threshold 100 '[.[] | select(.amount > $threshold)]' data.json
```

Never interpolate shell variables directly into jq expressions; use `--arg` / `--argjson` to prevent injection.

### Slurp multiple files

```sh
jq -s '.[0] + .[1]' a.json b.json     # merge two objects
jq -s '[.[] | .[]]' a.json b.json     # concatenate two arrays
```

`--slurp` (`-s`) reads all inputs into a single array before applying the filter.

### Null propagation and alternative operator

```sh
jq '.user?.name // "unknown"' data.json   # safe navigation + default
jq '.tags // []' data.json                # default empty array when null
jq 'try .items[] catch "error"' data.json # swallow type errors
```

Use `//` (alternative operator) to supply defaults when a field may be absent or null.

## Guardrails

- Do not parse JSON with `awk`, `sed`, `grep`, or shell `IFS`-based splitting. Quoted strings, nested objects, and escaped characters make text parsing fragile.
- Do not overwrite source JSON files unless explicitly requested. Redirect output to a new path.
- Do not upload sensitive JSON data (tokens, credentials, PII) to web demos or external services. Use the local CLI.
- Validate transformed output structurally (`jq 'length'`, `jq 'type'`) before presenting results.
- When the jq filter chain becomes harder to read than a Python script, switch to Python.

## Sources

- jq manual (latest): https://jqlang.org/manual/
- jq GitHub repository: https://github.com/jqlang/jq
- jq playground (offline-capable): https://jqplay.org/

Revalidation trigger: Recheck when upgrading jq major/minor versions, when filter behavior appears to differ from this reference, or when adding deterministic scripts that depend on jq output format.
