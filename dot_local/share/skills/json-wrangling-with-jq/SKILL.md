---
name: json-wrangling-with-jq
description: Use when inspecting, filtering, transforming, or extracting data from JSON files or JSON command output. Prefer jq for JSON-aware command-line work before Python one-liners or awk/sed text parsing, especially when field selection, conditional filtering, reshaping, or pipelines matter.
---

# JSON Wrangling With jq

Prefer `jq` for local JSON manipulation because it handles JSON structure natively and composes well in shell pipelines.

## Workflow

1. Confirm the input source (file path or piped command output) and desired output shape.
2. Inspect structure before transforming:
   - `jq '.' <file>` — pretty-print
   - `jq 'keys' <file>` — top-level keys (if object)
   - `jq '.[0]' <file>` — first element (if array)
   - `jq 'length' <file>` — element count
3. Apply jq filters incrementally, building the pipeline step by step.
4. Preserve source files. Redirect output to a new path unless the user explicitly asks for in-place replacement.
5. Validate the result with at least one structural check such as `jq 'length'` or `jq 'type'`.

## Tool Choice

- Use `jq` for field selection (`.field`), array iteration (`.[]`), filtering (`select()`), mapping (`map()`), reshaping (`to_entries | map(…) | from_entries`), and formatted output (`@tsv`, `@csv`, `@base64`).
- Use `--raw-output` (`-r`) when the output should be plain text rather than JSON strings.
- Use `--arg` / `--argjson` to inject shell variables safely into jq expressions.
- When the JSON contains CSV-like tabular arrays and the task is bulk tabular analysis, consider exporting to CSV first (`jq -r '… | @csv'`) and then using `/csv-wrangling-with-qsv`.
- When the input is CSV/TSV, invoke `/csv-wrangling-with-qsv` instead of this skill.
- When the input is YAML, invoke `/yaml-wrangling-with-yq` instead of this skill.
- Use Python (`json` / `pandas`) when transformation logic involves multi-step accumulation, regex, or is more readable as code.
- Use `duckdb` or SQL when the task needs multi-step analytical modeling or complex aggregations across large JSON datasets.
- If `jq` is missing, do not silently fall back to unsafe text parsing. Check the local package manager or ask before installing when installation is outside the requested scope.

## References

Read [references/jq-patterns.md](references/jq-patterns.md) when choosing concrete jq filters, handling nested arrays, null propagation, or deciding whether jq is the right tool.
