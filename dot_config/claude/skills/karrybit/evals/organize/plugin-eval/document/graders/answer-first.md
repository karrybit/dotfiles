---
type: regex
target: { source: file, path: docs/queue.md }
pattern: '^#{2,3} [^\n]+\n+(?:[-*+] |\d+\. |\|)'
flags: m
match: not_contains
---
