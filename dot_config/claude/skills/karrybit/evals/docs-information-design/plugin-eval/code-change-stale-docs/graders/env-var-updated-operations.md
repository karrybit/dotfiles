---
type: regex
target: { source: file, path: docs/operations.md }
pattern: '^(?![\s\S]*(?:as `SHIPIT_DB_URL`|^\s*SHIPIT_DB_URL\s*:|KeyError: .SHIPIT_DB_URL))(?=[\s\S]*DATABASE_URL)'
flags: m
---
