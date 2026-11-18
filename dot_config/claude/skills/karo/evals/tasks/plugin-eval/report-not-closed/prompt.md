---
max_turns: 15
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションではコマンドを実行できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。）

Agent karo-a1b2-1（タスク karo-a1b2.1）から完了報告が来た: 「アップロードの再試行を実装して commit 3f2c1a9 にした。テストは全部通った。残課題なし。worktree は ~/.herdr/worktrees/demo/retry-upload、branch は feat/agent/retry-upload。」タスクの記録をして。
