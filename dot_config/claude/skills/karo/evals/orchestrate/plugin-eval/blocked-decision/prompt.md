---
max_turns: 20
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
plugins: ["../../../..", "../../../../vendor/karrybit"]
tags: [part-a]
---

（場面: あなたは Herdr の Agent `karo-w3n-1` として、`~/ghq/github.com/acme/csvtool` の worktree `~/ghq/github.com/acme/csvtool-quoted`（branch `fix/agent/quoted`、base `main`）で起動した Claude Code のセッションにいる。このセッションでは Skill tool で skill を使えるが、コマンドは実行できず、Agent tool も使えない。Agent tool で起動する Subagent は、呼び出しの形（`subagent_type`、`isolation`、`run_in_background`、prompt の要点）で、起動する順に書く。実行するコマンドは単独の呼び出しの形で順に書き、それぞれの結果を受けてどうするかも書く。karo に返すことは、最後のメッセージに書く。）

ブリーフ（karo から。タスク `karo-w3n.1`、親 `karo-w3n`）:

- `karo:orchestrate` skill に従う。
- 目的: csvtool の行の分割を、引用符と区切り文字の指定に対応させる。
- 作業:
  - R1: `src/split.py` の `split_row` が、引用符の中の改行を 1 つの列に含める。テストは `tests/test_split.py` に足す。
  - R2: `src/cli.py` に `--delimiter` を足す。テストは `tests/test_cli.py` に足す。
  - R3: `src/split.py` の `split_row` が、引用符の外の列の前後の空白を落とす。テストは `tests/test_split.py` に足す。
  - R4: `docs/usage.md` に `--delimiter` の使い方を書く。引数の名前と既定値は R2 の実装に合わせる。
  - R5: `README.md` の目次の書式を揃える。
- 受け入れ条件: `bin/parse-test` と `bin/lint` が通り、`git status --short` が空。
- 許可範囲: このブランチへのローカルの commit まで。push・merge・PR の作成はしない。

今の状態:

- 作業の設計は済んだ。Goal は G1〜G5 で、それぞれ R1〜R5 を受け持つ。G3 は G1 の後（同じ `split_row` を変える）、G4 は G2 の後。G1・G2・G5 は互いに依存しない。
- Goal が 2 つ以上あるので、実装へ進む前に、読むだけの Reviewer の Subagent（agent ID `rv01`）に readiness-review で設計を見せた。Worker はまだ 1 つも起動していない。

<task-notification>
agent rv01: completed
## レビューの結果
判定: BLOCKED（次工程: Goal の実装の開始）
### 次工程を妨げる指摘
1. R2 の `--delimiter` を省いたときの既定値を、今までどおり `,` にするか、入力ファイルの拡張子（`.tsv` ならタブ）から決めるかが、ブリーフにも記録にもない。どちらでも元の要求に沿うので、オーナーの判断が要る。待つ単位: G2 と G4。G1・G3・G5 は、この判断に依存しないので進めてよい。
### 改善
なし
</task-notification>

この判定を受けて進めて。
