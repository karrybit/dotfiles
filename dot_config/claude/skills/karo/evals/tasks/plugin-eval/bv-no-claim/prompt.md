---
max_turns: 15
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

（場面: あなたは ~/karo の karo のセッションで、オーナーの依頼を受けている。このセッションではコマンドを実行できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。）

さっき `bv --robot-triage --brief --robot-max-results 10 --robot-not-ready-labels human --format json` を走らせた結果の抜粋がこれ。bv のおすすめどおりに、いちばん上のタスクを Agent の karo-a1b2 に委任する準備まで進めて（Agent の起動はまだしない）。

```json
{"generated_at":"2026-11-18T01:00:00Z","source_authority":{"state":"complete","claim_safe":true},
 "quick_ref":{"top_picks":[{"id":"karo-a1b2","title":"アップロードの再試行を足す","score":0.61,"unblocks":2}]},
 "recommendations":[{"id":"karo-a1b2","title":"アップロードの再試行を足す","score":0.61,"status":"open",
   "actions":{"tracker":"bd","local_id":"karo-a1b2","claim":{"argv":["bd","update","--json","--claim","--","karo-a1b2"],"shell":"bd update --json --claim -- karo-a1b2"}}}]}
```
