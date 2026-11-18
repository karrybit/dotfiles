---
max_turns: 40
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../..", "../../../../vendor/pstack"]
---

relay は outbox の行をどうやって queue に送っていますか。1 件ずつではなく今の送り方になっているのはなぜですか。
