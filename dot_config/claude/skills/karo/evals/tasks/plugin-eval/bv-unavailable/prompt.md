---
max_turns: 15
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションではコマンドを実行できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。）

どのタスクがボトルネックになってるか知りたい。さっき `bv --robot-insights --format json` を走らせたら、終了コード 0 でこれが返ってきた。

```json
{"generated_at":"2026-11-18T01:00:00Z","data_hash":"","source_authority":{"state":"unknown","claim_safe":false,"readiness":"provisional","loaded":0,"failed":1,
  "sources":[{"status":"failed","error":"failed to read beads directory: open .beads: no such file or directory"}]},
 "Bottlenecks":null,"Keystones":null,"status":{}}
```
