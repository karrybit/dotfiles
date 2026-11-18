---
max_turns: 40
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../..", "../../../../vendor/pstack"]
---

このリポジトリで、POST /orders の要求を受け付けてから注文の確定メールが送られるまでに、どの部品をどの順に通るかを教えてください。
