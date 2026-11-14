---
type: regex
target: { source: file, path: docs/configuration.md }
pattern: '^(?=[\s\S]*^## listen$)(?=[\s\S]*^## upstreams$)(?=[\s\S]*^## oidc$)(?=[\s\S]*^## session$)(?=[\s\S]*^## policy$)(?=[\s\S]*^## logging$)'
flags: m
---
