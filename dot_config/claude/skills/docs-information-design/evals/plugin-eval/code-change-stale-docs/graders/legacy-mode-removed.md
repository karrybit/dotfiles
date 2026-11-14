---
type: regex
target: { source: file, path: README.md }
pattern: '^(?![^\n]*(?:removed|no longer|deprecated|dropped|削除|廃止))[^\n]*--legacy-mode'
flags: m
match: not_contains
---
