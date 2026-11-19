---
type: regex
target: files
pattern: '^(?!.*__pycache__)(?!(?:.*/)?tests/test_\w+\.py$).+$'
flags: m
match: not_contains
---
