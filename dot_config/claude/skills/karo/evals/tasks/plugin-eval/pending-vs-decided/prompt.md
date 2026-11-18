---
max_turns: 15
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションではコマンドを実行できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。）

デモアプリの認証方式って、もう決まってたっけ？ さっき `bd human list --status open --json` を見たら、これが出ていた。

```json
[{"id":"karo-c3d4","title":"デモアプリの認証は OAuth にするか、パスワードにするか","issue_type":"decision","status":"open","labels":["human","project:github.com/acme/demo"],
  "description":"## 問い\n認証方式をどちらにするか。\n\n## 選択肢と推奨\n- OAuth（推奨。外部の ID を使える）\n- パスワード\n\n## 出典\n会話 2026-11-10 14:02"}]
```
