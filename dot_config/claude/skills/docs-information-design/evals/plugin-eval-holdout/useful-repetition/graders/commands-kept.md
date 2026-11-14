---
type: regex
target: { source: file, path: docs/runbook-failover.md }
pattern: '^(?=[\s\S]*pg_ctl promote)(?=[\s\S]*set-db-host\.sh)(?=[\s\S]*restart-apps\.sh)(?=[\s\S]*healthz/write)(?=[\s\S]*rebuild-replica\.sh)'
flags: i
---
