---
max_turns: 40
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../..", "../../../../vendor/pstack"]
---

注文の確定メールは、どの部品がいつ送っていますか。メールの API が失敗したとき、注文の API は何を返しますか。
