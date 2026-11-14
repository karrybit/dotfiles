---
type: regex
target: { source: file, path: README.md }
pattern: 'default[^\n]{0,20}us-east-1'
match: not_contains
---
