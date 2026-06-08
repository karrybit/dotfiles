---
name: yaml-wrangling-with-yq
description: Use when reading, filtering, patching, merging, or transforming YAML files
  such as Kubernetes manifests, GitHub Actions workflows, Helm values, or docker-compose
  configs. Prefer yq for YAML-aware command-line work before sed/awk text surgery,
  especially when preserving comments, structure, or typed values matters.
---

# YAML Wrangling With yq

Prefer `yq` (mikefarah/yq) for local YAML manipulation because it understands YAML structure natively, preserves comments by default, and composes well in shell pipelines.

## Workflow

1. Confirm the input file(s), key paths to read or patch, and whether changes go in-place or to a new file.
2. Inspect structure before modifying:
   - `yq '.' <file>` — pretty-print entire document
   - `yq 'keys' <file>` — top-level keys
   - `yq '.spec | keys' <file>` — nested keys
3. Apply yq expressions incrementally, verifying intermediate output before chaining further.
4. Preserve source files. Write transformed output to a new path unless the user explicitly requests in-place editing (`yq -i`).
5. Validate the result with a round-trip check: `yq '.' <output>` should parse without error.

## Tool Choice

- Use `yq` (mikefarah/yq, Go implementation). Verify: `yq --version` should reference `https://github.com/mikefarah/yq/`.
- Use `.field`, `.array[]`, `select()`, `with()`, `eval-all`, and `|` pipelines for common operations.
- Use `yq -i` for in-place edits; prefer explicit output redirection otherwise.
- Use `yq eval-all '…' *.yaml` for multi-document or multi-file operations.
- Use `yq -o json` when downstream tools need JSON output.
- When the input is JSON, invoke `/json-wrangling-with-jq` instead of this skill. yq can read JSON, but jq is the primary tool for pure JSON work.
- When the input is CSV/TSV, invoke `/csv-wrangling-with-qsv` instead of this skill.
- For large-scale templating with many environment-specific overrides, delegate to Helm, Kustomize, or CUE rather than chaining long yq expressions.
- If `yq` is missing, do not silently fall back to sed/awk text surgery. Check the local package manager or ask before installing when installation is outside the requested scope.

## References

Read [references/yq-patterns.md](references/yq-patterns.md) when choosing concrete yq expressions, handling multi-document YAML, validating round-trips, or deciding whether yq is the right tool.
