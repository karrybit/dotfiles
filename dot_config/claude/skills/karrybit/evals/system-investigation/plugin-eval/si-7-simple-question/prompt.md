---
max_turns: 40
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../..", "../../../../vendor/pstack"]
---

`app/pricing.py` の `calc_total` は、割引したあとの 1 円未満をどう扱いますか。
