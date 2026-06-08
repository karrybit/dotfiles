# yq Patterns Reference

Last checked: 2026-06-08 (yq v4.53.3, mikefarah/yq)

Use this reference to choose concrete yq expressions for YAML inspection, filtering, patching, and multi-document operations.

## Source Summary

- yq (mikefarah/yq, Go implementation) is a YAML/JSON/XML processor with a jq-like expression syntax. It natively understands YAML structure, preserves comments, and composes well in shell pipelines.
- Primary use cases: reading and patching configuration files (Kubernetes manifests, GitHub Actions, Helm values, docker-compose), format conversion (YAML ↔ JSON ↔ XML), and multi-document merging.
- Two incompatible implementations exist: mikefarah/yq (Go, `yq '.field' file.yaml`) and kislyuk/yq (Python, jq wrapper). This reference targets mikefarah/yq. Verify with `yq --version | grep mikefarah`.
- Unlike sed/awk, yq parses YAML structure, so it handles multi-line strings, anchors, aliases, and comments correctly.

## Practical Use

### Verify the implementation

```sh
yq --version
# Output should reference: https://github.com/mikefarah/yq/
```

### Inspect before changing

```sh
yq '.' file.yaml                  # pretty-print the whole document
yq 'keys' file.yaml               # top-level keys
yq '.spec | keys' file.yaml       # keys of a nested mapping
```

Run these before writing any transformation so the structure and existing values are known.

### Read a field value

```sh
yq '.metadata.name' deployment.yaml
yq '.spec.replicas' deployment.yaml
yq '.spec.template.spec.containers[0].image' deployment.yaml
```

Use `-r` (or `--unwrapScalar=true`, which is the default in v4) to get raw string output without quotes.

### Filter array elements

```sh
yq '.spec.template.spec.containers[] | select(.name == "app")' deployment.yaml
yq '.items[] | select(.metadata.labels.env == "prod")' list.yaml
```

`select()` acts as a filter: only documents or array elements matching the condition are passed through.

### Patch a field (output to new file)

```sh
yq '.spec.replicas = 3' input.yaml > output.yaml
yq '.spec.template.spec.containers[] |= select(.name == "app").image = "v1.3.0"' input.yaml > output.yaml
```

Prefer explicit redirection (`> output.yaml`) to preserve the original unless in-place editing is requested.

### In-place edit

```sh
yq -i '.spec.replicas = 3' file.yaml
yq -i '.metadata.labels.version = "v2"' file.yaml
```

Use `-i` only when the user explicitly requests modifying the original file. yq preserves YAML comments when editing in place.

### Multi-document YAML (documents separated by `---`)

```sh
yq eval-all 'select(documentIndex == 0)' multi.yaml   # first document only
yq eval-all '. | select(.kind == "Deployment")' *.yaml # all Deployments across files
```

`eval-all` loads all documents before applying the expression, which is necessary for cross-document operations like merging.

### Merge two YAML files

```sh
yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' base.yaml override.yaml
```

The `*` operator performs a deep merge. Values in the second file override the first.

### Convert YAML to JSON

```sh
yq -o json '.' file.yaml
yq -o json '.spec' deployment.yaml
```

Use this when downstream tools (curl, jq, APIs) require JSON.

### Convert JSON to YAML

```sh
yq -P '.' file.json
```

`-P` (pretty-print) outputs YAML format regardless of input format.

### Create a document from scratch

```sh
yq -n '.name = "myapp" | .version = "1.0.0"'
```

`-n` (null input) starts with an empty document, useful for generating new YAML files programmatically.

### Round-trip validation

```sh
yq '.' output.yaml
```

If this command exits without error and produces readable output, the file is valid YAML. Use this as a quick structural check after any transformation.

## Guardrails

- Do not parse YAML with `sed`, `awk`, `grep`, or shell string operations when field boundaries, multi-line values, anchors, or comments may matter.
- Do not overwrite source YAML files unless explicitly requested. Default to `> output.yaml` redirection.
- Do not upload sensitive YAML (secrets, credentials) to external services or web demos. Use the local CLI.
- Validate transformed output with `yq '.' <file>` before presenting results.
- Prefer yq for read/patch operations; for large-scale templating with many environment-specific overrides, defer to Helm, Kustomize, or CUE.
- When the input is JSON and YAML-specific features (comments, anchors) are not needed, prefer `jq` over yq for pure JSON work.

## Sources

- yq official documentation: https://mikefarah.gitbook.io/yq/
- yq GitHub repository: https://github.com/mikefarah/yq/
- yq operators reference: https://mikefarah.gitbook.io/yq/operators

Revalidation trigger: Recheck when upgrading yq major/minor versions, when expression syntax appears to differ from this reference, or when adding scripts that depend on yq command output.
