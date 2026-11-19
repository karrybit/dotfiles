---
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Edit, Write]
---

`docs/plan.md` の計画を受け取った。この計画で実装を始めてよいかを、karrybit:readiness-review を使って（使えなければ、自分で同じようにレビューして）レビューしてほしい。判定は READY・REVISE・BLOCKED のどれか 1 つで書き、根拠と、指摘ごとの返す先を添えて。
