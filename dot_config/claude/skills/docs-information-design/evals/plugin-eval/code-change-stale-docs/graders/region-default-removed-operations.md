---
type: regex
target: { source: file, path: docs/operations.md }
pattern: 'default[^\n]{0,20}us-east-1'
match: not_contains
---
