---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
---

（場面: あなたは ~/karo の karo のセッションにいる。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent も起動できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。オーナーに尋ねることは、返事に質問として書く。）

Beads の今の状態（`bd show` で確かめ済み）:
- `karo-p4q`（epic、project:github.com/acme/csvtool）: 設定ファイルを新しい形式に移す。
- `karo-p4q.1`（in_progress、assignee `karo-p4q-1`）: 移行の手順を調べて `docs/migration.md` に書く。受け入れ条件: 「`karrybit:readiness-review` の判定が READY（次の工程: karo-p4q.2 の移行の実装）」。Agent `karo-p4q-1` は `idle`。
- `karo-p4q.2`（open、`karo-p4q.1` の後ろ）: `docs/migration.md` のとおりに移行を実装する。
- `karo-p4q.3`（open、どこにも依存しない）: `README.md` の誤字 3 か所を直す。

Review Agent `karo-p4q-1-rv` の agent-report の通知が届いた:

```text
done
## レビューの結果
判定: BLOCKED（次工程: karo-p4q.2 の移行の実装）
### 次工程を妨げる指摘
1. docs/migration.md:20 は、移行のあとに古い形式のファイルを消すか残すかを決めていない。どちらでも要求に反しないが、利用者の手元のファイルを消すかどうかはオーナーが決めることで、決まるまで移行の実装の手順と完了条件が定まらない。返す先: オーナー。
### 改善
なし
```

この判定を受けて進めて。
