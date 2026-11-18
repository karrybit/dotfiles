---
type: regex
target: trace
pattern: '"command"\s*:\s*"(?:[^"\n]*[;&|]\s*)?bd\s'
match: not_contains
---
