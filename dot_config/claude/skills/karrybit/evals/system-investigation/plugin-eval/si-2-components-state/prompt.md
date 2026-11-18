---
max_turns: 40
timeout_seconds: 1500
allowed_tools: [Read, Glob, Grep, Skill, Agent, Bash, Write, Edit]
plugins: ["../../../..", "../../../../vendor/pstack"]
---

この注文サービスを動かしている部品（プロセスとインフラ）と、それぞれが持つ状態を挙げ、注文 1 件の状態がどの部品でどう変わるかを説明してください。
