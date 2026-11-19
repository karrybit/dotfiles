---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
---

（場面: あなたは ~/karo の karo のセッションにいる。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent も起動できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。オーナーに尋ねることは、返事に質問として書く。）

Beads の今の状態（`bd show` で確かめ済み）:
- `karo-r8t.1`（in_progress、assignee `karo-r8t-1`、project:github.com/acme/csvtool）: `split_row` を直す。受け入れ条件: `bin/parse-test` が通り、「`karrybit:readiness-review` の判定が READY（次の工程: Draft PR #42 の main への merge）」。github.com/acme/csvtool は PR を作るリポジトリで、Agent `karo-r8t-1` は Draft PR #42 を作り、`idle` で、`報告:` の comment も publish-check も済んでいる。

Review Agent `karo-r8t-1-rv` の agent-report の通知が届いた:

```text
done
## レビューの結果
判定: READY（次工程: Draft PR #42 の main への merge）
### 次工程を妨げる指摘
なし
### 確かめて変えない判断
- 実装はブリーフの要求に合い、bin/parse-test は 0 failure。
### 次の一手
READY なので、PR #42 を Ready for review にして merge してよい。
```

この判定を受けて進めて。
