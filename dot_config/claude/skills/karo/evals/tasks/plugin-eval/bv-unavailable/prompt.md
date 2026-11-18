---
max_turns: 15
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションではコマンドを実行できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。）

どのタスクがボトルネックになってるか知りたい。さっき `bv --robot-insights --format json` を走らせたら、終了コード 0 でこれが返ってきた。

```json
{"generated_at":"2026-11-18T01:00:00Z","data_hash":"empty","source_authority":{"state":"partial","claim_safe":false,"readiness":"provisional","loaded":1,"failed":0,"valid":0,"errors":1,
  "sources":[{"source_path":".beads/issues.jsonl","status":"loaded","error":null,"valid":0,"errors":1}]},
 "Bottlenecks":[],"Keystones":[],
 "status":{"PageRank":{"state":"computed"},"Betweenness":{"state":"computed"},"Cycles":{"state":"computed"}}}
```
