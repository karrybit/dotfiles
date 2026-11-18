---
max_turns: 40
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../../vendor/pstack"]
---

/pstack:why 注文のイベントを、注文を保存したあとで直接 queue に送らずに、outbox のテーブルを通しているのはなぜですか。
