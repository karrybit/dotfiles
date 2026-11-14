---
max_turns: 4
tags: [nofire]
allowed_tools: [Read, Glob, Grep, Skill]
---

docs/adr/0004-use-sqlite.md として ADR を書いて。決定は SQLite を採用、理由は単一バイナリで配布したいから、却下案は PostgreSQL（運用コスト）。書式は既存の 0003 に合わせて
