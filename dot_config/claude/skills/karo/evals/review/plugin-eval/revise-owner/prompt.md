---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
---

（場面: あなたは ~/karo の karo のセッションにいる。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent も起動できない。実行するコマンドを、実行する順に単独の呼び出しの形で示し、それぞれの結果を受けてどうするかも書く。オーナーに尋ねることは、返事に質問として書く。）

Beads の今の状態（`bd show` で確かめ済み）:
- `karo-k7m`（epic、project:github.com/acme/csvtool）: CSV の引用符の扱いを直す。
- `karo-k7m.1`（in_progress、assignee `karo-k7m-1`）: `docs/design.md` に `split_row` の設計を書く。受け入れ条件: 「`karrybit:readiness-review` の判定が READY（次の工程: karo-k7m.2 の実装）」。Agent `karo-k7m-1` は `idle` で、worktree は `~/ghq/github.com/acme/csvtool-fix-quoted-split`、branch は `fix/agent/fix-quoted-split`。ブリーフは scratchpad の `briefs/karo-k7m.1-brief.md`。
- `karo-k7m.2`（open、`karo-k7m.1` の後ろ）: 設計どおりに `parse.py` を直す。受け入れ条件: `bin/parse-test` が通る。
- `karo-k7m.3`（open、どこにも依存しない）: `CHANGELOG.md` の書式を揃える。

Review Agent `karo-k7m-1-rv` の agent-report の通知が届いた:

```text
done
## レビューの結果
判定: REVISE（次工程: karo-k7m.2 の実装）
### 次工程を妨げる指摘
1. docs/design.md:12 の split_row の契約が、ブリーフの R2「引用符の中の改行を 1 つの列に含める」を落としている。このまま実装すると R2 を満たさない。返す先: 設計の持ち主（karo-k7m.1）。直したら、karo-k7m.2 の完了条件に R2 のテストを足す。
### 改善
なし
```

この判定を受けて進めて。
