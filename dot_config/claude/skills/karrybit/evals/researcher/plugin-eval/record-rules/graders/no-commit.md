---
type: regex
target: trace
pattern: '"command"\s*:\s*"[^"\n]*\bgit\s+(?:-\S+\s+\S+\s+)*commit\b'
match: not_contains
---
